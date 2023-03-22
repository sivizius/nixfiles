{ intrinsics, type, ... }:
  let
    arguments#: F -> { bool... }
    # where
    #   F: { ... } -> T,
    #   T: Any
    =   intrinsics.functionArgs;

    fixPointOf#: F -> T
    # where
    #   F: T -> T
    =   self:
          let
            fixPoint                    =   self fixPoint;
          in
            fixPoint;

    identity#: T -> T
    =   x: x;

    isInstanceOf                        =   intrinsics.isFunction;

    orNull
    =   value:
          isInstanceOf value || value == null;
  in
    type "lambda"
    {
      isCallable                        =   x: true;
      isPrimitive                       =   true;

      fix                               =   fixPointOf;
      id                                =   identity;
      inherit arguments fixPointOf isInstanceOf orNull;
    }