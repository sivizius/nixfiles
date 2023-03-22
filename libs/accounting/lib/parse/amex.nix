{ common, core, helpers, ... }:
  let
    inherit(common) Transaction;
    inherit(core) debug expression list path string;
    inherit(helpers) parseAmountComma parseBritishDateTime trim;

    convertTransaction
    =   { currency, lookUpAccount, self, ... }:
        { Adresse, Beschreibung, Betrag, Betreff, Datum, Kategorie, Land, PLZ, Stadt, ... } @ transaction:
          let
            address
            =   {
                  country               =   trim Land;
                  municipality          =   trim Stadt;
                  postalCode            =   trim PLZ;
                  text                  =   trim Adresse;
                };
            amount                      =   parseAmountComma Betrag currency;
            category                    =   trim Kategorie;
            client
            =   lookUpAccount
                {
                  inherit address category description details message subject uid;
                };
            dateTime                    =   parseBritishDateTime Datum "00:00:00";
            description                 =   trim Beschreibung;
            details                     =   trim transaction."Weitere Details";
            uid
            =   if description == "ZAHLUNG/ÜBERWEISUNG ERHALTEN BESTEN DANK"
                then
                  "American Express"
                else
                  trim (list.head (string.splitLines description));
            message                     =   trim transaction."Erscheint auf Ihrer Abrechnung als";
            subject                     =   trim Betreff;
          in
            Transaction
            {
              inherit dateTime description;
              credit                    =   { ${client.uid} = amount; };
              debit                     =   { ${self.uid}   = amount; };
            };

    next
    =   { case, columns, index, quote, transaction, text, journal } @ state:
        cell:
          let
            field                       =   list.get columns index;
            index'                      =   index + 1;

            isCell                      =   string.isInstanceOf cell;
            isColumnSep                 =   sep == ",";
            isFinalCell                 =   index' == list.length columns;
            isLineBreak                 =   sep == "\n";

            quoted                      =   string.match "\"(.+)\"|'(.+)'" cell;
            quoted0                     =   list.head quoted;
            quoted1                     =   list.get quoted 1;
            quoted'                     =   if quoted0 != null then quoted0 else quoted1;
            quotedStart                 =   string.match "([\"'])(.+)" cell;
            quotedStop                  =   string.match "(.+)([\"'])" cell;

            sep                         =   list.get cell 1;
          in
            {
              FinaliseCell
              =   if      isFinalCell
                  then
                    if isLineBreak
                    then
                    {
                      case              =   "ParseCell";
                      index             =   0;
                      journal           =   journal ++ [ transaction ];
                      transaction       =   {};
                    }
                    else
                      debug.panic [ "next" "FinaliseCell" ] "Line Break expected!"
                  else if isColumnSep
                  then
                  {
                    case                =   "ParseCell";
                    index               =   index';
                    quote               =   null;
                  }
                  else if isLineBreak && quote != null
                  then
                  {
                    case                =   "Quoted";
                    text                =   "${text}${quote}${string.concat cell}";
                  }
                  else
                    debug.panic [ "next" "FinaliseCell" ] "Column Seperator expected!";

              ParseCell
              =   if      !isCell
                  then
                    debug.panic [ "next" "ParseCell" ] "Cell expected!"
                  else if quoted != null
                  then
                  {
                    case                =   "FinaliseCell";
                    transaction
                    =   transaction
                    //  {
                          ${field}      =   quoted';
                        };
                  }
                  else if quotedStart != null
                  then
                  {
                    case                =   "Quoted";
                    quote               =   list.head quotedStart;
                    text                =   list.get quotedStart 1;
                  }
                  else
                  {
                    case                =   "FinaliseCell";
                    transaction
                    =   transaction
                    //  {
                          ${field}      =   cell;
                        };
                  };

              ParseHeader
              =   if      isCell
                  then
                  {
                    columns             =   columns ++ [ cell ];
                  }
                  else if isColumnSep
                  then
                    {}
                  else
                  {
                    case                =   "ParseCell";
                  };

              Quoted
              =   if      !isCell
                  then
                  {
                    text                =   "${text}${string.concat cell}";
                  }
                  else if quotedStop != null
                  &&      quote == (list.get quotedStop 1)
                  then
                  {
                    case                =   "FinaliseCell";
                    transaction
                    =   transaction
                    //  {
                          ${field}      =   "${text}${list.head quotedStop}";
                        };
                    text                =   "${text}${list.head quotedStop}";
                  }
                  else
                  {
                    text                =   "${text}${cell}";
                  };
            }.${case};

    next'
    =   { ... } @ state:
        cell:
          state // (next state cell);

    parseCells
    =   list.fold next'
        {
          case                          =   "ParseHeader";
          columns                       =   [];
          index                         =   0;
          journal                       =   [];
          quote                         =   null;
          text                          =   "";
          transaction                   =   {};
        };

    parseFile
    =   fileName:
          (
            parseCells
            (
              string.split
                "( *)([\n,])( *)"
                (path.readFile fileName)
            )
          ).journal;
  in
  {
    journal
    =   files:
        { ... } @ env:
          list.map
            (convertTransaction env)
            (
              list.concatMap
                parseFile
                files
            );
  }
