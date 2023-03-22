{ intrinsics, ... }:
{
  panic                                 =   intrinsics.throw;
  inherit(intrinsics) abort throw;
}