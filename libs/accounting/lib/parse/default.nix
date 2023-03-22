{ common, core, ... } @ libs:
  let
    inherit(common) Amount;
    inherit(core) expression library list string;

    parseAmount
    =   regex:
        text:
          let
            sign                        =   if list.head valid == "-" then -1 else 1;
            text'
            =   list.fold
                  (
                    result:
                    digit:
                      if  result == ""
                      ->  digit != "0"
                      then
                        "${result}${digit}"
                      else
                        ""
                  )
                  ""
                  (
                    string.splitAt'
                      "[^0-9]*"
                      text
                  );
            valid                       =   string.match regex text;
            value
            =   if  valid != null
                &&  text' !=  ""
                then
                  #__trace "> »${text}«"
                  #__trace "< »${text'}«"
                  sign * (expression.fromJSON text')
                else
                  0;
          in
            Amount value;

    parseDMYdateTime
    =   regex:
        date:
        time:
          let
            dateParts                   =   string.match regex date;
            day                         =   list.get dateParts 0;
            month                       =   list.get dateParts 1;
            year                        =   list.get dateParts 2;
          in
            "${year}-${month}-${day}T${time}";

    trim
    =   text:
          string.concatWords
          (
            list.filter
              (part: part != "")
              (string.splitSpaces text)
          );

    libs'
    =   libs
    //  {
          helpers
          =   {
                inherit parseAmount parseDMYdateTime trim;

                parseAmountComma        =   parseAmount "([+-]?)[0-9.]+,[0-9]{2}";
                parseAmountPeriod       =   parseAmount "([+-]?)[0-9,]+.[0-9]{2}";

                parseGermanDateTime     =   parseDMYdateTime "([0-9]{2})[.]([0-9]{2})[.]([0-9]{4})";
                parseBritishDateTime    =   parseDMYdateTime "([0-9]{2})/([0-9]{2})/([0-9]{4})";
              };
        };
  in
  {
    amex                                =   library.import ./amex.nix       libs';
    dkbCredit                           =   library.import ./dkbCredit.nix  libs';
    dkbGiro                             =   library.import ./dkbGiro.nix    libs';
    paypal                              =   library.import ./paypal.nix     libs';
  }
