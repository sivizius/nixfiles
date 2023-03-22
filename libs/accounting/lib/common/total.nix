{ common, core, ... }:
  let
    inherit(common) Amount Transaction;
    inherit(core) debug list number path set string time type;

    Total
    =   type "Total"
        {
          from
          =   direction:
                Total.instanciate
                {
                  inherit direction;
                  __functor
                  =   { inner, journal, ... } @ self:
                      amount:
                      transaction:
                        let
                          amount'       =   Amount.expect amount;
                          transaction'
                          =   {
                                amount  =   amount';
                                inherit(Transaction.expect transaction) uid;
                              };
                        in
                          self
                          //  {
                                inner
                                =   inner
                                //  {
                                      ${amount'.currency}
                                      =   (inner.${amount'.currency} or 0)
                                      +   amount'.value;
                                    };
                                journal
                                =   if transaction != null
                                    then
                                      journal ++ [ transaction' ]
                                    else
                                      journal;
                              };
                  __toString
                  =   { direction, inner, journal, ... }:
                        string.concatLines
                        (
                          [ "<details><summary>" ]
                          ++  (
                                set.mapToList
                                (
                                  currency:
                                  value:
                                    "<p>${Amount value currency}</p>"
                                )
                                inner
                              )
                          ++  [ "</summary>" ]
                          ++  (
                                list.map
                                  (
                                    { amount, uid }:
                                      "<p><code>${amount}</code>(${string uid})</p>"
                                  )
                                  journal
                              )
                          ++  [ "</details>" ]
                        );
                  inner                 =   {};
                  journal               =   [];
                };

          isZero
          =   difference:
                set.all
                  (name: value: value == 0)
                  (Total.expect difference).inner;

          subtract
          =   left:
              right:
                set.fold
                (
                  { inner, ... } @ total:
                  currency:
                  value:
                    total
                    //  {
                          inner
                          =   inner
                          //  {
                                ${currency}
                                =   inner.${currency} or 0
                                -   value;
                              };
                        }
                )
                (Total.expect left)
                (Total.expect right).inner;
        };
  in
    { inherit Total; }
