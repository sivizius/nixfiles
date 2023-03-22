{ common, core, ... }:
  let
    inherit(common) Total;
    inherit(core)   debug list number path set string time type;

    Account#: { ... } -> Account
    =   let
          __functor
          =   { credit, debit, ... } @ self:
              { ... } @ transaction:
                self
                //  {
                    };

          __toString
          =   { uid, ... }:
                "<${uid}>";
        in
          type "Account"
          {
            from
            =   uid:
                { ... } @ meta:
                  Account.instanciate
                  (
                    meta
                    //  {
                          inherit uid __functor __toString;
                          credit        =   Total false;
                          debit         =   Total true;
                        }
                  );
          };
  in
    { inherit Account; }
