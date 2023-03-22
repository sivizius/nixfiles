{ core, ... }:
  let
    inherit(core) debug integer number list string type;

    formatSign# string? -> string
    =   sign:
          if sign != null
          then
            {
              "+"                       =   "+";
              "-"                       =   "-";
              "+-"                      =   "{\\pm}";
              "-+"                      =   "{\\mp}";
            }.${sign} or "{${sign}}"
          else
            "";

    Unit#: U: ToUnit @ U -> Unit | !
    =   unit:
          type.matchPrimitiveOrPanic unit
          {
            null                        =   { inherit unit; };
            set
            =   {
                  prefix                =   unit.prefix or  null;
                  inherit unit;
                  sign                  =   unit.sign   or  null;
                  exp                   =   unit.exp    or  null;
                };
            string                      =   parseUnit unit;
          };

    parseUnit#: string -> Unit
    =   let
          prefixes                      =   "yotta|zetta|exa|peta|tera|giga|mega|kilo|hecto|deca";
          prefixes'                     =   "deci|centi|milli|micro|nano|pico|femto|atto|zepto|yocto";
          regex                         =   "(${prefixes}|${prefixes'})?([A-Za-z]+)([-+])?([0-9]+|[0-9]*[.][0-9]*)?";
        in
          unit:
            let
              parsed                    =   string.match regex unit;
            in
              if unit == "cm-1"
              then
              {
                prefix                  =   null;
                inherit unit;
                sign                    =   null;
                exp                     =   null;
              }
              else if unit == ""
              then
                null
              else if parsed != null
              then
              {
                prefix                  =   list.get parsed 0;
                unit                    =   list.get parsed 1;
                sign                    =   list.get parsed 2;
                exp                     =   list.get parsed 3;
              }
              else
                debug.panic "parseUnit" { data = unit; text = "Cannot parse unit:"; };

    formatUnit#: U: ToUnit @ [ U ] | U -> string
    =   unit:
          let
            text                        =   formatUnit' unit;
          in
            if text != null
            then
              "\\ensuremath{${text}}"
            else
              "";

    formatUnit'#: U: ToUnit @ [ U ] | U -> string
    =   maybeUnit:
          if list.isInstanceOf maybeUnit
          then
            string.concatMappedWith formatUnit' "\\cdot"  maybeUnit
          else
            let
              unit                      =   Unit maybeUnit;
              prefix
              =   if unit.prefix != null
                  && unit.prefix != ""
                  then
                    "\\acrshort{${unit.prefix}}"
                  else
                    "";
              link
              =   {
                    "gram"              =   "\\acrtext[kilogram]{g}";
                    "calorie"           =   "\\acrtext[kilocalorie]{cal}";
                  }.${unit.unit} or "\\acrshort{${unit.unit}}";
              formated                  =   "\\text{${prefix}${link}}";
              withNumericExponent
              =   if unit.exp < 0
                  then
                    "${formated}^{-\\text{${number.toSignificantString (0 - unit.exp)}}}"
                  else
                    "${formated}^{\\text{${number.toSignificantString unit.exp}}}";
              sign                      =   formatSign unit.sign;
            in
              if unit != null
              then
                type.matchPrimitiveOrPanic unit.exp
                {
                  null                  =   formated;
                  int                   =   withNumericExponent;
                  float                 =   withNumericExponent;
                  string                =   "${formated}^{${sign}${adjustNumbers unit.exp}}";
                }
              else
                null;

    parseValue'#: V: ToValue @ [ V ] | V -> Value
    =   nested:
        value:
          type.matchPrimitiveOrPanic value
          {
            string
            =   let
                  parsed                =   string.match "([-+]|[+][-]|[-][+])?([0-9])[.]?([0-9]*)e?([+-]?)([0-9.]*)" value;
                  precision             =   string.length (list.get parsed 2);
                in
                  if parsed != null
                  then
                    {
                      value
                      =   ( integer "0${list.get parsed 1}" )
                      +   ( ( integer "0${list.get parsed 2}" )
                          / ( number.pow 10 precision )
                          );
                      exp
                      =   let
                            exponent    =   list.get parsed 4;
                            sign        =   list.get parsed 3;
                          in
                            if exponent != "" then "${if sign == "-" then "-" else ""}${exponent}"
                            else                    "";
                      inherit precision;
                      sign              =   list.get parsed 0;
                    }
                  else
                    {
                      inherit value;
                      exp               =   null;
                      precision         =   null;
                      sign              =   null;
                    };
            float
            =   {
                  inherit value;
                  exp                   =   null;
                  precision             =   null;
                  sign                  =   null;
                };
            int
            =   {
                  inherit value;
                  exp                   =   null;
                  precision             =   0;
                  sign                  =   null;
                };
            set
            =   if value ? from
                && value ? till
                then
                  {
                    value               =   { inherit(value) from till; };
                    exp                 =   value.exp       or  null;
                    precision           =   value.precision or  null;
                    sign                =   value.sign      or  null;
                  }
                else
                {
                  value
                  =   type.matchPrimitiveOrPanic value.value
                      {
                        string          =   value.value;
                        float           =   value.value;
                        int             =   value.value;
                        set
                        =   if  value.value ? from
                            &&  value.value ? till
                            then
                              value.value
                            else
                              debug.panic "parseValue'" "from and till expected!";
                        list
                        =   if nested
                            then
                              list.map (parseValue' false) value.value
                            else
                              debug.panic "parseValue'" "Set-Value cannot be nested!";
                      };
                  exp
                  =   let
                        exp             =   value.exp or null;
                      in
                        type.matchPrimitiveOrPanic exp
                        {
                          null          =   null;
                          int           =   exp;
                          float         =   exp;
                          string        =   exp;
                        };
                  precision             =   value.precision or  (if integer.isInstanceOf value then 0 else null);
                  sign                  =   value.sign      or  null;
                };
            list
            =   if nested
                then
                  {
                    value               =   list.map (parseValue' false) value;
                    exp                 =   null;
                    precision           =   null;
                    sign                =   null;
                  }
                else
                  debug.panic "parseValue'" "Lists cannot be nested!";
          };

    parseValue#: V: ToValue @ [ V ] | V -> Value
    =   parseValue' true;

    formatValue#: V: ToValue, U: ToUnit @ V -> U -> string
    =   value:
        unit:
          "\\mbox{\\ensuremath{${formatValueInMath value unit}}}";

    formatValueInMath#: V: ToValue, U: ToUnit @ V -> U -> string
    =   value:
        unit:
          let
            valueText                   =   formatValue'  value;
            unitText                    =   formatUnit'   unit;
          in
            if unitText != null
            then
              "${valueText}\\,${unitText}"
            else
              valueText;

    formatValue'#: V: ToValue @ [ V ] | V -> string
    =   value:
          let
            value'                      =   parseValue value;
            numeric                     =   number.toStringWithPrecision value'.value value'.precision;
            valueText
            =   type.matchPrimitiveOrPanic value'.value
                {
                  set
                  =   let
                        text            =   number.toStringWithPrecision value'.value value'.precision;
                      in
                        if  value'.exp  !=  null
                        ||  value'.sign !=  null
                        then
                          "(${text})"
                        else
                          text;
                  string                =   "${value'.value}";
                  float                 =   numeric;
                  int                   =   numeric;
                  list
                  =   let
                        text
                        =   string.concatMappedCSV
                            (
                              { precision, ... } @ value:
                                formatValue'
                                (
                                  if precision != null
                                  then
                                    value // { inherit precision; }
                                  else
                                    value
                                )
                            )
                            value'.value;
                      in
                        if  value'.exp  !=  null
                        ||  value'.sign !=  null
                        then
                          "(${text})"
                        else
                          text;
                };
            exponentText
            =   let
                  withNumericExponent
                  =   if value'.exp < 0
                      then
                        "-\\text{${number.toSignificantString (0 - value'.exp)}}"
                      else
                        "\\text{${number.toSignificantString value'.exp}}";
                  exponent
                  =   type.matchPrimitiveOrPanic value'.exp
                      {
                        null            =   null;
                        int             =   withNumericExponent;
                        float           =   withNumericExponent;
                        string          =   adjustNumbers value'.exp;
                      };
                in
                  if exponent != null
                  then
                    "\\cdot\\text{10}^{${exponent}}"
                  else
                    "";
          in
            "${formatSign value'.sign}${adjustNumbers valueText}${exponentText}";

    adjustNumbers
    =   this:
          string.concatMapped
          (
            part:
              if list.isInstanceOf part
              then
                "\\text{${list.head part}}"
              else
                part
          )
          (string.split "([0-9]+|[0-9]*[.][0-9]*)" this);
  in
    { inherit formatValue formatValueInMath formatUnit; }