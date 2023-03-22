{
  description                           =   "Configure and Deploy NixOS";
  inputs
  =   {
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
        libsecrets.url                  =   "github:sivizius/nixfiles/development?dir=libs/secrets";
        libstore.url                    =   "github:sivizius/nixfiles/development?dir=libs/store";
        libweb.url                      =   "github:sivizius/nixfiles/development?dir=libs/web";
        nixpkgs.url                     =   "github:sivizius/nixpkgs/master";
      };
  outputs
  =   { self, libcore, libsecrets, libstore, libweb, nixpkgs, ... }:
        let
          core                          =   libcore.lib { inherit self; debug.logLevel = "info"; };
        in
          core.path.import ./.
          {
            inherit core nixpkgs;
            secrets                     =   libsecrets.lib  { inherit self; };
            store                       =   libstore.lib;
            inherit(libsecrets.nixosModules)  vault;
            web
            =   libweb.lib { inherit self; }
            //  {
                  module                =   libweb.nixosModules.default;
                };
          };
}
