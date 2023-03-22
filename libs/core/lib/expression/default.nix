{ intrinsics, ... }:
{
  inherit(intrinsics) addErrorContext deepSeq fromJSON fromTOML seq toJSON toXML tryEval;
}