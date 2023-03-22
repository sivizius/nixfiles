{
  description                           =   "Ghidra-Decompiler for Cutter";
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
                    rz-ghidra
                    =   path.import ./.
                        {
                          pkgs          =   nixpkgs.legacyPackages."${system}";
                          inherit(nixpkgs.legacyPackages."${system}") fetchFromGitHub stdenv;
                        };
                  in
                  {
                    inherit rz-ghidra;
                    default             =   rz-ghidra;
                  }
              );
        };
}
