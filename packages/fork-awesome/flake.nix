{
  description                           =   "Fork Awesome Icons";
  inputs
  =   {
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
        nixpkgs.url                     =   "github:sivizius/nixpkgs/master";
      };
  outputs
  =   { self, libcore, nixpkgs, ... }:
        let
          core                          =   libcore.lib { inherit self; debug.logLevel = "info"; };
          inherit(core) path target;
        in
        {
          packages
          =   target.System.mapStdenv
              (
                system:
                  let
                    fork-awesome
                    =   path.import ./.
                        {
                          inherit(nixpkgs) lib;
                          inherit(nixpkgs.legacyPackages."${system}") fetchFromGitHub stdenv;
                        };
                  in
                  {
                    inherit fork-awesome;
                    default             =   fork-awesome;
                  }
              );
        };
}
