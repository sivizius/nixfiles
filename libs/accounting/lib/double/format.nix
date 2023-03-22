{ core, ... }:
{ balance, balance', balanceToTransaction, from, outcome, ... }:
  let
    inherit(core) list set string time;
    inherit(time) formatDate;

    concatLines'
    =   function: lines: string.concatLines (list.filter (value: value != null) (list.map function lines));

    lineLength                            =   111;

    padNameValue#: string -> string
    =   name:
        value:
        currency:
        extra:
          let
            value'                        =   string.from value;
            nameLength                    =   string.lengthUTF8 name;
            valueLength                   =   ( string.length value' ) - 4;
            currencyLength                =   string.lengthUTF8 currency;
            length                        =   lineLength - nameLength - valueLength - currencyLength - extra - 2;
            padding                       =   string.repeat " " length;
            theValue                      =   string.slice 0 valueLength value';
            theValue'                     =   if theValue == "-0.00" then " 0.00" else theValue;
          in
            "${name}:${padding}${theValue'} ${currency}";

    listSectionTotal'#: int -> T -> string
    # where T: { title: string, accounts: [ T | { name: string, ... } ], ... }
    =   { ... } @ self:
        negative:
        depth:
        { title, accounts, ... } @ this:
          let
            entries                       =   listSectionTotal self negative ( depth + 1 ) accounts;
          in
            if entries != ""
            then
              "  ${string.repeat "  " depth}${title}:\n${entries}"
            else
              null;

    listSectionTotal#: int -> T -> string
    # where T: { title: string, accounts: [ T | { name: string, ... } ], ... }
    =   { currency, events ? {}, ... } @ self:
        negative:
        depth:
          concatLines'
          (
            { ... } @ entry:
              let
                filterSection             =   events.filterSection or ({ ... }: true);
                total
                =   if negative
                    then
                      -entry.total
                    else
                      entry.total;
              in
                if entry ? name
                then
                  "  ${padNameValue "${string.repeat "  " depth}${entry.name}" total currency 2}"
                else if filterSection entry
                then
                  listSectionTotal' self negative depth entry
                else
                  "  ${padNameValue "${string.repeat "  " depth}${entry.title}" total currency 2}"
          );

    formatBalance#: Self -> Date -> string
    =   dateTime:
        self:
          formatBalance' ( balance dateTime self );

    formatBalance'#: Self -> string
    =   { name, currency, dateTime, assets, liabilities, outcome, journal, events ? {}, ... } @ self:
          let
            formatBalanceTitle
            =   events.formatBalanceTitle
            or  (
                  { name, dateTime, ...}:
                    "Consolidated Statement Finance Positions of ${name} as of ${formatDate dateTime "eng"}"
                );
            title                         =   formatBalanceTitle { inherit name dateTime; };
            formatAccountNames
            =   events.formatAccountNames
            or  (
                  { ... }:
                  {
                    balance               =   "Assets, Liabilities and Equity";
                    outcome               =   "Expenses and Revenues";
                    revenues              =   "Revenues";
                    expenses              =   "Expenses";
                  }
                );
            formatBalanceNames
            =   events.formatBalanceNames
            or  (
                  { ... }:
                  {
                    credit                =   "Credit";
                    debit                 =   "Debit";
                    total                 =   "Total";
                  }
                );
            filterSection                 =   events.filterSection or ( { ... }: true );
            accountNames                  =   formatAccountNames {};
            balanceNames                  =   formatBalanceNames {};

            listSections'#: [ Transaction ] -> bool -> int -> T -> string
            # where T: { title: string, accounts: [ T | { name: string, ... } ], ... }
            =   allTransactions:
                depth:
                { title, accounts, ... }:
                  let
                    entries               =   listSections allTransactions depth accounts;
                  in
                    if entries != ""
                    then
                      "${string.repeat "  " depth}  ${title}:\n${entries}"
                    else
                      null;

            listSections#: [ Transaction ] -> bool -> int -> T -> string
            # where T: { title: string, accounts: [ T | { name: string, ... } ], ... }
            =   allTransactions:
                depth:
                  let
                    padding               =   string.repeat "  " depth;
                    formatAccount#: int -> { name, credit, debit, total, ... } -> string
                    =   { name, credit, debit, total, ... }:
                          let
                            listTransactions#: [ Transaction ] -> [ { amount: Amount, reference: int, ... } ] -> string
                            =   journal:
                                  list.concatMap
                                  (
                                    { amount, reference, ... }:
                                      let
                                        transaction
                                        =    list.get allTransactions reference;
                                      in
                                        "\n${padding}        ${padNameValue transaction.description amount currency ( 8 + 2 * depth )}"
                                  )
                                  journal;
                          in
                            if  debit.journal   != []
                            ||  credit.journal  != []
                            then
                              ''
                                ${padding}    ${name}
                                ${padding}      ${balanceNames.debit}:${listTransactions  debit.journal}
                                ${padding}        ${string.repeat "–" (lineLength - 8 - 2 * depth)}
                                ${padding}        ${padNameValue balanceNames.total debit.total currency ( 8 + 2 * depth)}
                                ${padding}      ${balanceNames.credit}:${listTransactions credit.journal}
                                ${padding}        ${string.repeat "–" (lineLength - 8 - 2 * depth)}
                                ${padding}        ${padNameValue balanceNames.total credit.total currency ( 8 + 2 * depth)}
                              ''
                            else
                              null;
                  in
                    concatLines'
                    (
                      { ... } @ entry:
                        if entry ? name
                        then
                          formatAccount entry
                        else
                          listSections' allTransactions ( depth + 1 ) entry
                    );

            expensesAndRevenues           =   list.partition ({ total, ... }: total >= 0) outcome.accounts;
            expenses                      =   { title = accountNames.expenses; accounts = expensesAndRevenues.wrong; };
            revenues                      =   { title = accountNames.revenues; accounts = expensesAndRevenues.right; };
          in
            ''
              == ${accountNames.balance} ==
                === ${assets.title} ===
              ${listSections journal  0 assets.accounts}
                === ${liabilities.title} ===
              ${listSections journal  0 liabilities.accounts}
              == ${accountNames.outcome} ==
                === ${expenses.title} ===
              ${listSections journal  0 expenses.accounts}
                === ${revenues.title} ===
              ${listSections journal  0 revenues.accounts}
              == ${title} ==
                === ${assets.title} ===
              ${listSectionTotal self false 0 assets.accounts}
                ${string.repeat "=" ( lineLength - 2)}
                ${padNameValue balanceNames.total assets.total currency 2}

                === ${liabilities.title} ===
              ${listSectionTotal self true 0 liabilities.accounts}
                ${string.repeat "=" ( lineLength - 2)}
                ${padNameValue balanceNames.total (- liabilities.total) currency 2}
            '';

    formatOutcome#: Self -> { from: D, till: D } -> string
    # where D -> DateTime
    =   { from, till } @ period:
        self:
          formatOutcome' (outcome period self);

    formatOutcome'#: Self -> { from: D, till: D } -> string
    # where D -> DateTime
    =   { name, currency, from, till, events, outcome, ... } @ self:
          let
            formatOutcomeTitle
            =   events.formatOutcomeTitle
            or  (
                  { name, from, till, ...}:
                    "Income statement of ${name} between ${time.formatDate from "eng"} and ${time.formatDate till "eng"}"
                );
            title                         =   formatOutcomeTitle { inherit name from till; };
            total                         =   -1.0 * outcome.total;
          in
            ''
              ${formatBalance' self}
              == ${title} ==
              ${listSectionTotal self true 0 outcome.accounts}
                ${string.repeat "=" ( lineLength - 2)}
                ${padNameValue outcome.title total currency 2}
            '';
  in
    { inherit formatBalance formatOutcome; }