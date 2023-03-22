{ configurations, core, nixpkgs, ... }:
  let
    inherit(configurations) Configuration';
    inherit(core)           debug list path set string target type;

    SystemConfiguration                 =   Configuration'  "System";

    collect
    =   hostSystem:
        [
          (
            SystemConfiguration
            {
              configuration
              =   { registries, ... }:
                  {
                    nixpkgs
                    =   debug.info "collectSystem"
                        {
                          text          =   "registries";
                          data          =   set.names registries;
                          nice          =   true;
                        }
                        {
                          hostPlatform  =   string hostSystem;
                          pkgs          =   registries.nix;
                        };
                  };
              inherit(hostSystem) source;
            }
          )
        ];

    prepare
    =   environment:
        host:
        system:
          let
            system'                     =   target.System system;
          in
            {
              source                    =   host.source "system";
            }
            //  system';
  in
  {
    inherit SystemConfiguration;
    inherit collect prepare;
  }
