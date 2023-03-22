{ common, core, ... }:
  let
    inherit(common) Amount;
    inherit(core) debug indentation list number path set string time type;

    checkTransactionAccounts#: { Account } -> { Account } -> Transaction -> [ string ]
    =   { ... } @ allAccounts:
        { ... } @ transactionAccounts:
        { ... } @ transaction:
          let
            unknownAccounts               =   getUnknownAccounts allAccounts transactionAccounts;
          in
            if unknownAccounts == []
            then
              transactionAccounts
            else
              debug.panic "checkTransactionAccounts"
              {
                text                      =   "Unknown Accounts: <${string.concatWithFinal ">, <" "> and <" unknownAccounts}>!";
                data                      =   { inherit transaction; };
              };

    collectAccounts
    =   list.fold
        (
          { ... } @ accounts:
          { uid, ... } @ account:
            if accounts.${uid} or null == null
            then
              accounts
              //  {
                    ${uid}              =   account;
                  }
            else
              debug.panic
                "Book"
                "Duplicate of account UID: ${uid}"
        )
        {};

    creditAccounts#: { Account } -> { Amount } -> { reference: R } -> { Account } | !
    # where R: Any
    =   { ... } @ allAccounts:
        { ... } @ creditAccounts:
        { ... } @ transaction:
          set.fold
          (
            { ... } @ allAccounts:
            accountUID:
            amount:
              let
                this                      =   allAccounts.${accountUID};
              in
                allAccounts
                //  {
                      ${accountUID}
                      =   this
                      //  {
                            credit        =   this.credit amount transaction;
                          };
                    }
          )
          allAccounts
          ( checkTransactionAccounts allAccounts creditAccounts transaction );

    debitAccounts#: { Account } -> { Amount } -> { reference: R } -> { Account } | !
    # where R: Any
    =   { ... } @ allAccounts:
        { ... } @ debitAccounts:
        { ... } @ transaction:
          set.fold
          (
            { ... } @ allAccounts:
            accountUID:
            amount:
              let
                this                      =   allAccounts.${accountUID};
              in
                allAccounts
                //  {
                      ${accountUID}
                      =   this
                      //  {
                            debit         =   this.debit amount transaction;
                          };
                    }
          )
          allAccounts
          ( checkTransactionAccounts allAccounts debitAccounts transaction );

    flat
    =   source:
          let
            source'
            =   if source != null
                then
                  "${source}-"
                else
                  "";
          in
            list.concatMap
            (
              { __type__, body ? [], uid ? null, ... } @ entry:
                {
                  Account               =   [ (entry // { uid = "${source'}${uid}"; }) ];
                  Section               =   flat "${source'}${uid}" body;
                }.${__type__}
                or  (
                      debug.panic [ "Book" "flat" ]
                      {
                        text            =   "Either Account or Section expected, got:";
                        data            =   entry;
                      }
                    )
            );

    getSectionUIDs
    =   source:
          let
            source'
            =   if source != null
                then
                  "${source}-"
                else
                  "";
          in
            list.concatMap
            (
              { __type__, body ? [], uid ? null, ... } @ entry:
                {
                  Account               =   [];
                  Section
                  =   [ "${source'}${uid}" ]
                  ++  getSectionUIDs "${source'}${uid}" body;
                }.${__type__}
                or  (
                      debug.panic [ "Book" "getSectionUIDs" ]
                      {
                        text            =   "Either Account or Section expected, got:";
                        data            =   entry;
                      }
                    )
            );

    getUnknownAccounts#: { Accounts } -> [ string ] -> [ string ]
    =   { ... } @ allAccounts:
        { ... } @ checkAccounts:
          list.filter
            (accountUID: allAccounts.${accountUID} or null == null)
            (set.names checkAccounts);

    lookUp
    =   let
          find
          =   dictionary:
              key:
              prefixes:
                if key != null
                then
                  list.fold
                    (
                      result:
                      prefix:
                        let
                          key'          =   "${prefix}-${key}";
                          value         =   dictionary.${key'} or null;
                        in
                          if value != null
                          then
                            debug.panic [ "Book" "lookUp" "find" ]
                            {
                              text      =   "Multiple matches:";
                              data      =   { first = result; second = value; inherit key key'; };
                              nice      =   true;
                              when      =   result != null;
                            }
                            value
                          else
                            result
                    )
                    null
                    prefixes
                else
                  null;
          haz
          =   dictionary:
              key:
                if  key != null
                then
                  dictionary.${key} or null
                else
                  null;

          match
          =   { description ? null, email ? null, uid ? null, ... } @ client:
                debug.info [ "Book" "lookUp" "match" ]
                {
                  text                  =   "Try to find match for:";
                  data                  =   client;
                  nice                  =   true;
                }
                set.filterValue
                (
                  { matches ? {}, regex ? {}, ... } @ account:
                    let
                      regexMatch
                      =   (uid          != null && regex.uid          or null != null && ((string.match regex.uid         uid)          != null))
                      ||  (email        != null && regex.email        or null != null && ((string.match regex.email       email)        != null))
                      ||  (description  != null && regex.description  or null != null && ((string.match regex.description description)  != null));

                      checkParam
                      =   field:
                          value:
                            (client.${field} or null != null)
                            &&  (
                                  if list.isInstanceOf value
                                  then
                                    list.find client.${field} value
                                  else
                                    client.${field} == value
                                );

                      paramMatch
                      =   matches != {}
                      &&  (set.any checkParam matches);
                    in
                      debug.info [ "Book" "lookUp" "match" ]
                      {
                        text            =   "Check ${account}";
                        data            =   { inherit matches regex; };
                        when            =   (matches != {} || regex != {});
                      }
                      regexMatch || paramMatch
                );
        in
          { accounts, aliases, emails, ibans, sectionUIDs, ... } @ environment:
          { email ? null, iban ? null, uid ? null, ... } @ client:
            let
              alias                     =   haz   aliases   uid;
              email'                    =   haz   emails    email;
              iban'                     =   haz   ibans     iban;
              client'                   =   find  accounts  uid sectionUIDs;

              match'
              =   let
                    matches             =   match client accounts;
                  in
                    debug.info [ "Book" "lookUp" ]
                    {
                      text              =   "Matches";
                      data              =   matches;
                      when              =   matches != {};
                    }
                    set.foldValues
                      (
                        result:
                        { uid, ... } @ account:
                          debug.panic "lookUpAccount"
                          {
                            text        =   "Multiple matches: <${result}> and <${uid}>";
                            data        =   { first = result; second = account; };
                            when        =   result != null;
                          }
                          account
                      )
                      null
                      matches;
            in
              if      client' !=  null  then  client'
              else if alias   !=  null  then  alias
              else if email'  !=  null  then  email'
              else if iban'   !=  null  then  iban'
              else if match'  !=  null  then  match'
              else
                debug.panic "lookUpAccount"
                {
                  text                  =   "Cannot determine uid of client:";
                  data                  =   { inherit environment client; };
                  nice                  =   true;
                }
                null;

    makeLookUp
    =   field:
          let
            insert
            =   { uid, ... } @ account:
                dictionary:
                key:
                  if dictionary.${key} or null == null
                  then
                    dictionary // { ${key} = account; }
                  else
                    debug.panic
                      [ "Book" "makeLookUp" ]
                      "Duplicate ${field} »${key}« for <${uid}> and >${dictionary.${key}}>";
          in
            set.foldValues
            (
              { ... } @ dictionary:
              { ... } @ account:
                let
                  insert'               =   insert account;
                  value                 =   account.${field} or null;
                in
                  type.matchPrimitiveOrPanic value
                  {
                    list                =   list.fold insert' dictionary value;
                    null                =   dictionary;
                    string              =   insert' dictionary value;
                  }
            )
            {};

    sortJournal
    =   journal:
          list.imap
            (
              uid:
              transaction:
                transaction // { inherit uid; }
            )
            (
              list.sort
              (
                { dateTime, ... }:
                other:
                  time.before dateTime other.dateTime
              )
              journal
            );

    HTML
    =   let
          flat
          =   body:
                if list.isInstanceOf body
                then
                  list.concatMap flat body
                else
                  [ body ];

          mapAttributes
          =   { ... } @ attributes:
                string.concatMapped
                  (key: " ${key}=\"${string attributes.${key}}\"")
                  (set.names attributes);

          Block
          =   name:
              { ... } @ attributes:
              body:
                [ "<${name}${mapAttributes attributes}>" indentation.more ]
                ++  (flat body)
                ++  [ indentation.less "</${name}>" ];

          Line
          =   name:
              { ... } @ attributes:
              text:
                "<${name}${mapAttributes attributes}>${text}</${name}>";
        in
        {
          inherit Block Line;
          Block'                        =   name: Block name {};
          Line'                         =   name: Line  name {};

          __functor
          =   { ... }:
              body:
                indentation {}
                (
                  [
                    ""
                    "<!DOCTYPE html>"
                    "<html>" indentation.more
                  ]
                  ++  (flat body)
                  ++  [ indentation.less "</html>" ]
                );
        };

    harmonise
    =   { inner, ... } @ self:
        { inner, ... }:
          list.fold
          (
            { ... } @ dictionary:
            key:
              dictionary
              //  {
                    ${key}              =   dictionary.${key} or 0;
                  }
          )
          self.inner
          (set.names inner);

    toAmounts
    =   set.mapToList
        (
          currency:
          value:
            Amount value currency
        );

    toHTML
    =   let
          renderSections
          =   accounts:
              source:
                let
                  source'
                  =   if source != null
                      then
                        "${source}-"
                      else
                        "";
                in
                  list.concatMap
                  (
                    { __type__, title ? null, body ? [], uid ? null, ... } @ entry:
                      let
                        uid'            =   "${source'}${uid}";
                        inherit(accounts.${uid'}) credit debit;

                        credit'         =   toAmounts (harmonise credit debit);
                        debit'          =   toAmounts (harmonise debit credit);
                        total
                        =   list.imap
                              (
                                index:
                                credit:
                                  HTML.Block' "tr"
                                  [
                                    (HTML.Line "th" { style = "text-align: right;"; } "${list.get debit' index}")
                                    (HTML.Line "th" { style = "text-align: right;"; } "${credit}")
                                  ]
                              )
                              credit';
                      in
                      {
                        Account
                        =   [
                              (
                                HTML.Block' "details"
                                [
                                  (HTML.Line' "summary" (if title != null then "&lt;${uid'}&gt; ${title}" else "&lt;${uid'}&gt;"))
                                  (
                                    HTML.Block "table" { style = "width: 100%;"; }
                                    (
                                      [
                                        (
                                          HTML.Block' "tr"
                                          [
                                            (HTML.Line "th" { style = "width:50%;"; } "Soll")
                                            (HTML.Line "th" { style = "width:50%;"; } "Haben")
                                          ]
                                        )
                                      ]
                                      ++  total
                                    )
                                  )
                                ]
                              )
                            ];
                        Section
                        =   [
                              (
                                HTML.Block' "details"
                                (
                                  [ ( HTML.Line' "summary" "[${uid'}] <strong>${title}</strong>" ) ]
                                  ++  (renderSections accounts uid' body)
                                )
                              )
                            ];
                      }.${__type__}
                      or  (
                            debug.panic [ "Book" "toHTML" ]
                            {
                              text        =   "Either Account or Section expected, got:";
                              data        =   entry;
                            }
                          )
                  );

          render
          =   { body, accounts, journal, ... } @ subbook:
                HTML
                [
                  (
                    HTML.Block' "head"
                    [
                      (HTML.Line' "title" "Übersicht")
                      (
                        HTML.Block' "style"
                        [
                          "table, th, td {" indentation.more
                          "border: 1px solid black;"
                          "border-collapse: collapse;"
                          indentation.less "}"
                        ]
                      )
                    ]
                  )
                  (
                    HTML.Block' "body"
                    (
                      (renderSections accounts null body)
                      ++  [
                            (HTML.Line' "h1" "Laufende Kosten")
                            (
                              HTML.Block' "ul"
                              (
                                list.map
                                  (
                                    { dateTime, description, credit, debit, type ? "", ... }:
                                      HTML.Line' "li"
                                      (
                                        let
                                          render
                                          =   clients:
                                                string.concatCSV
                                                (
                                                  set.mapToList
                                                  (
                                                    uid:
                                                    amount:
                                                      "(${uid}: ${amount})"
                                                  )
                                                  clients
                                                );
                                        in
                                          "[${dateTime}] {${type}} ${render credit} -> ${render debit} »${description}«"
                                      )
                                  )
                                  (
                                    #list.filter
                                      #({ ongoing ? false, ... }: ongoing)
                                      journal
                                  )
                              )
                            )
                          ]
                    )
                  )
                ];
        in
          book:
            render (Book.expect book);

    Book
    =   type "Book"
        {
          from
          =   { body, currency ? "EUR", title, ... }:
                let
                  accounts              =   collectAccounts (flat null body);
                  aliases               =   makeLookUp  "alias" accounts;
                  emails                =   makeLookUp  "email" accounts;
                  ibans                 =   makeLookUp  "iban"  accounts;

                  journal
                  =   sortJournal
                      (
                        list.concatMap
                          (
                            { journal ? null, uid, ... } @ self:
                              type.matchPrimitiveOrPanic journal
                              {
                                lambda  =   journal { inherit currency lookUpAccount self; };
                                list    =   journal;
                                null    =   [];
                              }
                          )
                          (set.values accounts)
                      );

                  lookUpAccount         =   lookUp { inherit accounts aliases emails ibans sectionUIDs; };

                  sectionUIDs           =   (getSectionUIDs null body) ++ [ "" ];
                in
                  Book.instanciate
                  {
                    inherit aliases body emails ibans journal title;
                    accounts
                    =   list.fold
                        (
                          { ... } @ accounts:
                          { credit, debit, ... } @ transaction:
                            debitAccounts
                              (creditAccounts accounts credit transaction)
                              debit
                              transaction
                        )
                        accounts
                        journal;
                  };
          inherit toHTML;
        };
  in
    { inherit Book; }
