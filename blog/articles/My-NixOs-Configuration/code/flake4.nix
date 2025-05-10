{ nixpkgs, ... }:
let
  # Better place this in ./lib/default.nix or something like this…
  # {
    inherit(builtins) concatMap isAttrs mapAttrs scopedImport throw trace;

    Profile
    =   about:
        {
          config,
          isDesktop ? false,
          parents ? [],
          services ? [],
        }:
        {
          inherit about config isDesktop parents services;
          __type__  = "Profile";
          name      = null;
        };
    profileToConfig
    =   {
          __type__,
          about,
          config,
          isDesktop,
          name,
          parents,
          services,
        }:
          (concatMap profileToConfig' parents)
          ++  (concatMap serviceToConfig' services)
          ++  [ config ];
    profileToConfig'
    =   profile:
          if  isAttrs profile
          &&  profile.__type__ or null == "Profile"
          then
            profileToConfig profile
          else
            throw "Profile expected!";

    Service
    =   about:
        {
          config,
          requires ? [],
        }:
        {
          inherit about config requires;
          __type__  = "Service";
          name      = null;
        };
    serviceToConfig
    =   {
          about,
          config,
          name,
          requires,
          __type__,
        }:
          (concatMap serviceToConfig' requires)
          ++  [ config ];
    serviceToConfig'
    =   service:
          if  isAttrs service
          &&  service.__type__ or null == "Service"
          then
            serviceToConfig service
          else
            throw "Service expected!";

    Host
    =   about:
        {
          config,
          profile,
          services  ? [],
          system,
        }:
        {
          inherit about config profile services system;
          __type__  = "Host";
        };
    hostToConfig
    =   name:
        {
          about,
          config,
          name,
          profile,
          services,
          system,
          __type__,
        }:
          trace "evaluate host ''${name} (''${about})…"
          (
            nixpkgs.lib.nixosSystem
            {
              inherit system;
              # I should somehow ensure not to import configurations
              #   of profile and services multiple times e.g. by comparing the names.
              modules
              =   (profileToConfig' profile)
              ++  (concatMap serviceToConfig' services)
              ++  [ config ];
            }
          );
    hostToConfig'
    =   name:
        host:
          if host.__type__ or null == "Host"
          then
            hostToConfig name host
          else
            throw "Host expected!";

    mapHosts = mapAttrs hostToConfig';

    nameElements
    =   mapAttrs
        (
          name:
          value:
            value // { inherit name; }
        );
  # }

  # If you ignore the stuff above, this is actually quite clear and concise
  hosts
  =   (
        scopedImport ./hosts
          { inherit Host; }
          { inherit profiles services; }
      );
  profiles
  =   nameElements
      (
        scopedImport ./profiles
          { inherit Profile; }
          { inherit services; }
      );
  services
  =   nameElements
      (
        scopedImport ./services
          { inherit Service; }
          {}
      );
in
{
  nixosConfigurations = mapHosts hosts;
}