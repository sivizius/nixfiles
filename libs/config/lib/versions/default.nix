{ core, systems, ... }:
  let
    inherit(core)     debug string time type version;
    inherit(systems)  SystemConfiguration;

    config
    =   stateVersion:
        { dateTime, host, ... }:
        {
          boot.loader.grub
          =   {
                configurationName       =   "${host.network.hostName}-${version.deriveVersion dateTime}";
              };
          system
          =   {
                inherit stateVersion;
              };
        };

    collect
    =   { source, version, ... }:
        [
          (
            SystemConfiguration
            {
              configuration             =   config version;
              inherit source;
            }
          )
        ];

    prepare
    =   environment:
        host:
        version:
        {
          version                       =   string.expect version;
          source                        =   host.source "version";
        };
  in
  {
    inherit collect prepare;
  }