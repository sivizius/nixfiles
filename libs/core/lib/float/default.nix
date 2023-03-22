{ intrinsics, type, ... }:
  let
    isInstanceOf                        =   intrinsics.isFloat or (value: type.getPrimitive value == "float");
  in
    type "float"
    {
      inherit isInstanceOf;
      isPrimitive                       =   true;

      orNull
      =   value:
            isInstanceOf value || value == null;
    }
