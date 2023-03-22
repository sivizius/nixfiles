{ common, core, ... }:
  let
    inherit(common) Total;
    inherit(core)   debug list number path set string time type;

    Transaction#: { dateTime: ~DateTime, debit: { Amount }, credit: { Amount }, ... } -> Transaction
    =   let
          sumTransfers
          =   direction:
                set.foldValues
                  (
                    total:
                    amount:
                      total amount null
                  )
                  (Total direction);
        in
          type "Transaction"
          {
            from
            =   { dateTime, credit, debit, ... } @ transaction:
                  let
                    clients
                    =   set.fold
                        (
                          { ...} @ clients:
                          uid:
                          amount:
                            if clients.${uid} or null == null
                            then
                              clients
                              //  {
                                    ${uid}
                                    =   amount
                                    //  {
                                          value
                                          =   -amount.value;
                                        };
                                  }
                            else
                              throw "…"
                        )
                        credit
                        debit;

                    total               =   sumTransfers false  clients;
                    clients'            =   set.partitionByValue ({ value, ... }: value >= 0) clients;
                  in
                    if Total.isZero total
                    then
                      Transaction.instanciate
                      (
                        transaction
                        //  {
                              dateTime  =   time.from dateTime;
                              credit    =   clients'.right;
                              debit
                              =   set.mapValues
                                  (
                                    { value, ... } @ self:
                                    self
                                    //  {
                                          value = -value;
                                        }
                                  )
                                  clients'.wrong;
                            }
                      )
                    else
                      debug.panic "Transaction"
                      {
                        text            =   "Sum of Credits and Debits is not equal!";
                        data
                        =   {
                              credit    =   clients'.right;
                              debit     =   clients'.wrong;
                              inherit transaction total;
                            };
                      };
          };
  in
    { inherit Transaction; }
