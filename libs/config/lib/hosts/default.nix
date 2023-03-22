{ configurations, core, devices, hosts, networks, peers, services, users, ... } @ libs:
  let
    inherit(core) debug library set string target type;

    Host
    =   type "Host"
        {
          from
          =   about:
              configuration:
                debug.debug "Host"
                {
                  data                  =   configuration;
                  nice                  =   true;
                }
                Host.instanciate
                {
                  inherit about configuration;
                };
        };

    PrepareArgument
    =   type "PrepareArgument"
        {
          __public__                    =   [];
          from
          =   inner:
                PrepareArgument.instanciate
                {
                  inherit inner;
                  __functor             =   { inner, ... }: inner;
                };
        };

    configure                           =   library.import ./configure.nix libs;

    constructors
    =   {
          inherit Host PrepareArgument;
        };

    load
    =   source:
        arguments:
        environment:
          let
            config
            =   configurations.load
                  source
                  environment
                  constructors'
                  Host;

            configure'
            =   networkName:
                  set.map
                  (
                    hostName:
                    {
                      about         ? null,
                      configuration ? null,
                      source        ? null,
                      ...
                    } @ node:
                      let
                        name
                        =   networks.extendName
                              networkName
                              hostName;
                      in
                        if Host.isInstanceOf node
                        then
                          configure
                            arguments
                            environment
                            (
                              Host.instanciate
                              (
                                prepare
                                  environment
                                  ( configuration // { inherit about name source; } )
                              )
                            )
                        else
                          configure' name node
                  );

            constructors'
            =   constructors
            //  devices.constructors
            //  peers.constructors
            //  services.constructors
            //  users.constructors;
          in
            configure'
              null
              config;

    prepare                             =   library.import ./prepare.nix libs;
  in
    constructors
    //  {
          inherit constructors load;
        }
