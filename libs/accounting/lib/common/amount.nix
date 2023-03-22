{ core, ... }:
  let
    inherit(core) debug list number path set string time type;

    __toString
    =   { currency, value, ... }:
          let
            negative                    =   value < 0;
            value'                      =   if negative then -value else value;
            text                        =   string value';
            len                         =   string.length text;
            decimal                     =   len - 2;
            intPart                     =   string.slice 0 decimal text;
            decPart                     =   string.slice decimal len text;
            mod3                        =   x: ((x + 2)/ 3 * 3) - x;
            mod3'                       =   mod3 decimal;
            padding                     =   list.get [ "" " " "  " ] mod3';
            tripletts
            =   list.filter
                  list.isInstanceOf
                  (
                    string.split
                      "(.{3})"
                      "${padding}${intPart}"
                  );
            tripletts'                  =   list.concat tripletts;
            intPart'                    =   string.concatWith "," tripletts';
            text'
            =   if      value' < 10
                then
                  "0.0${text}"
                else if value' < 100
                then
                  "0.${text}"
                else
                  "${string.slice mod3' (string.length intPart') intPart'}.${decPart}";
          in
            "${if negative then "-" else ""}${text'} ${currency}";

    Amount#: int | float -> Amount
    =   type "Amount"
        {
          from
          =   value:
              currency:
                Amount.instanciate
                {
                  inherit currency value __toString;
                };
        };
  in
    { inherit Amount; }
