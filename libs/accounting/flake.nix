{
  description                           =   "…";
  inputs
  =   {
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
      };
  outputs
  =   { self, libcore, ... }:
        let
          core                          =   libcore.lib { inherit self; debug.logLevel = "warn"; };
        in
          core.path.import ./. { inherit core; };
}