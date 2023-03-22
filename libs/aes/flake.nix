{
  description                           =   "AES implemented as nix-expressions.";
  inputs
  =   {
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
      };
  outputs
  =   { self, libcore, ... }:
        let
          core                          =   libcore.lib { inherit self; debug.logLevel = "debug"; };
        in
          core.path.import ./. { inherit core self; };
}