{
  description                           =   "Maintainers and Teams";
  inputs
  =   {
        libconfig.url                   =   "github:sivizius/nixfiles/development?dir=libs/config";
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
      };
  outputs
  =   { libconfig, libcore, ... }:
        let
          context                       =   [ "maintainers" ];
          inherit(libcore.lib) path;
          inherit(libconfig.lib) maintainers;

          import'
          =   directory:
                path.import
                  directory
                  { inherit(maintainers) GitHub Fingerprint Maintainer Team; }
                  { inherit people teams; };

          people                        =   maintainers.checkPeople (import' ./people);
          teams                         =   maintainers.checkTeams  (import' ./teams);
        in
          { inherit people teams; };
}
