{ core, context, extendPath, ... }:
{ ... } @ env:
{ configuration, options, source } @ self:
  let
    inherit(core) debug list set string type;

    collect
    =   { ... } @ state:
        { configuration, source }:
          debug.info "collect"
          {
            text                        =   "from ${toString source}";
            data                        =   configuration;
          }
          (
            let
              cfg                       =   import configuration;
              src                       =   configuration;
              fail
              =   typeName:
                    debug.panic
                      "collect"
                      "Got ${typeName} ${string configuration}, what should I do with it?";
            in
              type.matchPrimitive configuration
              {
                bool                    =   fail "boolean";
                float                   =   fail "float";
                int                     =   fail "integer";
                lambda                  =   collectRegular  state  { inherit configuration source;  };
                list                    =   collectList     state  { inherit configuration source;  };
                null                    =   state;  # Just Ignore
                path                    =   collect         state  { configuration = cfg; source = src;  };
                set                     =   collectSet      state  configuration;
                string                  =   collect         state  { configuration = cfg; source = src;  };
              }
          );

    collectImports
    =   { ... } @ state:
        { configuration, source }:
          debug.info "collectImports"
          {
            text                        =   "from ${toString source}";
            data                        =   configuration;
          }
          (
            let
              cfg                       =   import configuration;
              src                       =   configuration;
            in
              type.matchPrimitiveOrPanic configuration
              {
                lambda                  =   collectLegacy   state { inherit configuration source; };
                path                    =   collectImports  state { configuration = cfg; source = src; };
                string                  =   collectImports  state { configuration = cfg; source = src; };
              }
          );

    collectLegacy
    =   { ... } @ state:
        { configuration, source }:
          let
            legacyConfig
            =   configuration
                {
                  inherit(finalState) config;
                  inherit(env.nixpkgs) lib;
                  pkgs                  =   env.registries.nix.packages;
                };
            state'
            =   list.fold
                  (collectImports source)
                  state
                  (legacyConfig.imports or []);
          in
            combine
              state'
              {
                configuration           =   set.remove legacyConfig [ "imports" ];
                inherit source;
              };

    collectList
    =   { ... } @ state:
        { configuration, source }:
          debug.info "collectList"
          {
            text                        =   "from ${toString source}";
            data                        =   configuration;
              ;
          }
          (
            list.fold
            (
              state:
              configuration:
                collect state { inherit configuration source; }
            )
            state
            configuration
          );

    collectRegular
    =   { ... } @ state:
        { configuration, source }:
          let
            regularConfig
            =   configuration
                {
                  inherit(env) core dateTime host registries;
                  config
                  =   debug.warn
                        "collectRegular"
                        "Use of `config` is deprecated!"
                        finalState.config;
                };
          in
            debug.info "collectRegular"
            {
              text                      =   "from ${toString source}";
              data                      =   configuration;
            }
            (
              combine
                state
                {
                  configuration         =   regularConfig;
                  inherit source;
                }
            );

    collectService
    =   { ... } @ state:
        { configuration, source }:
          let
            serviceConfig
            =   configuration
                {
                  inherit(env) core dateTime host registries;
                  inherit(finalState.config) services;
                };
          in
            debug.info "collectService"
            {
              text                      =   "from ${toString source}";
              data                      =   configuration;
            }
            (
              type.matchPrimitiveOrPanic configuration
              {
                lambda                  =   combine state { configuration = serviceConfig; inherit source; };
                set                     =   combine state { inherit configuration source; };
              }
            );

    collectSet
    =   { ... } @ state:
        { __type__ ? null, ... } @ self:
          let
            source                      =   set.getSource self;
          in
            if      __type__ == "Configuration" then  collectSpecial  state self
            else if __type__ == null            then  combine         state { configuration = self; inherit source; }
            else
              debug.panic
                "collectSet"
                "Unexpected Object of type ${__type__}. `Configuration` was expected";

    collectSpecial
    =   { ... } @ state:
        {
          __variant__ ?
          (
            debug.panic
              "collectSpecial"
              "Missing `__variant__`, type `Configuration` is an enum-type!"
          ),
          source ? null,
          ...
        } @ self:
          debug.info "collectSpecial"
          {
            text                        =   "from ${toString source}";
            data                        =   __variant__;
          }
          (
            {
              Legacy                    =   collectLegacy   state  self;
              Service                   =   collectService  state  self;
              User                      =   collectUser     state  self;
            }.${__variant__}
          );

    collectUser
    =   { ... } @ state:
        { configuration, source, user }:
          let
            userConfig
            =   configuration
                {
                  inherit(env) core dateTime home-manager profile registries;
                  config                =   userConfig;
                  user                  =   user // { config = userConfig; };
                };
          in
            debug.info "collectUser"
            {
              text                      =   "from ${toString source} (${user.name})";
              data                      =   configuration;
            }
            (
              type.matchPrimitiveOrPanic configuration
              {
                lambda                  =   combine state { configuration = userConfig; inherit source; };
                set                     =   combine state { inherit configuration source; };
              }
            );

    combine
    =   { options, path, ... } @ state:
        { configuration, source }:
          let
            combine                     =   set.fold merge;
            merge
            =   { config, options, path, ... } @ state:
                name:
                value:
                  let
                    path'               =   extendPath path name;
                  in
                  debug.info [ "combine" "merge" ]
                  {
                    text                =   path';
                    data                =   value;
                  }
                  (
                    if set.hasAttribute name options
                    then
                      let
                        configuration   =   value;
                        file            =   source;
                        option          =   options.${name};
                        values          =   config.${name} or [];
                      in
                      (
                        if option.__type__ or null == "Option"
                        then
                          config
                          //  {
                                ${name}
                                =   values
                                ++  [ { inherit file value; } ];
                              }
                        else
                          if type.isSet value
                          then
                            combine
                              {
                                config  =   config.${name};
                                options =   option;
                                path    =   path';
                              }
                              { inherit configuration source; }
                          else
                            debug.panic
                              [ "combine" "merge" ]
                              {
                                text
                                =   ''
                                      Option `${path'}` is an attribute set.
                                      It cannot be combined with a `${type.getPrimitive value}`
                                    '';
                                data    =   option;
                              }
                      )
                    else
                      debug.panic
                        [ "combine" "merge" ]
                        "Unknown option `${path'}` in ${source}"
                  );
          in
            debug.info "combine"
            {
              text                      =   "${toString source}";
              data                      =   configuration;
            }
            (
              state
              //  {
                    config              =   combine state configuration;
                  }
            );

    finalState
    =   collect
          {
            inherit options;
            config                      =   {};
            path                        =   null;
          }
          self;
  in
    debug.info []
    {
      text                              =   "options";
      data                              =   set.names options;
    }
    finalState
