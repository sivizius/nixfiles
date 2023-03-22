{ common, core, ... } @ libs:
  let
    inherit(core)   debug library list number set string time type;
    inherit(common) Account Amount Transaction creditAccounts debitAccounts;

    addReferences#: [ { ... } ] -> [ { reference: int, ... } ]
    =   list.imap
          (reference: { ... } @ this: this // { inherit reference; });

    balance#: Self -> ~DateTime-> Balance | !
    =   balanceTime:
        { ... } @ self:
          let
            self'                       =   from self;
            balanceTime'                =   time.from balanceTime;
            journal
            =   addReferences
                (
                  list.filter
                    ( { dateTime, ... }: !( time.after dateTime balanceTime' ) )
                    self'.journal
                );
          in
            balance' (self' // { balanceTime = balanceTime'; dateTime = balanceTime'; inherit journal; } );


    setAccounts#: { Account } -> A -> A'
    # where
    #   A: { title: string, level: int, accounts: T, ... },
    #   T: [ { id: string, name: string, ... } ],
    #   A': T' | { title: string, level: int, accounts: T', total: Amount, ... },
    #   T': [ { id: string, name: string, journal: [ Transaction ], total: Amount, ... } ]
    =   { ... } @ accounts:
        this:
          type.matchPrimitiveOrPanic this
          {
            set
            =   if this ? accounts
                then
                  let
                    accounts'           =   setAccounts' accounts this.accounts;
                  in
                    this
                    //  {
                          accounts      =   accounts';
                          total         =   1.0 * number.sum (list.map ({ total, ... }: total) accounts');
                        }
                else
                  this
                  //  {
                        inherit (accounts.${this.id}) total credit debit;
                      };
          };

    setAccounts'#: { Account } -> A -> A'
    # where
    #   A: [ { id: string, name: string, ... } ],
    #   A': T' | { title: string, level: int, accounts: T', total: Amount, ... },
    #   T': [ { id: string, name: string, journal: [ Transaction ], total: Amount, ... } ]
    =   { ... } @ accounts:
        this:
          type.matchPrimitiveOrPanic this
          {
            list                        =   list.map (setAccounts accounts) this;
          };

    balance'#: Self -> Balance | !
    =   { accounts, assets, liabilities, outcome, journal, ... } @ self:
          let

            accounts'#: { Account }
            =   list.fold
                (
                  { ... } @ accounts:
                  { credit, debit, ... } @ transaction:
                    debitAccounts (creditAccounts accounts credit transaction) debit transaction
                )
                accounts
                journal;
          in
            self
            //  {
                  assets                =   setAccounts accounts' assets;
                  liabilities           =   setAccounts accounts' liabilities;
                  outcome               =   setAccounts accounts' outcome;
                };

    balanceToTransaction#: Balance -> Transaction
    =   { accounts, dateTime, events ? {}, ... } @ self:
          let
            initialTransaction          =   events.initialTransaction or ({ ... }: {});
            transaction                 =   initialTransaction { inherit dateTime; };
          in
            transaction
            //  {
                  inherit dateTime;
                  debit
                  =   set.filterValue
                        ({ total, ... }: total > 0)
                        accounts;
                  credit
                  =   set.mapValues
                        (total: -total)
                        (
                          set.filterValue
                            ({ total, ... }: total < 0)
                            accounts
                        );
                };

    format
    =   library.import ./format.nix libs
        {
          inherit balance balance' balanceToTransaction from outcome;
        };

    from#: { name, assets: T, liabilities: T, outcome: T, journal: [ ~Transaction ] } -> Self
    # where T: [ { id: string, name: string, ... } | { title: string, accounts: T, ... } ]
    =   { name, assets, liabilities, outcome, journal, ... } @ self:
          let
            flatSections#: { title: string, accounts: T, ... } -> [ { id: string, name: string, ... } ]
            # where T: [ { id: string, name: string, ... } | { title: string, accounts: T, ... } ]
            =   this:
                  type.matchPrimitiveOrPanic this
                  {
                    set
                    =   if this ? accounts
                        then
                          flatSections' this.accounts
                        else
                          [ this ];
                  };

            flatSections'#: T -> [ { id: string, name: string, ... } ]
            # where T: [ { id: string, name: string, ... } | { title: string, accounts: T, ... } ]
            =   this:
                  list.concatMap flatSections (list.expect this);

            flatAccounts#: [ { id, name, ... } | { title, level, ... } ] -> { Account }
            =   accounts:
                  list.mapValuesToSet
                    ( { id, name, ... } @ account: { name = id; value = Account account; } )
                    ( flatSections' accounts );
          in
            self
            //  {
                  accounts              =   flatAccounts [ assets liabilities outcome ];
                  journal               =   list.map Transaction journal;
                };

    fromSelf                            =   from;

    outcome#: Self -> { from: Date, till: ~DateTime } -> { } | !
    =   { from, till }:
        { ... } @ self:
          let
            splitTransaction#: [ Transaction ] -> ~DateTime -> ~DateTime -> { current: [ Transaction ], before: [ Transaction ] }
            =   journal:
                  let
                    parts
                    =   list.partition
                          ({ dateTime, ... }: time.before ( time.from dateTime ) from' )
                          journal;
                    parts'
                    =   list.filter
                          ({ dateTime, ... }: !( time.after ( time.from dateTime ) till'))
                          parts.wrong;
                  in
                  {
                    before              =   parts.right;
                    current             =   parts';
                  };

            from'                       =   time.from from;
            till'                       =   time.from till;
            self'                       =   fromSelf self;
            journal                     =   splitTransaction self'.journal;
            initialTransaction
            =   balanceToTransaction
                (
                  balance'
                  (
                    self'
                    //  {
                          journal       =   addReferences journal.before;
                          dateTime      =   from';
                        }
                  )
                );

            balance
            =   balance'
                (
                  self'
                  //  {
                        journal         =   addReferences ([ initialTransaction ] ++ journal.current);
                        dateTime        =   till';
                      }
                );
          in
            balance
            //  {
                  from                  =   from';
                  till                  =   till';
                  dateTime              =   till';
                };
  in
    {
      __functor                         =   self: from;
      inherit balance balanceToTransaction from outcome;
    }
    //  format