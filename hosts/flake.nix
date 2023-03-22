{
  description                           =   "Sivizius’ hosts.";
  inputs
  =   {
        home-manager.url                =   "github:sivizius/nixfiles/development?dir=home-manager";
        libconfig.url                   =   "github:sivizius/nixfiles/development?dir=libs/config";
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
        libsecrets.url                  =   "github:sivizius/nixfiles/development?dir=libs/secrets";
        libstore.url                    =   "github:sivizius/nixfiles/development?dir=libs/store";
        libweb.url                      =   "github:sivizius/nixfiles/development?dir=libs/web";
        modules.url                     =   "github:sivizius/nixfiles/development?dir=modules";
        peers.url                       =   "github:sivizius/nixfiles/development?dir=peers";
        profiles.url                    =   "github:sivizius/nixfiles/development?dir=profiles";
        registries.url                  =   "github:sivizius/nixfiles/development?dir=registries";
        sivizius.url                    =   "github:sivizius/nixfiles/development?dir=users/sivizius";
      };
  outputs
  =   { self, home-manager, libconfig, libcore, libsecrets, libstore, libweb, modules, peers, profiles, registries, sivizius, ... }:
      let
        config                          =   libconfig.lib   { inherit self; };
        core                            =   libcore.lib     { inherit self; debug.logLevel = "info"; };
        secrets                         =   libsecrets.lib  { inherit self; };

        inherit(core)         set target time;
        inherit(config.hosts) Host PrepareArgument load;

        hosts
        =   load ./.
              {
                modules                 =   modules.legacyModules.nixos;
              }
              {
                inherit           core self;
                inherit(peers)    peers;
                inherit(profiles) profiles;
                inherit(secrets)  secret;
                web                     =   libweb.lib { inherit self; };

                dateTime                =   time.parseDateTime self.lastModifiedDate;
                home-manager            =   home-manager.lib;
                registries              =   PrepareArgument registries.registries;
                store                   =   libstore.lib;
                users
                =   {
                      sivizius          =   sivizius.user;
                    };
              };

        filteredHosts                   =   set.filterValue (Host.isInstanceOf) hosts;

        packages
        =   target.System.mapStdenv
            (
              buildSystem:
                set.mapValues
                  ({ nixosConfiguration, ... }: nixosConfiguration."${buildSystem}".config.system.build.toplevel)
                  filteredHosts
            );
      in
      {
        inherit hosts packages;

        apps
        =   target.System.mapStdenv
            (
              buildSystem:
                set.mapValues
                  (
                    program:
                    {
                      type              =   "app";
                      inherit program;
                    }
                  )
                  packages
            );

        nixosConfigurations
        =   set.mapValues
              ({ nixosConfiguration, system, ... }: nixosConfiguration."${system}")
              filteredHosts;
      };
}
