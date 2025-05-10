# ignore
{
# /ignore
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
      let
        cfg = config;
      in
        (concatMap profileToConfig' parents)
        ++  (concatMap serviceToConfig' services)
        ++  [
              (
                { config, ... }:
                  cfg
                  {
                    services = config.services;
                  }
              )
            ];
# …
serviceToConfig
=   network:
    {
      about,
      config,
      name,
      requires,
      __type__,
    }:
      let
        cfg = config;
      in
        (concatMap (serviceToConfig' network) requires)
        ++  [
              (
                { config, ... }:
                  cfg
                  {
                    services = config.services;
                    inherit network;
                  }
              )
            ];
# …
hostToConfig
=   name:
    {
      about,
      config,
      name,
      network,
      profile,
      services,
      system,
      users,
      __type__,
    } @ host:
      let
        cfg = config;
        network'
        =   network
        //  {
              trustedKeys
              =   concatMap
                  (
                    { keys, ... }:
                      if hazAttribute name keys
                      then
                        [ keys.${name} ]
                      else
                        [ ]
                  )
                  ( values users );
            };
      in
        trace "evaluate host ''${name} (''${about})…"
        (
          nixpkgs.lib.nixosSystem
          {
            inherit system;
            # I should somehow ensure not to import configurations
            #   of profile and services multiple times e.g. by comparing the names.
            modules
            =   (profileToConfig' profile)
            ++  (concatMap (serviceToConfig' network') services)
            ++  (map (userToConfig' { inherit profil; }) users)
            ++  [
                  (
                    { config, ... }:
                      cfg
                      {
                        inherit host;
                      }
                  )
                ];
          }
        );
# …
userToConfig
=   { profile, ... }:
    {
      config,
      keys,
      __type__,
    }:
      let
        cfg = config;
      in
        { config, ... }:
          cfg
          {
            inherit profile;
          };
# ignore
}
# /ignore