{
  description                           =   "Sivizius’ profiles.";
  inputs
  =   {
        hardware.url                    =   "github:NixOS/nixos-hardware/master";
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
        libconfig.url                   =   "github:sivizius/nixfiles/development?dir=libs/config";
        nixpkgs.url                     =   "github:sivizius/nixpkgs/master";
        services.url                    =   "github:sivizius/nixfiles/development?dir=services";
      };
  outputs
  =   { self, hardware, libcore, libconfig, nixpkgs, services, ... }:
        let
          core                          =   libcore.lib   { inherit self; debug.logLevel = "info"; };
          config                        =   libconfig.lib { inherit self; };

          inherit(core) context set;
          inherit(config.profiles) load importLegacy mapLegacy;

          legacyProfiles
          =   importLegacy { inherit nixpkgs; }
              [
                "all-hardware"
                "base"
                "clone-config"
                "demo"
                "docker-container"
                "graphical"
                "hardened"
                "headless"
                "installation-device"
                "minimal"
                "qemu-guest"
              ];

          mapLegacy'
          =   source:
              profiles:
                mapLegacy
                (
                  set.map
                  (
                    name:
                    configuration:
                    {
                      inherit configuration;
                      source            =   source name;
                    }
                  )
                  profiles
                );

          profiles
          =   legacyProfiles
          //  mapLegacy'
                (
                  context "github:NixOS/nixos-hardware"
                  [
                    { fileName = "flake.nix"; }
                    "outputs"
                    "nixosModules"
                  ]
                )
                hardware
          //  load ./.
              {
                inherit core profiles;
                inherit(services) services;
              };
        in
        {
          profiles
          =   core.debug.debug "profiles"
              {
                nice                    =   true;
                show                    =   true;
                when = false;
              }
              profiles;
        };
}
