{ core, urls, ... }:
  let
    inherit(core) debug list string type;

    fromSet                             =   { area, country, suffix } @ number: number;
    splitRest                           =   string.splitAt "[ ]+";

    p2                                  =   "2[07]|2[0-9]{2}";
    p3                                  =   "3[0-469]|3[0-9]{2}";
    p4                                  =   "42[0-9]|4[0-9]";
    p5                                  =   "5[09][0-9]|5[1-8]";
    p6                                  =   "6[0-6]|6[7-9][0-9]";
    p8                                  =   "8[1246]|8[035789][0-9]";
    p9                                  =   "9[0-58]|9[679][0-9]";
    restRegEx                           =   "([0-9 /-]+)";
    internationalRegEx                  =   "[+](1|${p2}|${p3}|${p4}|${p5}|${p6}|7|${p8}|${p9})[ -]?${restRegEx}";
    nationalRegEx                       =   "0${restRegEx}";

    formatTeX
    =   number:
          let
            number'                     =   parse number;
            rest                        =   string.concatWith "\\," number'.suffix;
          in
            urls.formatTeXboxed "tel:${number}"
            (
              if number'.country != null
              then
                if number'.area != null
                then
                  "${number'.country}\\,${number'.area}\\,${rest}"
                else
                  "${number'.country}\\,${rest}"
              else
                rest
            );

    parse
    =   number:
          let
            international               =   string.match internationalRegEx number;
            national                    =   string.match nationalRegEx number;

            country
            =   if      international != null then  "+${list.head international}"
                else if national      != null then  "0"
                else                                null;

            rest
            =   if      international != null then  list.get international 1
                else if national      != null then  list.head national
                else                                number;

            defaultAreaAndSuffix
            =   {
                  area                  =   null;
                  suffix                =   splitRest rest;
                };

            areaAndSuffix
            =   if country != null
                && country != "0"
                then
                  {
                    "+49"
                    =   let
                          foo           =   string.match "(1?[0-9]{2})([0-9 -]+)" rest;
                        in
                          if foo != null
                          then
                            debug.info "areaAndSuffix"
                            {
                              text = "foo != null";
                              show = true;
                            }
                            {
                              area      =   list.get foo 0;
                              suffix    =   splitRest (list.get foo 1);
                            }
                          else
                            debug.info "areaAndSuffix"
                            {
                              text = "foo == null";
                              data = rest;
                            }
                            defaultAreaAndSuffix;
                  }.${country} or defaultAreaAndSuffix
                else
                  defaultAreaAndSuffix;
          in
            type.matchPrimitiveOrPanic number
            {
              set                       =   fromSet number;
              string
              =   {
                    inherit country;
                    area                =   areaAndSuffix.area;
                    suffix              =   areaAndSuffix.suffix;
                  };
            };
  in
  {
    inherit formatTeX parse;
  }
