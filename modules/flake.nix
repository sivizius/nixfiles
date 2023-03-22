{
  description                           =   "Sivizius’ custom (modified) NixOS-modules.";
  inputs
  =   {
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
        libconfig.url                   =   "github:sivizius/nixfiles/development?dir=libs/config";

        nixpkgs.url                     =   "github:sivizius/nixpkgs/master";

        home-manager.url                =   "github:nix-community/home-manager/master";
        simple-nix-mailserver.url       =   "git+https://gitlab.com/simple-nixos-mailserver/nixos-mailserver.git";
      };
  outputs
  =   {
        self,
        libcore,
        libconfig,

        # Foreign Modules
        home-manager,
        nixpkgs,
        simple-nix-mailserver,
        ...
      }:
        let
          core                          =   libcore.lib   { inherit self; debug.logLevel = "info"; };
          inherit(core) path;
        in
          path.import ./.
          {
            inherit core;
            context                     =   [ "modules" ];
            config                      =   libconfig.lib { inherit self; };
            foreign                     =   { inherit home-manager nixpkgs simple-nix-mailserver; };
          };
}
