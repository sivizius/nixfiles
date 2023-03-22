{ about, configurations, core, devices, hosts, networks, profiles, secrets, systems, users, versions, ... }:
  let
    inherit(configurations) mapToArguments mapToLegacy sortUniqueChecked;
    inherit(core)           context debug library list set string target;
    inherit(hosts)          PrepareArgument;
    inherit(secrets)        secret;
    inherit(systems)        SystemConfiguration;

    collectAbout                        =   about.collect;
    collectConfig                       =   x: x;
    collectDevices                      =   devices.collect;
    collectNetwork                      =   networks.collect;
    collectProfile                      =   profiles.collect;
    collectSystem                       =   systems.collect;
    collectUsers                        =   users.collect;
    collectVersion                      =   versions.collect;

    prepareEnvironment
    =   { ... } @ arguments:
        { ... } @ environment:
          debug.debug "prepareEnvironment"
          {
            text                        =   "(environment // arguments)";
            data                        =   set.names (environment // arguments);
          }
          set.map
          (
            name:
            value:
              debug.debug "prepareEnvironment"
              {
                text                    =   name;
                data                    =   value;
              }
              (
                if  PrepareArgument.isInstanceOf value
                ||  (
                      library.isInstanceOf value
                      && !value.isInitialised
                    )
                then
                  let
                    value'              =   value (environment // arguments);
                  in
                    debug.debug "prepareEnvironment"
                    {
                      text              =   "value'";
                      show              =   true;
                      showType          =   false;
                    }
                    value'
                else
                  value
              )
          )
          environment;
    #inherit(deploy) toNixOSconfiguration;
  in
    { modules, ... }:
    { ... } @ environment:
    { about, config ? [], devices, name, network, profile, source, system, users, version, ... } @ host:
      let
        arguments
        =   debug.debug "arguments"
            {
              nice                      =   true;
              show                      =   true;
            }
            (mapToArguments configurations);

        configurations
        =   debug.debug "configurations"
            {
              show                      =   true;
              nice                      =   true;
            }
            (
              sortUniqueChecked
              (
                []
                ++  ( collectAbout      about       )
                ++  ( collectConfig     config      )
                ++  ( collectDevices    devices     )
                ++  ( collectConfig     config      )
                ++  ( collectNetwork    network     )
                ++  ( collectProfile    profile     )
                ++  ( collectSystem     system      )
                ++  ( collectUsers      users       )
                ++  ( collectVersion    version     )
              )
            );

        nixosConfiguration
        =   debug.debug "nixosConfiguration"
            {
              show                      =   true;
              nice                      =   true;
              when = false;
            }
            (
              target.System.mapStdenv
              (
                buildSystem:
                  let
                    buildPlatform       =   string buildSystem;
                    systemConfig
                    =   SystemConfiguration
                        {
                          configuration.nixpkgs
                          =   {
                                inherit buildPlatform;
                              };
                          source        =   source "buildSystem";
                        };
                  in
                    mapToLegacy
                    {
                      inherit host modules;
                      configurations    =   configurations ++ [ systemConfig ];
                      environment
                      =   prepareEnvironment
                            {
                              inherit buildSystem secret;
                              targetSystem
                              =   system;
                            }
                            environment;
                    }
              )
            );

        /*
        buildScript
        =   store.write.shellScript
            {
              name                =   "deploy-${name}";
              inherit system;
            }
            ''
              ${scriptHeader}
              # Build ${name}
            '';

        builder
        =   store.write.shellScript
            {
              inherit name system;
            }
            ''
              source $stdenv/setup
              mkdir -p $out
              ln -s ${buildScript} $out/build.sh
              ln -s ${deployScript} $out/deploy.sh
            '';


        deployScript
        =   store.write.shellScript
            {
              name                =   "deploy-${name}";
              inherit system;
            }
            ''
              ${scriptHeader}
              # Deploy ${name} via ${deployment.method}
              #nix copy --to ${deployment.address} ???
            '';

        scriptHeader
        =   ''
              # Name: ${name}
              # Description: ${string.replace [ "\n" ] [ "\n#   " ]; about}
            '';*/
      in
        host
        //  {
              inherit arguments configurations nixosConfiguration;
            }
