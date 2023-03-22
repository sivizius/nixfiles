{
  description                           =   "Sivizius’ peers.";
  inputs
  =   {
        libconfig.url                   =   "github:sivizius/nixfiles/development?dir=libs/config";
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
        libsecrets.url                  =   "github:sivizius/nixfiles/development?dir=libs/secrets";
      };
  outputs
  =   { self, libconfig, libcore, libsecrets, ... }:
      let
        config                          =   libconfig.lib { inherit self; };
        core                            =   libcore.lib   { inherit self; debug.logLevel = "info"; };
      in
      {
        peers
        =   core.debug.debug "peers"
            {
              nice                      =   true;
              show                      =   true;
            }
            (
              config.peers.load ./.
              {
                inherit core;
                inherit(libsecrets.lib { inherit self; }) secret;
              }
            );
      };
}
