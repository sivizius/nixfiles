{
  description                           =   "Build Websites.";
  inputs
  =   {
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
        nixpkgs.url                     =   "github:sivizius/nixpkgs/master";
      };
  outputs
  =   { self, libcore, nixpkgs, ... }:
        let
          core                          =   libcore.lib { inherit self; debug.logLevel = "info"; };
        in
          core.path.import ./.
          {
            inherit core;
            inherit(nixpkgs) lib;
          };
}
