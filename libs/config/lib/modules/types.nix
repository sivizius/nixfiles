{ core, ... }:
  let
    inherit(core) debug;

    positiveInteger
    =   {
          isInstanceOf                  =   value: integer.isInstanceOf value && value > 0;
        };

    positiveNumber
    =   {
          isInstanceOf                  =   value: number.isInstanceOf value && value > 0;
        };

    maxI8                               =   maxU8   / 2;
    maxI16                              =   maxU16  / 2;
    maxI32                              =   maxU32  / 2;

    maxU8                               =   255;
    maxU16                              =   65535;
    maxU32                              =   4294967295;

    minI8                               =   0 - maxI8   - 1;
    minI16                              =   0 - maxI16  - 1;
    minI32                              =   0 - maxI32  - 1;
  in
    set.mapValues
    (
      value:
        debug.panic []
        {
          text                          =   "Type expected.";
          when
          =   !set.isInstanceOf value
          ||  value.__type__ or null != "Type";
        }
        value
    )
    {
      inherit(core) any bool float integer never null number path set string;



      positiveInteger = primitive positiveInteger.isInstanceOf;
      positiveNumber  = primitive positiveNumber.isInstanceOf;
    }

/*
    [
      ( foo: bar: { name = "either";            check = checks.isEitherOr       either;               merge = merge.eitherOr inner;       } )
      ( variants: { name = "enum";              check = checks.isInList         payload;                merge = merge.equal;                } )
      ( subtype:  { name = "listOf";            check = checks.isListOf         empty inner;            merge = merge.lists;                } )
      ( subtype:  { name = "nullOr";            check = checks.isNullOr         inner;                  merge = merge.nullOr inner;         } )
      ( subtype:  { name = "setOf";             check = checks.isSetOf          inner;                   merge = merge.sets;                 } )

      ( { name = "deferredModule";    check = checks.isNever;                         merge = merge.never;                } )
      ( { name = "functionTo";        check = checks.isFunction;                      merge = merge.functions inner;      apply = applyFn inner;   } )
      ( { name = "intBetween";        check = checks.isIntegerBetween range;          inherit(variants.int) merge;        } )
      ( { name = "lazyAttrsOf";       check = checks.isSetOf          inner;                   merge = merge.sets;                 } )
      ( { name = "nonEmptyStr";       check = checks.isNonEmptyString;                inherit(variants.str) merge;        } )
      ( { name = "numberBetween";     check = checks.isNumberBetween  range;           merge = merge.equal;                } )
      ( { name = "numberNonnegative"; check = checks.isNonNegativeNumber;             merge = merge.equal;                } )
      ( { name = "numberPositive";    check = checks.isPositiveNumber;                merge = merge.equal;                } )
      ( { name = "optionType";        check = checks.isOptionType;                    merge = merge.null;                 } )
      ( { name = "package";           check = checks.isPackage;                       merge = merge.never;                } )
      ( { name = "passwdEntry";       check = checks.isNever;                                  merge = merge.never;                } )
      ( { name = "positiveInt";       check = checks.isPositiveInteger;               inherit(variants.int) merge;        } )
      ( { name = "raw";               check = checks.isAny;                           merge = merge.never;                } )
      ( { name = "separatedString";   check = checks.isString;                        merge = merge.stringsWith payload;  } )
      ( { name = "signedInt8";        check = checks.isSignedByte;                    inherit(variants.int) merge;        } )
      ( { name = "signedInt16";       check = checks.isSignedWord;                    inherit(variants.int) merge;        } )
      ( { name = "signedInt32";       check = checks.isSignedLong;                    inherit(variants.int) merge;        } )
      ( { name = "singleLineStr";     check = checks.isStringMatching "[^\n\r]*\n?";  merge = merge.line;                 } )
      ( { name = "strMatching";       check = checks.isStringMatching pattern;        inherit(variants.str) merge;        } )
      ( { name = "submodule";         inherit(subtype)  check;                         merge = merge.never;                } )
      ( { name = "uniq";              inherit(subtype)  check;                           merge = merge.never;                } )
      ( { name = "unique";            inherit(subtype)  check;                           merge = merge.never;                } )
      ( { name = "unsignedInt";       check = checks.isUnsignedInteger;               inherit(variants.int) merge;        } )
      ( { name = "unsignedInt8";      check = checks.isSignedByte;                    inherit(variants.int) merge;        } )
      ( { name = "unsignedInt16";     check = checks.isSignedWord;                    inherit(variants.int) merge;        } )
      ( { name = "unsignedInt32";     check = checks.isSignedLong;                    inherit(variants.int) merge;        } )
      ( { name = "unspecified";       check = checks.isAny;                           merge = merge.default;              } )
    ]
*/
