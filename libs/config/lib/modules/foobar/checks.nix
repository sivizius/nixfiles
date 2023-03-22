{ extendPath, ... }:
let
  inherit(builtins) all attrValues dirOf elem false storeDir substring true throw typeOf;

  maxI8                           =   maxU8   / 2;
  maxI16                          =   maxU16  / 2;
  maxI32                          =   maxU32  / 2;

  maxU8                           =   255;
  maxU16                          =   65535;
  maxU32                          =   4294967295;

  minI8                           =   0 - maxI8   - 1;
  minI16                          =   0 - maxI16  - 1;
  minI32                          =   0 - maxI32  - 1;

  #isCoercibleToPath               =   x: isCoercibleToString x && isAbsolutePath x;
  #isSetCoercibleToString          =   x: x ? outPath || x ? __toString;
  #isSetOf                         =   { elemType, ... }: x: isSet x && all elemType.check (attrValues x);

  implementsToString              =   { __toString ? null, ... }: __toString != null;

  isAbsolutePath                  =   x: isInstanceOf [ "String" "Path" ] x && (substring 0 1 x.value) == "/";
  isAny                           =   _: true;
  isBool                          =   isInstanceOf "Bool";
  isDictionary                    =   isInstanceOf "Dictionary";
  isDictionaryOf                  =   { elemType, ... }: x: isDictionary x && all elemType.check (attrValues x.value);
  isDerivation                    =   isInstanceOf "Derivation";
  isFloat                         =   isInstanceOf "Float";
  isFloatBetween                  =   { from, till }: x: isFloat x && x.value >= from && x.value <= till;
  isFunction                      =   isInstanceOf "Function";
  isInList                        =   list: x: elem x list;
  isInstanceOf                    
  =   type: 
      { __type__, ... }: 
        {
          list                    =   elem __type__ type;
          string                  =   __type__ == type;
        }.${typeOf type} or (throw "isInstanceOf expects list of strings or a string");
  isInteger                       =   isInstanceOf "Integer";
  isIntegerBetween                =   { from, till }: x: isInteger x && x.value >= from && x.value <= till;
  isList                          =   isInstanceOf "List";
  isListOf                        =   mightBeEmpty: { elemType, ... }: x: isList x && (x.value != [] || mightBeEmpty) && all elemType.check x.value;
  isNever                         =   _: false;
  isNonEmptyString                =   x: isString x && match "[ \t\n]*" x.value == null;
  isNonNegativeNumber             =   x: isNumber x && x.value >= 0;
  isNull                          =   isInstanceOf "Null";
  isNumber                        =   isInstanceOf [ "Float" "Integer" ];
  isNumberBetween                 =   { from, till }: x: isNumber x && x.value >= from && x.value <= till;
  isOptionType                    =   isInstanceOf "OptionType";
  isPackage                       =   x: isDerivation x || isStorePath x;
  isPath                          =   isInstanceOf "Path"; 
  isPositiveInteger               =   x: isInteger x && x.value > 0;
  isPositiveNumber                =   x: isNumber x && x.value > 0;
  isSignedByte                    =   x: isInteger x && x.value >= minI8  && x.value <= maxI8;
  isSignedLong                    =   x: isInteger x && x.value >= minI32 && x.value <= maxI32;
  isSignedWord                    =   x: isInteger x && x.value >= minI16 && x.value <= maxI16;
  isStorePath
  =   x:
        if !(isList x)
        && implementsToString x
        then
          let
            x'                    =   toString x;
          in
            isAbsolutePath x' && dirOf x' == storeDir
        else
          false;
  isString                        =   isInstanceOf "String"; 
  isStringMatching                =   regex: x: isString x && (match regex x.value) != null;
  isUnsignedInteger               =   x: isInteger x && x.value >= 0;
  isUnsignedByte                  =   x: isUnsignedInteger x && x.value <= maxU8;
  isUnsignedLong                  =   x: isUnsignedInteger x && x.value <= maxU32;
  isUnsignedWord                  =   x: isUnsignedInteger x && x.value <= maxU16;
in
{
  inherit implementsToString;
  inherit isAbsolutePath isAny isBool isDictionary isDictionaryOf isDerivation isFloat
          isFloatBetween isFunction isInList isInstanceOf isInteger isIntegerBetween isList
          isListOf isNever isNonEmptyString isNonNegativeNumber isNull isNumber isNumberBetween
          isOptionType isPackage isPath isPositiveInteger isPositiveNumber isSignedByte
          isSignedLong isSignedWord isStorePath isString isStringMatching isUnsignedInteger
          isUnsignedByte isUnsignedLong isUnsignedWord;
};
