{ intrinsics, type, ... }:
  type "null"
  {
    isInstanceOf                        =   value: value == null;
    isPrimitive                         =   true;

    default
    =   value:
        other:
          if value != null
          then
            value
          else
            other;

    inherit(intrinsics) null;
  }