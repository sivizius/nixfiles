{ common, core, helpers, ... }:
  let
    inherit(common) Transaction;
    inherit(core) list path string;
    inherit(helpers) parseAmountComma parseGermanDateTime;

    convertTransaction
    =   { lookUpAccount, self, ... }:
        { amount, client, currency, dateTime, description, ... } @ inner:
          let
            client'
            =   lookUpAccount client;
          in
            Transaction
            {
              inherit currency dateTime description inner;
              credit                    =   { ${client'.uid}  = amount; };
              debit                     =   { ${self.uid}     = amount; };
            };

    parseLine
    =   line:
          let
            columns                     =   string.splitAt "(\",\"|^\"|\"$)" line;
            currency                    =   list.get columns  5;
          in
          {
            inherit currency;
            amount                      =   parseAmountComma (list.get columns  8) currency;
            amount'                     =   parseAmountComma (list.get columns  6) currency;
            fee                         =   parseAmountComma (list.get columns  7) currency;
            balance                     =   parseAmountComma (list.get columns  9) currency;
            charge                      =   parseAmountComma (list.get columns 15) currency;
            client
            =   {
                  account               =   list.get columns 14;
                  bank                  =   list.get columns 13;
                  email                 =   list.get columns 11;
                  uid
                  =   let
                        uid             =   list.get columns 12;
                      in
                        if uid != ""
                        then
                          uid
                        else
                          "PayPal";
                };
            code                        =   list.get columns 10;
            code'                       =   list.get columns 18;
            dateTime                    =   parseGermanDateTime (list.get columns 1) (list.get columns 2);
            description                 =   list.get columns  4;
            invoiceID                   =   list.get columns 17;
            timeZone                    =   list.get columns  3;
            vat                         =   parseAmountComma (list.get columns 16) currency;
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
