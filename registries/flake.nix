{
  description                           =   "Packages";
  inputs
  =   {
        fork-awesome.url                =   "github:sivizius/nixfiles/development?dir=packages/fork-awesome";
        libconfig.url                   =   "github:sivizius/nixfiles/development?dir=libs/config";
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
        nixpkgs.url                     =   "github:sivizius/nixpkgs/master";
        redshift-wayland.url            =   "github:sivizius/nixfiles/development?dir=packages/redshift-wayland";
        wofi-unpatched.url              =   "github:sivizius/nixfiles/development?dir=packages/wofi-unpatched";
      };
  outputs
  =   { self, fork-awesome, libconfig, libcore, nix, nixpkgs, redshift-wayland, wofi-unpatched, ... }:
        let
          inherit(libconfig.lib { inherit self; })  packages;
          inherit(libcore.lib   { inherit self; debug.logLevel = "info"; }) path set target;

          config
          =   {
                allowedNonSourcePackages
                =   [
                      "adoptopenjdk-hotspot-bin"
                      "ant"
                      "discord"
                      "electron"
                      "ghidra"
                      "gradle"
                      "hplip"
                      "i2p"
                      "iscan"
                      "iscan-data"
                      "iscan-gt-f720-bundle"
                      "iscan-gt-s80-bundle"
                      "iscan-gt-x770-bundle"
                      "iscan-gt-x820-bundle"
                      "iscan-nt-bundle"
                      "libreoffice"
                      "libreoffice-7.3.7.2-wrapped"
                      "pdftk"
                      "signal-desktop"
                      "sof-firmware"
                      "spotify"
                      "tor-browser-bundle-bin"
                      "vscodium"
                      "wine"
                    ];
                allowedUnfreePackages
                =   [
                      "discord"
                      "hopper"
                      "memtest86-efi"
                      "spotify"
                      "hplip"
                      "iscan"
                      "iscan-data"
                      "iscan-gt-f720-bundle"
                      "iscan-gt-s80-bundle"
                      "iscan-gt-x770-bundle"
                      "iscan-gt-x820-bundle"
                      "iscan-nt-bundle"
                    ];
              };

          custom
          =   target.System.mapStdenv
              (
                system:
                {
                  fork-awesome          =   fork-awesome.packages."${system}";
                  redshift-wayland      =   redshift-wayland.packages."${system}";
                  wofi-unpatched        =   wofi-unpatched.packages."${system}";
                }
              );

          registries
          =   { inherit custom; }
          //  (
                set.mapValues
                  (packages.fromNixpkgs { inherit config nixpkgs; })
                  (path.import ./.)
              );
        in
          #builtins.trace self._type
              #debug.debug "registries" { text = "Hello World"; when = true; }
        {
          registries
          =   (
                target.System.mapStdenv
                (
                  system:
                    set.mapValues
                    (
                      { ... } @ registry:
                        registry."${system}"
                    )
                    registries
                )
              )
          //  {
                __functor
                =   { ... } @ registries:
                    { targetSystem, ... }:
                      registries."${targetSystem}";
              };
        };
}
