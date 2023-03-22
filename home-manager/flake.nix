{
  description                           =   "Home-Manager";
  inputs
  =   {
        home-manager.url                =   "github:nix-community/home-manager/master";
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
      };
  outputs
  =   { self, home-manager, libcore, ... }:
        let
          core                          =   libcore.lib  { inherit self; debug.logLevel = "info"; };
          inherit(core) path;
        in
        {
          lib
          =   home-manager.lib
          //  ( path.import ./lib { inherit core; } );
          nixosModules                    =   home-manager.nixosModules.default;
        };
}
