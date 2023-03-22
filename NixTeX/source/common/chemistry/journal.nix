{ chemistry, core, document, ... }:
let
  inherit(chemistry)  compound;
  inherit(core)       debug indentation integer list set string type;

  formatJournal'
  =   substance:
        if substance ? simple
        then
          "\\ch{${substance.simple}}"
        else
          compound.format substance.title;

  formatJournal
  =   product:
        if      product.ignore or false
        then
          null
        else if product.substance != null
        then
          if list.isInstanceOf product.substance
          then
            string.concatWith " + " ( list.map formatJournal' product.substance )
          else
            formatJournal' product.substance
        else if product ? title
        then
          "\\textbf{${product.title}}"
        else
          "a???";

  productAsList
  =   syn:
      product:
        type.matchPrimitiveOrDefault product
        {
          list                          =   product;
          lambda                        =   productAsList syn ( product syn );
        }
        [ product ];

  idToFloat
  =   id:
        let
          matched                       =   string.match "([0-9]+)([A-Z])" id;
          letters                       =   string.toCharacters "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
          letters'                      =   list.generate (x: { name = list.get letters x; value = 0.01 * x; } ) ( list.length letters );
          lookUpLetter                  =   list.toSet letters';
        in
          if matched != null
          then
            integer ( list.get matched 0 ) + lookUpLetter.${ list.get matched 1 }
          else
            0;

  compareIDs
  =   a:
      b:
        let
          a'                            =   if string.isInstanceOf a.id then idToFloat a.id else a.id;
          b'                            =   if string.isInstanceOf b.id then idToFloat b.id else b.id;
        in
          a' < b';

  generateJournal'
  =   items:
        let
          items'
          =   list.fold
              (
                items:
                item:
                  if item ? journal
                  then
                    items
                    ++  (
                          list.map
                          (
                            id:
                            {
                              inherit id;
                              title     =   item.title or "—";
                              product   =   formatJournal item;
                              reaction  =   item.reaction or null;
                              chemicals =   item.chemicals or {};
                            }
                          )
                          item.journal
                        )
                  else
                    items ++ ( generateJournal' ( productAsList null ( item.product or [ ] ) ) )
              )
              [ ]
              items;
        in
          list.sort compareIDs items';

  formatJournalEntry
  =   entry:
        if entry.product != null
        then let
          getSimple
          =   input:
                if      input.substance or null != null
                then
                  input.substance.simple or "b???"
                else if input.acronym or null != null
                then
                  "<${input.acronym}>"
                else if input.simple or null != null
                then
                  input.simple
                else
                  null;
          mapInput
          =   list.map
              (
                input:
                  if list.isInstanceOf input
                  then let
                    simple              =   getSimple ( list.get input 1 );
                  in
                    "\\ch{${string ( list.get input 0 )} ${if simple != null then simple else "??"}}"
                  else let
                    simple              =   getSimple input;
                  in if simple != null
                  then
                    "\\ch{${simple}}"
                  else
                    "c???"
              );
          inputs
          =   if entry.reaction != null
              then let
                reaction                =   entry.reaction entry;
                first                   =   list.head reaction;
                other                   =   list.filter ( entry: set.isInstanceOf entry && entry ? input ) reaction;
                other'                  =   list.concatMap ( entry: entry.input ) other;
              in
                string.concatWith " + " ( mapInput ( first ++ other' ) )
              else
                "…";
        in
          debug.debug "formatJournalEntry" "${string entry.id}: ${entry.product}" "${string entry.id} & ${inputs} & ${entry.product}\\\\"
        else
          debug.debug "formatJournalEntry" "${string entry.id}: ${entry.title}" "${string entry.id} & \\multicolumn{2}{l}{${entry.title}} \\\\";

  generateJournal
  =   syntheses:
      { ... } @ arguments:
        let
          syntheses'
          =   if path.isInstanceOf syntheses
              then
                import syntheses ( { core = null; } // arguments )
              else
                syntheses;
        in
          document.LaTeX
          (
            [
              "\\ltable{l|l@{$\\rightarrow$}l}"
              "{Kürzel  & \\multicolumn{2}{l}{Reaktion und Produkt} \\\\}"
              "{Kürzel  & \\multicolumn{2}{l}{Reaktion und Produkt} \\\\}"
              "{" indentation.more
            ]
            ++  ( list.map formatJournalEntry ( generateJournal' syntheses' ) )
            ++  [
                  indentation.less "}"
                  "{}{}"
                  "{Zuordnung der Kürzel im Labor\\-journal zu den durchgeführten Reaktionen/Produkten.}"
                  "{ZuordnungKuerzelReaktion}"
                ]
          );
in
{
  inherit generateJournal;
}