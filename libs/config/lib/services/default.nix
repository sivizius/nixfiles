{ configurations, core, ... }:
  let
    inherit(configurations) Configuration;
    inherit(core)           debug list path set string type;

    Service
    =   type "Service"
        {
          from
          =   about:
              {
                configuration,
                legacy ? false,
              }:
                Service.instanciate
                {
                  inherit about configuration legacy;
                };
        };

    ServiceConfiguration
    =   Configuration "Service"
        {
          call
          =   { environment, host, ... }:
              { arguments, configuration, legacy, wrap, ... }:
                let
                  environment'
                  =   environment
                  //  {
                        inherit(host) network profile system version;
                      };
                in
                  wrap
                  {
                    inherit legacy;
                    configuration
                    =   configuration
                        (
                          environment'
                          //  {
                                inherit(environment.config) services websites;
                              }
                        );
                  };
          wrap
          =   { configuration, legacy, ... }:
                if legacy
                then
                  configuration
                else
                {
                  services              =   configuration;
                };
        };

    collect                             =   list.concatMap configure;

    configure
    =   { about, configuration, legacy, name, source, ... }:
          list.map
            ServiceConfiguration
            (
              configurations.collect
              {
                inherit configuration legacy source;
              }
            );

    constructors
    =   {
          inherit Service;
        };

    load
    =   source:
        environment:
          configurations.load
            source
            environment
            constructors
            Service;

    prepare
    =   environment:
        host:
        services:
          if set.isInstanceOf services
          then
            set.map (prepareService environment host) services
          else
            debug.panic "prepare" "The option `services` must be a set.";

    prepareService
    =   environment:
        host:
        name:
        service:
          {
            source                      =   host.source "services" name;
          }
          // (Service.expect service)
          // { inherit name; };
  in
    constructors
    //  {
          inherit collect constructors load prepare;
        }
