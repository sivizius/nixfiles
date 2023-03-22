{
  description = "NixTeX is a nix-library to create TeX-files and compile them e.g. to the Portable Document Format";
  inputs
  =   {
        fork-awesome.url                =   "github:sivizius/nixfiles?dir=packages/fork-awesome";
        libconfig.url                   =   "github:sivizius/nixfiles?dir=libs/config";
        libcore.url                     =   "github:sivizius/nixfiles?dir=libs/core";
        nixpkgs.url                     =   "github:sivizius/nixpkgs/master";
      };
  outputs
  =   { self, fork-awesome, libconfig, libcore, nixpkgs, ... }:
        let
          core                          =   libcore.lib { inherit self; debug.logLevel = "info"; };
        in
        {
          lib
          =   core.path.import ./.
              {
                inherit core fork-awesome nixpkgs;
                stdenv                  =   libconfig.stdenv;
              };
        };
}
