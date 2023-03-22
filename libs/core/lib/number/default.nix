{ debug, expression, float, integer, intrinsics, list, string, type, ... }:
  let
    assertNumber#: int | float -> int | float | !
    =   value:
          matchNumber value
          {
            float                       =   value;
            int                         =   value;
          };

    matchNumber#: T -> { int: R, float: R } -> R | !
    # where T, R: Any
    =   value:
        { int, float } @ select:
          type.matchPrimitiveOrDefault
            value
            select
            ( debug.panic "matchNumber" "Value is not a number: Neither int nor float!" );

    abs#: int | float -> int | float
    =   value:
          let
            value'                      =   assertNumber value;
          in
            if value' < 0
            then
              ( 0 - value' )
            else
              value';

    add#: int | float -> int | float -> int | float
    =   intrinsics.add or (a: b: ( assertNumber a ) + ( assertNumber b ));

    and#: int -> int -> int
    =   intrinsics.bitAnd;

    ceil#: int | float -> int
    =   intrinsics.ceil;

    div#: int | float -> int | float -> int | float
    =   intrinsics.div or (a: b: ( assertNumber a ) / ( assertNumber b ));

    floor#: int | float -> int
    =   intrinsics.floor;

    isInstanceOf
    =   value:
          integer.isInstanceOf value
          || float.isInstanceOf value;

    lessThan#: int | float -> int | float -> int | float
    =   intrinsics.lessThan or (a: b: ( assertNumber a ) < ( assertNumber b ));

    moreThan#: int | float -> int | float -> int | float
    =   a: b: ( assertNumber a ) > ( assertNumber b );

    mul#: int | float -> int | float -> int | float
    =   intrinsics.mul or (a: b: ( assertNumber a ) * ( assertNumber b ));

    neg#: int | float -> int | float
    =   value: ( 0 - ( assertNumber value ) );

    or#: int -> int -> int
    =   intrinsics.bitOr;

    orNull
    =   value:
          isInstanceOf value || value == null;

    pow#: int -> int | float -> int | float
    =   let
          pow#: int -> int | float -> int | float
          =   base:
              exp:
                list.fold
                  (y: x: x*y)
                  1.0
                  (list.generate (x: base) exp);
        in
          base:
          exp:
            if exp < 0.0
            then
              pow ( 1.0 / base ) ( 0 - exp )
            else
              pow ( 1.0 * base ) exp;

    round#: int | float -> int
    =   value:
          #debug.info "round" { data = { inherit value; value' = value + 0.5; round = floor ( value + 0.5 ); }; }
          matchNumber value
          {
            int                         =   value;
            float                       =   round' value;
          };

    round'#: float -> int
    =   value: floor ( value + 0.5 );

    sub#: int | float -> int | float -> int | float
    =   intrinsics.sub or (a: b: (assertNumber a) - (assertNumber b));

    sum#: [ int | float ] -> int | float
    =   list.fold (result: value: result + value) 0;

    toFloat#: int | float | string -> float
    =   value:
          type.matchPrimitiveOrDefault value
          {
            int                         =   1.0 * value;
            float                       =   value;
            /*string
            =   let
                  parts                   =   string.match "([0-9]*)[.](0*)([0-9]*)" value;
                  len                     =   string.length parts.dec;
                in
                  ( ( 1.0 * ( toInteger parts.dec ) ) / ( pow 10 len ) )
                  + ( toInteger parts.int );*/
          }
          ( debug.panic "toFloat" "Cannot convert ${type.getPrimitive value} to float." );

    toInteger#: int | float | string -> int
    =   value:
          type.matchPrimitiveOrDefault value
          {
            float                       =   round' value;
            int                         =   value;
            string
            =   let
                  result                =   toInteger' value;
                in
                  if result != null
                  then
                    result
                  else
                    debug.panic "toInteger" "Could not convert string ${value} to int!";
          }
          ( debug.panic "toInteger" "Could not convert type ${type value} to int!" );

    toInteger'#: string -> int | null
    =   value:
          let
            value'                      =   string.match "([+-])?0*([0-9.][0-9]+)" value;
            result                      =   expression.fromJSON ( list.get value' 1);
            sign                        =   list.head value';
          in
            if value' != null
            && integer.isInstanceOf result
            then
              if sign == "-"
              then
                ( - result )
              else
                result
            else
              null;

    toStringWithMaximumPrecision#: int | float -> int -> string
    =   value:
        precision:
          if precision > 0
          then
            list.foldReversed
              (
                state:
                character:
                  if state != null          then  "${character}${state}"
                  else if character == "."  then  ""
                  else if character != "0"  then  character
                  else                            null
              )
              null
              ( string.toCharacters ( toStringWithPrecision value precision ) )
          else
            toStringWithPrecision value precision;

    splitFloat
    =   value:
        precision:
          let
            factor                      =   pow 10 precision;
            value'                      =   string ( round ( value * factor ) );
            length                      =   string.length value';
            padding                     =   string.concat (list.generate (_: "0") (precision - length));
          in
            debug.debug "splitFloat"
            {
              text                      =   "called with/calculated:";
              data
              =   {
                    inherit value precision factor value' length;
                  };
            }
            (
              if length > precision
              then
                let
                  mid                   =   length - precision;
                  integer               =   string.slice  0   mid       value';
                  decimal               =   string.slice  mid precision value';
                in
                  debug.debug "splitFloat"
                  {
                    text                =   "length > precision";
                    data                =   { inherit integer decimal mid; };
                  }
                  { inherit decimal integer; }
              else
                let
                  integer               =   "0";
                  decimal               =   "${padding}${value'}";
                in
                  debug.debug "splitFloat"
                  {
                    text                =   "length <= precision";
                    data                =   { inherit integer decimal padding; };
                  }
                  { inherit decimal integer; }
            );

    toStringWithPrecision#: int | float -> int -> string
    =   value:
        precision:
          let
            precision'
            =   type.matchPrimitiveOrDefault precision
                {
                  int                   =   precision;
                  null                  =   getPrecision value;
                }
                ( debug.panic "toStringWithPrecision" "Invalid Precision: Int or null expected!" );
            valuePos                    =   splitFloat (0.0 + value)  precision';
            valueNeg                    =   splitFloat (0.0 - value)  precision';
            valueWithPrecision
            =   debug.info "toStringWithPrecision" { text = "value"; data = value; }
                debug.info "toStringWithPrecision" { text = "precision"; data = [ precision precision' ]; }
                (
                  if precision' == 0
                  then
                    "${string (round value)}"
                  else if value >= 0
                  then
                    "${valuePos.integer}.${valuePos.decimal}"
                  else
                    "-${valueNeg.integer}.${valueNeg.decimal}"
                );
          in
            type.matchPrimitiveOrDefault value
            {
              float                     =   valueWithPrecision;
              int                       =   valueWithPrecision;
              list                      =   string.concatMappedCSV (x: toStringWithPrecision x precision) value;
              set
              =   (
                    { from, till }:
                    "${toStringWithPrecision from precision}–${toStringWithPrecision till precision}"
                  )
                  value;
            }
            ( debug.panic "toStringWithPrecision" "Value must be a numeric value like int or float!" );

    toSignificantString#: int | float -> string
    =   value:
          toStringWithPrecision value null;

    getPrecision
    =   value:
          debug.info "getPrecision" { text = "value"; data = value; }
          (
            if  value == 0.0
            ||  value >= 2.0
            ||  value <= -2.0
            then
              0
            else
              (getPrecision (value * 10)) + 1
          );

    xor#: int -> int -> int
    =   intrinsics.bitXor;
  in
    type "number"
    {
      inherit isInstanceOf orNull;
      inherit abs add and ceil div floor lessThan moreThan mul neg or pow round round' sub sum xor;
      inherit toFloat toInteger toInteger' toSignificantString toStringWithMaximumPrecision toStringWithPrecision;
    }
