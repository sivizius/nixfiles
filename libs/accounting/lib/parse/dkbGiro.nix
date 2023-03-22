{ common, core, helpers, ... }:
  let
    inherit(common) Transaction;
    inherit(core) list path string;
    inherit(helpers) parseAmountComma parseGermanDateTime trim;

    convertTransaction
    =   { currency, lookUpAccount, self, ... }:
        { amount, bic, clientID, creditorID, customerID, dateTime, dateTime', description, iban, mandateID, type }:
          let
            amount'                     =   amount currency;
            client
            =   lookUpAccount
                {
                  inherit bic creditorID customerID description iban mandateID;
                  uid
                  =   if clientID != ""
                      then
                        clientID
                      else
                        "Deutsche Kreditbank Berlin";
                };
          in
            #__trace "${client}"
            Transaction
            {
              inherit dateTime description type;
              credit                    =   { ${client.uid} = amount'; };
              debit                     =   { ${self.uid}   = amount'; };
              ongoing                   =   type == "Lastschrift" || type == "Dauerauftrag";
            };

    parseLine
    =   line:
          let
            cells                       =   string.splitAt "(\";\"|\")" line;
          in
          {
            # "Buchungstag";"Wertstellung";"Buchungstext";"Auftraggeber / Begünstigter";"Verwendungszweck";"Kontonummer";"BLZ";"Betrag (EUR)";"Gläubiger-ID";"Mandatsreferenz";"Kundenreferenz";
            amount                      =   parseAmountComma (list.get cells 8);
            bic                         =   trim (list.get cells 7);
            clientID                    =   trim (list.get cells 4);
            creditorID                  =   trim (list.get cells 9);
            customerID                  =   trim (list.get cells 11);
            dateTime                    =   parseGermanDateTime (list.get cells 2) "00:00:00";
            dateTime'                   =   parseGermanDateTime (list.get cells 1) "00:00:00";
            description                 =   trim (list.get cells 5);
            iban                        =   trim (list.get cells 6);
            mandateID                   =   trim (list.get cells 10);
            type
            =   let
                  type                  =   trim (list.get cells 3);
                in
                  if type != ""
                  then
                    type
                  else
                    "Kreditkartenabrechnung";
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
