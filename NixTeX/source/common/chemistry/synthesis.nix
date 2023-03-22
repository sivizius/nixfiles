{ chemistry, core, document, physical, ... }:
let
  inherit(core)       debug error indentation list number set string type;
  inherit(chemistry)  compound elements ir ms nmr values;
  inherit(elements)   calculateMassOfFormula normaliseMolecularFormula tableOfMasses;
  inherit(document)   Heading Heading' LaTeX Paragraph Paragraph';
  inherit(tableOfMasses) Cu I;

  default                               =   a: b: if a != null then a else b;

  # null | [ Any ] | T
  # -> [ ] | [ Any ] | [ T ]
  toList
  =   value:
        type.matchPrimitiveOrDefault value
        {
          null                          =   [ ];
          list                          =   value;
        }
        [ value ];

  # string | [ ? ] -> [ Document::Chunk.Paragraph ]
  toParagraphs
  =   listOrString:
        type.matchPrimitiveOrPanic listOrString
        {
          string                        =   [ ( Paragraph listOrString ) ];
          list                          =   list.map (paragraph: Paragraph paragraph) listOrString;
        };

  # bool -> Synthesis -> [ Document::Chunk.Paragraph ]
  mapProcedure
  =   _newline:
      { ... } @ synthesis:
        let
          procedure                     =   string.trim' synthesis.procedure;
          result
          =   type.matchPrimitiveOrPanic synthesis.procedure
              {
                lambda                  =   list.map (paragraph: Paragraph' paragraph { endParagraph = "\\par"; }) ( synthesis.procedure synthesis );
                string                  =   [ ( Paragraph procedure ) ];
                list                    =   list.map (paragraph: Paragraph' paragraph { endParagraph = "\\par"; }) ( synthesis.procedure );
              };
        in
          result;

  # Synthesis -> Product -> [ Document::Chunk ]
  formatAnalysis
  =   { ... } @ resources:
      { ... } @ synthesis:
      { analysisOnly ? false, hack ? false, ... } @ product:
        let
          substance                     =   product.substance or synthesis.substance or { };
          yield                         =   product.yield or {};
          yield'
          =   if isLambda yield
              then
                yield product
              else
                yield;
          mass                          =   yield'.mass;
          amount                        =   yield'.amount or ( mass / ( substance.dalton or 1 ) );
          amount'                       =   normaliseValue ( amount ) null;

          equivalent                    =   yield'.equivalent or 1;
          relativeEquivalents
          =   if equivalent != 1
              then
                " (${physical.formatValue equivalent "equivalent"})"
              else
                "";
          # float
          relative
          =   let
                relative                =   ( yield'.relative or ( amount / ( reactant'.amount or amount ) * 100 ) ) * 1.0 * equivalent;
              in
                if relative > 100
                then
                  debug.warn "formatAnalysis"
                  {
                    text                =   "Yield is over 100 %: ${string relative}!";
                    data                =   yield';
                  }
                  relative
                else
                  relative;

          # string | { title: string }
          reactant                      =   yield'.reactant or "???";

          # string
          title
          =   type.matchPrimitiveOrPanic reactant
              {
                set
                =   if reactant.title != null
                    then
                      reactant.title
                    else
                      reactant.substance.ID;
                string                  =   reactant;
              };

          # set
          reactant'
          =   if set.isInstanceOf reactant
              then
                reactant
              else
                { };

          # string
          novel                         =   product.novel or substance.novel or false;
          novelText                     =   "Diese Verbindung ist bisher literatur\\-unbekannt.";

          # float
          purity                        =   ( yield'.purity or 1 ) * 1.0;

          # string
          purity'
          =   if purity != 1.0
              then
                "etwa ${physical.formatValue { value = 100*purity; precision = 1; } "percent"}-iger Reinheit und "
              else
                "";

          # string
          mass'
          =   if purity != 1.0
              then
                "rein: ${physical.formatValue { value = mass * purity; precision = 2; } "gram"}, "
              else
                "";

          warn
          =   name:
                debug.warn "formatAnalysis"
                {
                  when                  =   product.novel or substance.novel or false;
                  text                  =   "${name}-data missing for novel compound ${substance.name}";
                };

          otherData#: T = int|float|{ from: int|float, till: int|float }|null @ {
          #   melting:        T,
          #   boiling:        T,
          #   sublimation:    T,
          #   decomposition:  T,
          #   density:        int|float|null,
          # }?
          =   product.physical  or ( warn "Physical" null );
          eaData                        =   substance.elements  or  product.elements  or  ( warn "EA"   { } );
          irData                        =   substance.ir        or  product.ir        or  ( warn "IR"   [ ] );
          msData                        =   substance.ms        or  product.ms        or  ( warn "MS"   { } );
          nmrData                       =   substance.nmr       or  product.nmr       or  ( warn "NMR"  { } );
          reports
          =   [] # Elementaranalyse
          ++  ( values.report   resources           otherData )
        # ++  ( elements.report resources substance Elements  )
          ++  ( nmr.report      resources           nmrData   )
          ++  ( ir.report       resources           irData    )
          ++  ( ms.report       resources           msData    );
          failure                       =   synthesis.failure or false || product.failure or false;
        in
          [
            (
              Paragraph'
                (
                  if analysisOnly
                  then
                    if novel
                    then
                      [ novelText ]
                    else
                      []
                  else if failure
                  then
                    if yield' == {}
                    then
                      [ "Es konnte kein Produkt erhalten werden." ]
                    else
                      [
                        "Es konnte kein Produkt erhalten werden und"
                        "  ${physical.formatValue { value = mass; precision = 2; } "gram"}"
                        "    (${physical.formatValue { value = amount'.value; precision = 2; } "${amount'.prefix}mol"})"
                        "  des eingesetzten ${title} wurden zurückgewonnen."
                      ]
                  else if yield' == {}
                  then
                    [ "Erhalten wurde eine unbestimmte Menge ${product.description or "Produkt"}." ]
                  else
                    [
                      "Erhalten wurden ${physical.formatValue { value = mass; precision = 2; } "gram"}"
                      "  (${mass'}${physical.formatValue { value = amount'.value*purity; precision = 2; } "${amount'.prefix}mol"})"
                      "  ${product.description or "Produkt"} mit \\mbox{${purity'}${physical.formatValue { value = relative*purity; precision = 1; } "percent"}-iger} Ausbeute"
                      "    bezogen auf eingesetztes ${title}${relativeEquivalents}.${if novel then " ${novelText}" else ""}"
                    ]
                )
                {
                  endParagraph
                  =   if !hack
                      then
                        "\\par"
                      else
                        "\\par";
                  /*endParagraph
                  =   if  !failure
                      &&  any (x: x != [] && x != {} && x != null) [ eaData irData msData nmrData otherData ]
                      then
                        ""
                      else
                        "\\newline";*/
                }
            )
          ]
          ++  (
                if failure
                then
                  []
                else
                  reports
              );

  # Synthesis -> Product -> Document::Chunk.Paragraph | null
  formatProductChemicals
  =   { ... } @ resources:
      { ... } @ syn:
      { ... } @ product:
        if product ? "chemicals"
        then
          let
            chemicals
            =   type.matchPrimitiveOrPanic product.chemicals
                {
                  null                  =   [ ];
                  set                   =   set.values product.chemicals;
                  list                  =   product.chemicals;
                };
            len                         =   list.length chemicals;
            endParagraph                =   "\\par";
          in
            if len > 1
            then
              Paragraph'
                (
                  [ "Eingesetzt wurden:" ]
                  ++  ( generate (x: "  ${formatChemical (list.get chemicals x)},") ( len - 2 ) )
                  ++  [
                        "  ${formatChemical (list.get chemicals ( len - 2 ))} und"
                        "  ${formatChemical (list.get chemicals ( len - 1 ))}."
                      ]
                )
                { inherit endParagraph; }
            else if len == 1
            then
              Paragraph'
                [ "Eingesetzt wurden ${formatChemical ( list.head chemicals)}." ]
                { inherit endParagraph; }
            else
              null
        else
          null;

  # Synthesis -> [ Document::Chunk.Heading ]
  mapProducts
  =   { ... } @ resources:
      { ... } @ synthesis:
        map
        (
          {
            chemicals ? {},
            clearPage ? false,
            note      ? null,
            substance ? null,
            title     ? null,
            name      ? null,
            noHeading ? false,
            noMolecule ? false,
            postAnalysis  ? [],
            lines ? null,
            ...
          } @ product:
            let
              product'
              =   product
              //  {
                    inherit clearPage name substance title;
                    chemicals           =   fixChemicals resources chemicals;
                  };
              body
              =   ( toList ( formatProductChemicals resources synthesis product' ) )
              ++  (
                    if note != null
                    then
                      if lambda.isInstanceOf note
                      then
                        [ (note product') ]
                      else
                        [ note ]
                    else
                      []
                  )
              ++  ( formatAnalysis resources synthesis product' )
              ++  postAnalysis;

              lines'
              =   if lines != null
                  then
                    "[${string lines}]"
                  else
                    "";

              body'
              =   LaTeX
                  (
                    if substance != null
                    && !noMolecule
                    then
                      [
                        "\\renewcommand{\\NumAtom}[2]{}%"
                        #"\\renewcommand{\\NumAtom}[2]{-[#1,,,draw=none]{\\scriptstyle#2}}%"
                        "\\Wrapchem${lines'}{${substance { mass = true; structure = true; }}}"
                        "{" indentation.more
                      ]
                      ++  body
                      ++  [ indentation.less "}"  ]
                    else
                      body
                  );

              body''
              =   if noHeading
                  then
                    body'
                  else if substance != null
                  then
                    Heading'
                    {
                      bookmark          =   "${substance.Name}";
                      caption           =   "${substance.NameID}";
                    }
                    [ body' ]
                    {
                      inherit clearPage;
                      label             =   "substance:${substance.name or name}";
                      clearPageOnLastQuarter = true;
                    }
                  else if title != null
                  then
                    Heading'
                    {
                      bookmark          =   "${compound title}";
                      caption           =   "${compound title}";
                    }
                    [ body' ]
                    {
                      inherit clearPage;
                      label             =   "substance:${name}";
                      clearPageOnLastQuarter = true;
                    }
                  else
                    body';
            in
              body''
        );

  getFullTitle
  =   { acronyms, ... }:
      { casus, degased, dry, molar, solvent, title }:
        if      solvent != null
        then
          let
            # ToDo: Export to fluent-module
            specialSolvents
            =   {
                  "H2O"                 =   { deu = "wässrige";                             eng = "aqueous";                           };
                  "Et2O"                =   { deu = "${acronyms.Et2O.as "etherische"}";     eng = "${acronyms.Et2O.as "etheral"}";     };
                  "EtOH"                =   { deu = "${acronyms.EtOH.as "ethanolische"}";   eng = "${acronyms.EtOH.as "ethanolic"}";   };
                  "MeOH"                =   { deu = "${acronyms.MeOH.as "methanolische"}";  eng = "${acronyms.MeOH.as "methanolic"}";  };
                  "NH3"                 =   { deu = "ammoniakalische";                      eng = null;                                };
                  "HCl"                 =   { deu = "salz\\-saure";                         eng = null;                                };
                  "HNO3"                =   { deu = "salpeter\\-saure";                     eng = null;                                };
                  "H2SO4"               =   { deu = "schwefel\\-saure";                     eng = null;                                };
                };
            special                     =   specialSolvents.${solvent}.deu or null;
            acronym
            =   {
                  THF                   =   acronyms."tetrahydrofuran";
                  tetrahydrofuran       =   acronyms."tetrahydrofuran";
                }.${solvent} or null;
          in
            if isString solvent
            then
              if      special != null then  "${special}${default casus "r"} ${molar}${title}\\-lösung"
              else if acronym != null then  "${molar}${title}-Lösung in ${acronym.long}"
              else                          "${molar}${title}-Lösung in ${compound solvent}"
            else                            "${molar}${title}-Lösung in ${getTitle solvent}"
        else if dry && degased        then  "trockene${default casus "m"} und entgaste${default casus "m"} ${title}"
        else if dry                   then  "trockene${default casus "m"} ${title}"
        else if degased               then  "entgaste${default casus "m"} ${title}"
        else                                "${molar}${title}";

  fixChemical
  =   { acronyms, ... } @ resources:
      { ... } @ chemicals:
      name:
      { acronym, casus, concentration, mixture, purity, relative, substance, title, ... } @ chemical:
        let
          molar
          =   if      purity != 1.0
              then
                "${physical.formatValue ( purity * 100 ) "percent"}-ige${default casus "r"}~"
              else
                type.matchPrimitiveOrPanic concentration
                {
                  null                  =   "";
                  int                   =   "${formatConcentration concentration}~";
                  float                 =   "${formatConcentration concentration}~";
                  list                  =   "${concatWith ":" ( list.map formatConcentration concentration)}~";
                  string
                  =   {
                        "conc"          =   "${acronyms.concentrated.short} ";
                        "sat"           =   "${acronyms.saturated.short} ";
                        "dil"           =   "${acronyms.diluted.short} ";
                      }.${concentration}
                  or  (
                        debug.panic "fixChemical" "Invalid Concentration »${concentration}«"
                      );
                };

          chemical'
          =   chemical
          //  {
                title
                =   getFullTitle  resources
                    {
                      inherit molar;
                      title             =   getTitle { inherit acronym mixture substance title; };
                      inherit(chemical) casus dry degased solvent;
                    };
              };

          relative'
          =   chemicals.${relative}
          or  (
                debug.panic
                  "fixChemical"
                  "While calculating equivalent for ${name}: There is no chemical »${relative}«!"
              );
        in
          if relative != null
          then
            chemical'
            //  {
                  equivalent
                  =   debug.warn "fixChemical"
                      {
                        text            =   "relative";
                        data
                        =   {
                              chemical  =   { inherit(chemical) amount; };
                              relative  =   { inherit(relative') amount equivalent; };
                              ratio     =   chemical.amount / relative'.amount;
                            };
                      }
                      ( chemical.amount / relative'.amount * relative'.equivalent);
                }
          else
            chemical';

  # ( string -> Chemical ) -> ( string -> Chemical )
  fixChemicals
  =   { ... } @ resources:
      { ... } @ chemicals:
        set.map
        (
          name:
          { ... } @ chemical:
            type.matchPrimitiveOrPanic chemical
            {
              list                      =   list.map (fixChemical resources chemicals name) chemical;
              set                       =   fixChemical resources chemicals name chemical;
            }
        )
        chemicals;

  # F -> G -> [ T ] -> [ ( F T ) ]
  filterMap                             =   m: f: self: filter f ( list.map m self );

  # [ Synthesis ] -> [ Document::Chunk.Heading ] | !
  mapSyntheses
  =   { ... } @ resources:
      syntheses:
        filterMap
        (
          { ... } @ syn:
            let
              syn'
              =   syn
              //  {
                    chemicals           =   fixChemicals resources syn.chemicals;
                  };
              mapSubstances
              =   string.concatMappedWith
                  (
                    { ... } @ substance:
                      "${substance { mass = true; structure = true; }}"
                  )
                  "\\arrow{0}[-90,0.3]";
              product
              =   if syn'.product or null != null
                  then
                    type.type.matchPrimitiveOrDefault syn'.product
                    {
                      lambda            =   syn'.product syn';
                      list
                      =   list.map
                          (
                            product:
                              type.callLambda product syn'
                          )
                          syn'.product;
                    }
                    syn'.product
                  else
                    [];
              citeLiterature
              =   { literature ? null, ... }:
                    type.matchPrimitiveOrPanic literature
                    {
                      null              =   "";
                      list              =   "\\cite{${string.concatMappedWith ({ name, ... }: name) "," literature}}";
                      set               =   "\\cite{${literature.name}}";
                    };
              formattedAnalysis
              =   type.matchPrimitiveOrPanic product
                  {
                    null                =   [ ];
                    list
                    =   if product != []
                        then
                          mapProducts resources syn' product
                        else
                          [
                            (
                              Paragraph'
                              [ "Es konnte kein Produkt erhalten werden." ]
                              { endParagraph = ""; }
                            )
                          ];
                    set
                    =   formatAnalysis resources syn'
                        (
                          product // { chemicals = fixChemicals resources product.chemicals; }
                        );
                  };

              lines'
              =   if syn'.lines or null != null
                  then
                    "[${string syn'.lines}]"
                  else
                    "";
            in
              if syn'.ignore or false
              then
                null
              else
                (
                  if syn'.title or null != null
                  then
                    Heading'
                    (
                      if type.isSet syn'.title
                      then
                        syn'.title
                      else
                      {
                        bookmark          =   syn'.title;
                        caption           =   "${syn'.title}${citeLiterature syn'}";
                      }
                    )
                    (
                      if syn'.substances or null != null
                      then
                        LaTeX
                        (
                          [
                            "\\renewcommand{\\NumAtom}[2]{-[#1,,,draw=none]{\\scriptstyle#2}}%"
                            "\\Wrapchem${lines'}{${mapSubstances syn'.substances}}"
                            "{" indentation.more
                          ]
                          ++  ( mapProcedure true syn' )
                          ++  formattedAnalysis
                          ++  [ indentation.less "}"  ]
                        )
                      else
                        ( mapProcedure false syn' )
                        ++  formattedAnalysis
                    )
                    {
                      clearPageOnLastQuarter = true;
                    }
                  else if syn'.substance or null != null
                  then
                    Heading'
                    {
                      bookmark          =   "${syn'.substance.Name}";
                      caption           =   "${syn'.substance.NameID}${citeLiterature syn'}";
                      LaTeX             =   true;
                    }
                    (
                      LaTeX
                      (
                        [
                          "\\renewcommand{\\NumAtom}[2]{-[#1,,,draw=none]{\\scriptstyle#2}}%"
                          "\\Wrapchem${lines'}{${syn'.substance { mass = true; structure = true; }}}"
                          "{" indentation.more
                        ]
                        ++  ( mapProcedure true syn' )
                        ++  formattedAnalysis
                        ++  [ indentation.less "}"  ]
                      )
                    )
                    {
                      label             =   "substance:${syn'.substance.name}";
                      clearPage         =   syn'.clearPage or false;
                      clearPageOnLastQuarter = true;
                    }
                  else
                    debug.panic "mapSyntheses" "Either substance or title must be set!"
                )
        )
        (x: x != null)
        syntheses;

  # Chemical -> string
  formatDetails
  =   { ... } @ chemical:
        if list.isInstanceOf chemical  then  concatWith "; " ( list.map formatDetails' chemical )
        else                      formatDetails' chemical;

  # Chemical -> string
  formatDetails'
  =   { ... } @ chemical:
        let
          details
          =   (
                if chemical.substance != null
                then
                  [ chemical.substance.ID ]
                else
                  [ ]
              )
          ++  (
                if chemical.volume != null
                then
                  let
                    precision
                    =   if chemical.kind != "solvent" then  null
                        else if chemical.volume < 20  then  1
                        else                                0;

                    volume              =   normaliseValue ( chemical.volume / 1000.0 )                   null;
                    volume'             =   physical.formatValue { value = volume.value; inherit precision; }     "${volume.prefix}litre";

                    fullVolume          =   normaliseValue ( chemical.times * chemical.volume / 1000.0 )  null;
                    fullVolume'         =   physical.formatValue { value = fullVolume.value; inherit precision; } "${fullVolume.prefix}litre";
                  in
                    if chemical.times != null then  [ "${string chemical.times}×${volume'}=${fullVolume'}" ]
                    else
                      [ volume' ]
                else
                  [ ]
              )
          ++  (
                if chemical.mass != null
                then
                  let
                    mass                =   normaliseValue ( chemical.mass ) null;
                    volume              =   normaliseValue ( chemical.solvent.volume / 1000.0 ) (-3);
                    precision
                    =   if chemical.solvent.volume < 20 then  1
                        else                                  0;
                    solvent
                    =   if chemical.solvent != null
                        && chemical.solvent ? volume
                        then
                          " in ${physical.formatValue { value = volume.value; inherit precision; } "${volume.prefix}litre"}"
                        else
                          "";
                  in
                    [ "${( physical.formatValue { value = mass.value; precision = 2; } "${mass.prefix}gram" )}" ]
                else
                  [ ]
              )
          ++  (
                if chemical.amount != null
                then let
                  amount                 =   normaliseValue ( chemical.amount ) ( chemical.factor or null );
                in
                  [ ( physical.formatValue { value = amount.value; precision = 2; } "${amount.prefix}mol" ) ]
                else
                  [ ]
              )
          ++  (
                if chemical.equivalent != null
                then
                  debug.info "formatDetails'" { text = "Equivalent"; data = chemical.equivalent; }
                  (
                    if chemical.kind == "catalyst"  then  [ ( physical.formatValue { value = chemical.equivalent; precision = null; } "equivalent" ) ]
                    else                                  [ ( physical.formatValue { value = chemical.equivalent; precision = 1; } "equivalent" ) ]
                  )
                else
                  [ ]
              )
          ++  (
                if chemical.details != null then  [ chemical.details ]
                else                              [ ]
              );
        in
          string.concatCSV details;

  getUnitPrefix#: integer -> string | !
  =   factor:
        if      factor == -24 then  "yokto"
        else if factor == -21 then  "zepto"
        else if factor == -18 then  "atto"
        else if factor == -15 then  "femto"
        else if factor == -12 then  "pico"
        else if factor == -9  then  "nano"
        else if factor == -6  then  "micro"
        else if factor == -3  then  "milli"
        else if factor == 0   then  ""
        else if factor == 3   then  "kilo"
        else if factor == 6   then  "mega"
        else if factor == 9   then  "giga"
        else if factor == 12  then  "tera"
        else if factor == 15  then  "peta"
        else if factor == 18  then  "exa"
        else if factor == 21  then  "zetta"
        else if factor == 24  then  "yotta"
        else error.throw "getUnitPrefix: Invalid Factor: ${string factor}";

  # Number -> null | Number -> { value: Number; prefix = string; }
  normaliseValue
  =   input:
      factor:
        let
          absInput                      =   number.abs input;
          factor'
          =   if factor != null                                     then  factor
              else if absInput >= 1000000000000000.0                then   15
              else if absInput >=    1000000000000.0                then   12
              else if absInput >=       1000000000.0                then    9
              else if absInput >=          1000000.0                then    6
              else if absInput >=             1000.0                then    3
              else if absInput >=                1.0                then    0
              else if absInput >=                0.001              then   -3
              else if absInput >=                0.000001           then   -6
              else if absInput >=                0.000000001        then   -9
              else if absInput >=                0.000000000001     then  -12
              else if absInput >=                0.000000000000001  then  -15
              else                                                          0;
          prefix                        =   getUnitPrefix factor';
          value                         =   input * ( number.pow 10 ( 0 - factor' ) );
        in
          { inherit value prefix; };

  # { acronym, mixture, substance, title, ... } -> string
  getTitle
  =   { acronym ? null, mixture ? null, substance ? null, title ? null, ... }:
        if      title     !=  null  then  compound title
        else if acronym   !=  null  then  acronym.long
        else if substance !=  null  then  substance.Name
        else if mixture   !=  null  then  string.concatMappedWith getTitle "-" mixture
        else                              "???";

  # Chemical -> string
  formatName
  =   { ... } @ chemical:
        if list.isInstanceOf chemical
        then
          "${string.concatMappedWith ({ title, ... }: title) "-" chemical}-Mischung"
        else
          if chemical.the or null != null
          then
            "${chemical.the} ${chemical.title}"
          else
            chemical.title;

  # Chemical -> string
  formatChemical
  =   { ... } @ chemical:
        let
          name                          =   formatName chemical;
          details                       =   formatDetails chemical;
        in
          if details != ""
          then
            "${name} (${details})"
          else
            name;

  # Number -> string | !
  formatConcentration
  =   concentration:
        let
          concentration'                =   normaliseValue concentration null;
        in
          if concentration != null
          then
            "${( physical.formatValue { value = concentration'.value; precision = 1; } "${concentration'.prefix}molar" )}"
          else
            debug.panic "formatConcentration" "Concentration is null!";

  Chemical
  =   kind:
      {
        acronym       ? null,
        amount        ? null,
        concentration ? null,
        dalton        ? null,
        degased       ? false,
        density       ? null,
        details       ? null,
        dry           ? false,
        equivalent    ? null,
        factor        ? null,
        formula       ? null,
        mass          ? null,
        mixture       ? null,
        purity        ? 1.0,
        relative      ? null,
        simple        ? null,
        solvent       ? null,
        substance     ? null,
        the           ? null,
        times         ? null,
        title         ? null,
        volume        ? null
      } @ chemical:
      casus:
        let
          formula'                      =   normaliseMolecularFormula ( default formula ( substance.formula or [ ] ) );
          dalton'                       =   calculateMassOfFormula formula';

          chemical'
          =   {
                __type__                =   "Chemical";
                concentration
                =   if      concentration != null then  concentration
                    else if mixture       != null then  list.map ({ concentration ? null, ... }: concentration) mixture
                    else                                null;

                dalton                  =   default dalton  ( substance.dalton  or dalton'  );
                density                 =   default density ( substance.density or null     );
                formula                 =   formula';
                inherit acronym amount casus degased details dry equivalent factor kind mass mixture purity relative simple
                        solvent substance the times title volume;
              };

          chemical''
          =   chemical'
          //  {
                amount
                =   debug.info "chemical"
                    {
                      data              =   chemical;
                    }
                    (
                      if      chemical'.amount != null          then  chemical'.amount
                      else if chemical'.volume != null
                      then
                        if      chemical'.mass != null          then  debug.panic "Chemical" "Volume and mass are mutualy exclusive!"
                        else if chemical'.concentration != null
                        then
                          if isFloat chemical'.concentration    then  chemical'.volume * chemical'.concentration / 1000
                          else                                        null
                        else if chemical'.density != null
                        &&      chemical'.dalton  != null       then  chemical'.purity * chemical'.volume * chemical'.density / chemical'.dalton
                        else                                          null
                      else if chemical'.mass != null
                      then
                        if chemical'.dalton != null             then  chemical'.mass / chemical'.dalton
                        else                                          null
                      else                                            null
                    );
              };
        in
          if  kind == "reagent"
          ||  kind == "catalyst"
          then
            if chemical''.amount == null
            then
              debug.panic "Chemical"
              {
                text                    =   "Catalysts and Reagents need to have amount of substance (`amount`) given. Perhaps you want Material.";
                data                    =   chemical'';
              }
            else if chemical''.equivalent == null
            &&      chemical''.relative == null
            then
              debug.panic "Chemical" "Catalysts and Reagents need to have `equivalent` given. Perhaps you want Material."
            else
              chemical''
          else
            chemical'';

  Catalyst'                             =   { ... } @ attrs: Chemical   "catalyst"  attrs;
  Material'                             =   { ... } @ attrs: Chemical   "material"  attrs;
  Product'                              =   { ... } @ attrs: Chemical   "product"   attrs;
  Reagent'                              =   { ... } @ attrs: Chemical   "reagent"   attrs;
  Solvent'                              =   { ... } @ attrs: Chemical   "solvent"   attrs;
  Catalyst                              =   { ... } @ attrs: Catalyst'              attrs null;
  Material                              =   { ... } @ attrs: Material'              attrs null;
  Product                               =   { ... } @ attrs: Product'               attrs null;
  Reagent                               =   { ... } @ attrs: Reagent'               attrs null;
  Solvent                               =   { ... } @ attrs: Solvent'               attrs null;
in
{
  inherit mapSyntheses;
  inherit formatChemical formatDetails formatName;
  inherit Catalyst  Material  Product   Reagent   Solvent;
  inherit Catalyst' Material' Product'  Reagent'  Solvent';
}
