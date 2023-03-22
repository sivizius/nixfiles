{
  description                           =   "Generate vCard-files.";
  inputs
  =   {
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
      };
  outputs
  =   { self, libcore, ... }:
        let
          core                          =   libcore.lib { inherit self; debug.logLevel = "info"; };
        in
          core.path.import ./.
          {
            inherit core;
          };
}
