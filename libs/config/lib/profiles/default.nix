{ configurations, core, services, ... }:
  let
    inherit(configurations) LegacyConfiguration Configuration;
    inherit(core)           context debug list path set type;

    Profile
    =   type "Profile"
        {
          from
          =   about:
              {
                configuration ? null,
                isDesktop     ? false,
                legacy        ? false,
                name          ? null,
                parents       ? [],
                services      ? [],
                source        ? null,
                ...
              }:
                Profile.instanciate
                (
                  {
                    inherit about configuration isDesktop legacy name services;
                    parents             =   list.map Profile.expect parents;
                  }
                  //  (
                        if source != null
                        then
                          { inherit source; }
                        else
                          { }
                      )
                );
        };

    ProfileConfiguration
    =   Configuration "Profile"
        {
          call
          =   { environment, host, ... }:
              { arguments, configuration, wrap, ... }:
                let
                  environment'
                  =   environment
                  //  { inherit(host) network system version; };
                in
                  wrap
                  {
                    configuration
                    =   configuration
                        (
                          environment'
                          //  {
                                config
                                =   debug.warn
                                      "ProfileConfiguration"
                                      "Argument `config` is deprecated!"
                                      environment.config;
                              }
                        );
                  };
        };

    collect
    =   { configuration, legacy, name, parents, services, source, ... } @ this:
          let
            args                        =   { inherit configuration name source; };
          in
            if legacy
            then
              [ (LegacyConfiguration args) ]
            else
              debug.debug "collect"
              {
                text                    =   "Non-Legacy Profile";
                data                    =   this;
                nice                    =   true;
              }
              (
                list.map
                  ProfileConfiguration
                  (configurations.collect args)
              )
              ++  (collectParents   parents)
              ++  (collectServices  services);

    collectParents                      =   list.concatMap collect;
    collectServices                     =   services.collect;

    constructors
    =   {
          inherit Profile;
        };

    load
    =   source:
        environment:
          configurations.load
            source
            environment
            (constructors // services.constructors)
            Profile;

    mapLegacy
    =   set.map
        (
          name:
          { configuration, source }:
            Profile "${name} (legacy)."
            {
              inherit configuration name source;
              legacy                    =   true;
            }
        );

    prepare
    =   environment:
        host:
        profile:
          {
            name                        =   "<Profile of Host ${host.name}>";
            source                      =   host.source "profile";
          }
          //  (Profile.expect profile);
  in
    constructors
    //  {
          inherit collect constructors load mapLegacy prepare;

          importLegacy
          =   { nixpkgs, ... }:
              modules:
                mapLegacy
                (
                  list.mapNamesToSet
                    (
                      name:
                      {
                        configuration   =   path.import "${nixpkgs}/nixos/modules/profiles/${name}.nix";
                        source
                        =   context "nixpkgs/nixos/modules/profiles"
                            {
                              fileName  =   "${nixpkgs}/nixos/modules/profiles/${name}.nix";
                            };
                      }
                    )
                    modules
                );
        }