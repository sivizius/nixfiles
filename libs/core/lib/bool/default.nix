{ intrinsics, type, ... }:
  let
    bool
    =   type "bool"
        {
          inherit(intrinsics) false true;

          and#: bool -> bool -> bool
          =   a: b: ( bool.expect a ) && ( bool.expect b );

          equivalent#: bool -> bool -> bool
          =   a: b: ( bool.expect a ) == ( bool.expect b );

          format
          =   condition:
                bool.select condition "true" "false";

          formatLegacy
          =   condition:
                bool.select condition "1" "";

          implies#: bool -> bool -> bool
          =   a: b: ( bool.expect a ) -> ( bool.expect b );

          isInstanceOf                  =   intrinsics.isBool or (value: value == true || value == false);
          isPrimitive                   =   true;

          not#: bool -> bool
          =   a: !( bool.expect a );

          or#: bool -> bool -> bool
          =   a: b: ( bool.expect a ) || ( bool.expect b );

          orNull
          =   value:
                bool.isInstanceOf value || value == null;

          select#: bool -> T -> T -> T
          # where T: Any
          =   condition:
              ifTrue:
              ifFalse:
                if condition  then  ifTrue
                else                ifFalse;
        };
  in
    bool
