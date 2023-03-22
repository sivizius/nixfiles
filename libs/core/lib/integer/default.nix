{ bool, debug, expression, float, intrinsics, list, string, type, ... }:
  let
    inherit(intrinsics) toString;

    abs                                 =   x: bool.select (x >= 0) x (-x);

    from#: int | float | string -> int
    =   value:
          type.matchPrimitiveOrDefault value
          {
            float                       =   float.round' value;
            int                         =   value;
            string
            =   let
                  result                =   toInteger value;
                in
                  if result != null
                  then
                    result
                  else
                    debug.panic "from" "Could not convert string ${value} to int!";
          }
          (
            debug.panic
              "from"
              {
                text                    =   "Could not convert type ${type.get value} to int!";
                data                    =   value;
              }
          );

    isInstanceOf                        =   intrinsics.isInt or (value: type.getPrimitive value == "int");

    divmod
    =   value:
        modulus:
          let
            value'                      =   value / modulus;
          in
          {
            value                       =   value';
            rest                        =   value - value' * modulus;
          };

    orNull
    =   value:
          isInstanceOf value || value == null;

    and                                 =   intrinsics.bitAnd;
    or                                  =   intrinsics.bitOr;
    xor                                 =   intrinsics.bitXor;

    toInteger#: string -> int | null
    =   value:
          let
            value'                      =   string.match "([+-])?0*(.+)" value;
            result                      =   expression.fromJSON ( list.get value' 1);
            sign                        =   list.head value';
          in
            if isInstanceOf result
            then
              if sign == "-"
              then
                ( 0 - result )
              else
                result
            else
              null;

    formatHexByte
    =   value:
          let
            lsNibble                    =   and value 15;
            msNibble                    =   value / 16;
          in
            "${formatHexNibble msNibble}${formatHexNibble lsNibble}";

    formatHexDWord
    =   value:
          let
            lsWord                      =   and value 65535;
            msWord                      =   value / 65536;
          in
            "${formatHexWord msWord}${formatHexWord lsWord}";

    formatHexNibble                     =   list.get [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" ];

    formatHexQWord
    =   value:
          let
            lsDWord                     =   and value 4294967295;
            msDWord                     =   value / 4294967296;
          in
            "${formatHexDWord msDWord}${formatHexDWord lsDWord}";

    formatHexWord
    =   value:
          let
            lsByte                      =   and value 255;
            msByte                      =   value / 256;
          in
            "${formatHexByte msByte}${formatHexByte lsByte}";

    integer
    =   type "integer"
        {
          isPrimitive                   =   true;

          signed
          =   type "SignedInteger"
              {
                #isInstanceOf            =   value: isInstanceOf value;
              };

          unsigned
          =   type "UnsignedInteger"
              {
                #isInstanceOf            =   value: isInstanceOf value && value >= 0;
              };

          inherit abs and divmod from isInstanceOf or orNull toInteger toString xor;
          inherit formatHexByte formatHexDWord formatHexNibble formatHexQWord formatHexWord;
          formatHexaDecimal
          =   value:
                let
                  sign                  =   bool.select (value < 0) "-" "";
                  value'                =   abs (integer.expect value);
                  format
                  =   if      value' < 256        then  formatHexByte
                      else if value' < 65536      then  formatHexWord
                      else if value' < 4294967296 then  formatHexDWord
                      else                              formatHexQWord;
                in
                  "${sign}0x${format value'}";
        };
  in
    integer
