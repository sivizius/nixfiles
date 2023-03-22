{
  description                           =   "Secrets";
  inputs
  =   {
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
        libstore.url                    =   "github:sivizius/nixfiles/development?dir=libs/store";
        #registries.url                  =   "github:sivizius/nixfiles/development?dir=registries";
      };
  outputs
  =   { self, libcore, libstore, ... }:
        let
          core                          =   libcore.lib   { inherit self; debug.logLevel = "info"; };
          store                         =   libstore.lib;
        in
          core.path.import ./. { inherit core self store; };
}