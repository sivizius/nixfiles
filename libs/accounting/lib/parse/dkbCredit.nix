{ common, core, helpers, ... }:
  let
    inherit(common) Transaction;
    inherit(core) bool list path string;
    inherit(helpers) parseAmountComma parseGermanDateTime trim;

    convertTransaction
    =   { currency, lookUpAccount, self, ... }:
        { amount, dateTime, dateTime', description }:
          let
            amount'                     =   amount currency;
            client
            =   lookUpAccount
                {
                  inherit description;
                  uid                   =   bool.select (amount'.value > 0) "Deutsche Kreditbank Berlin" null;
                };
          in
            #__trace "${client}"
            Transaction
            {
              inherit dateTime description;
              credit                    =   { ${client.uid} = amount'; };
              debit                     =   { ${self.uid}   = amount'; };
              ongoing                   =   false;
            };

    parseLine
    =   line:
          let
            cells                       =   string.splitAt "(\";\"|\")" line;
          in
          {
            # "Umsatz abgerechnet und nicht im Saldo enthalten";"Wertstellung";"Belegdatum";"Beschreibung";"Betrag (EUR)";"Ursprünglicher Betrag";
            amount                      =   parseAmountComma (list.get cells 5);
            dateTime                    =   parseGermanDateTime (list.get cells 3) "00:00:00";
            dateTime'                   =   parseGermanDateTime (list.get cells 2) "00:00:00";
            description                 =   trim (list.get cells 4);
          };

    parseFile
    =   fileName:
          let
            lines
            =   list.filter
                  (line: line != "")
                  (string.splitLines (path.readFile fileName));
          in
            list.map
              parseLine
              (list.tail lines);
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
