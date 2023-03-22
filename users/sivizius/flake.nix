{
  description                           =   "User-Configuration of sivizius";
  inputs
  =   {
        libconfig.url                   =   "github:sivizius/nixfiles/development?dir=libs/config";
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
      };
  outputs
  =   { self, libconfig, libcore, ... }:
      {
        user
        =   let
              config                    =   libconfig.lib { inherit self; };
            in
              config.users.load ./.
              {
                inherit config;
                core                    =   libcore.lib { inherit self; debug.logLevel = "info"; };
              };
      };
}
