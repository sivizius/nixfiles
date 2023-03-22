{ core, nixpkgs, secrets, vault, web, ... } @ libs:
  let
    inherit(core)     context debug derivation lambda library list path set string type;
    inherit(secrets.secret) Secret;
    inherit(secrets.vault)  Vault;
    inherit(web.html)       HTML;

    Configuration
    =   let
          debug'                        =   debug "Configuration";

          defaultCall
          =   { environment, host, ... }:
              { arguments, configuration, wrap, ... } @ this:
                debug'.error "defaultCall"
                {
                  text
                  =   ''
                        ${type.format this} should not be a function, that depends on `config`.
                      '';
                  data                  =   this;
                  when                  =   list.find "config" arguments;
                }
                wrap
                (
                  this
                  //  {
                        configuration   =   configuration (environment // { inherit host; });
                      }
                );

          defaultWrap
          =   { configuration, ... }:
                configuration;

          toLegacy
          =   theVault:
                let
                  fix
                  =   source:
                      value:
                        let
                          result
                          =   fixDictionary
                                source
                                (set.expect value);
                        in
                          debug.debug "fix"
                          {
                            text        =   "Config of ${context.formatRelative source}";
                            data        =   value;
                            showType    =   false;
                          }
                          debug.debug "fix"
                          {
                            text        =   "Secrets of ${context.formatRelative source}";
                            data        =   result.secrets;
                            nice        =   true;
                            when        =   result.secrets != {};
                          }
                          result.value
                          //  (
                                set.ifOrEmpty (result.secrets != {})
                                {
                                  vault
                                  =   (result.value.vault or {})
                                  //  {
                                        secrets
                                        =   if result.value ? vault.secrets
                                            then
                                              Vault.update
                                                result.value.vault.secrets
                                                result.secrets
                                            else
                                              result.secrets;
                                      };
                                }
                              );

                  fixInner
                  =   source:
                      value:
                        debug.debug "fixInner"
                        {
                          text          =   "Option ${context.formatRelative source}";
                          data          =   value;
                          when          =   !set.isInstanceOf value;
                        }
                        type.matchPrimitiveOrDefault value
                          {
                            list        =   fixList source value;
                            set         =   fixSet  source value;
                          }
                          {
                            secrets     =   {};
                            inherit value;
                          };

                  fixList
                  =   source:
                      value:
                        debug.debug "fixList"
                        {
                          text          =   "Option ${context.formatRelative source}";
                          data          =   value;
                        }
                        list.fold
                        (
                          { index, secrets, value }:
                          entry:
                            let
                              result    =   fixInner (source index) entry;
                            in
                            {
                              secrets   =   Vault.update secrets result.secrets;
                              index     =   index + 1;
                              value     =   value ++ [ result.value ];
                            }
                        )
                        {
                          secrets       =   {};
                          index         =   0;
                          value         =   [];
                        }
                        value;

                  fixDictionary
                  =   source:
                      value:
                        debug.debug "fixDictionary"
                        {
                          text          =   "Option ${context.formatRelative source}";
                          data          =   value;
                        }
                        set.fold
                          (
                            { secrets, value }:
                            attribute:
                            entry:
                              let
                                result  =   fixInner (source attribute) entry;
                              in
                              if debug.Debug.isInstanceOf result
                              then
                                "${result}"
                              else
                              {
                                secrets =   Vault.update secrets result.secrets;
                                value   =   value // { ${attribute} = result.value; };
                              }
                          )
                          {
                            secrets     =   {};
                            value       =   {};
                          }
                          value;

                  fixSet
                  =   source:
                      { ... } @ value:
                        debug.debug "fixSet"
                        {
                          text          =   "Option ${context.formatRelative source}";
                          data          =   value;
                          when          =   value._type or null == null;
                        }
                        (
                          if  derivation.isInstanceOf' value
                          ||  value._type or null != null
                          ||  HTML.isInstanceOf value
                          then
                          {
                            inherit value;
                            secrets       =   {};
                          }
                          else if type.getType value == null
                          then
                            fixDictionary source value
                          else if debug.Debug.isInstanceOf value
                          then
                            abort "${value}"
                          else if Secret.isInstanceOf value
                          then
                            theVault source value
                          else
                            debug'.panic [ "toLegacy" "fixSet" ]
                            {
                              text        =   "Got Object in ${context.formatRelative source}:";
                              data        =   value;
                            }
                            null
                        );
                in
                  args:
                  { call, configuration, source, wrap, ... } @ this:
                    let
                      this'
                      =   this
                      //  {
                            arguments   =   set.names (lambda.arguments configuration);
                            wrap        =   wrap';
                          };
                      wrap'             =   x: fix source (wrap x);
                      imports
                      =   type.matchPrimitiveOrPanic configuration
                          {
                            lambda      =   [ (call args this') ];
                            set         =   [ (wrap' this') ];
                          };
                    in
                    {
                      #inherit source;
                      _file             =   context.formatFileName source;
                      imports           =   imports;
                    };
        in
          type "Configuration"
          {
            from
            =   variant:
                {
                  call ? defaultCall,
                  wrap ? defaultWrap,
                }:
                { configuration, source, ... } @ config:
                  Configuration.instanciateAs variant
                  (
                    config
                    //  {
                          inherit call toLegacy wrap;
                        }
                  );
          };

    Configuration'                      =   variant: Configuration variant {};

    LegacyConfiguration
    =   Configuration "Legacy"
        {
          call
          =   { ... }:
              { configuration, ... }:
                configuration;
        };

    collect
    =   let
          collectPath
          =   { source, ... } @ this:
              fileName:
                collect
                (
                  this
                  //  {
                        configuration   =   path.import fileName;
                        source          =   source { inherit fileName; };
                      }
                );
        in
          { configuration, ... } @ this:
            type.matchPrimitiveOrPanic configuration
            {
              lambda                    =   [ this ];
              list
              =   list.concatMap
                    (configuration: collect (this // { inherit configuration; }) )
                    configuration;
              null                      =   [];  # Just Ignore
              path                      =   collectPath this configuration;
              set                       =   [ this ];
              string                    =   collectPath this configuration;
            };

    load                                =   library.import ./load.nix libs;

    mapToArguments
    =   list.map
        (
          config:
            let
              config'                   =   Configuration.expect config;
              arguments                 =   set.names (lambda.arguments config'.configuration);
            in
              debug.warn "mapToArguments"
              {
                text                    =   "Unknown Source";
                data                    =   config';
                when                    =   config'.source == null;
              }
              type.matchPrimitiveOrPanic config'.configuration
              {
                lambda                  =   "${type.getVariant config'}: { ${string.concatCSV arguments} } from ${context.formatRelative config'.source}";
                set                     =   "${type.getVariant config'}: – from ${context.formatRelative config'.source}";
              }
        );

    mapToLegacy
    =   { configurations, environment, host, modules, ... }:
          let
            theVault                    =   Vault {};

            configurations'
            =   list.map
                  (
                    { toLegacy, ... } @ cfg:
                      toLegacy theVault
                        {
                          inherit host modules;
                          environment
                          =   environment
                          //  {
                                inherit(host) users;
                                inherit(config) config;
                                inherit(config.config) websites;
                              };
                        }
                        cfg
                  )
                  configurations;

            modules'
            =   (set.values modules)
            ++  [ web.module vault ]
            ++  configurations';

            config
            =   debug.info "mapToLegacy"
                {
                  text                  =   "modules'";
                  data                  =   modules';
                  nice                  =   true;
                }
                debug.debug "mapToLegacy"
                {
                  text                  =   "environment";
                  data                  =   set.names environment;
                  nice                  =   true;
                  when = false;
                }
                debug.debug "mapToLegacy"
                {
                  text                  =   "nixosSystem";
                  show                  =   true;
                  nice                  =   true;
                  when = false;
                }
                (
                  nixpkgs.lib.nixosSystem
                  {
                    baseModules         =   [];
                    extraModules        =   [];
                    inherit(nixpkgs) lib;
                    modules             =   modules';
                    modulesLocation     =   null;
                    pkgs                =   null;
                    prefix              =   [];
                    specialArgs         =   {};
                    system              =   null;
                  }
                );
          in
            config;

    sortUniqueChecked
    =   configurations:
          let
            configurations'
            =   list.fold
                (
                  result:
                  config:
                    let
                      config'           =   Configuration.expect config;
                      result'           =   insert result config';
                    in
                      debug.panic "sortUniqueChecked"
                      {
                        text            =   "Configuration expected";
                        data            =   config;
                        when            =   !(Configuration.isInstanceOf config);
                      }
                      debug.panic "sortUniqueChecked"
                      {
                        text            =   "Could not insert";
                        show            =   true;
                        when            =   debug.Debug.isInstanceOf result';
                      }
                      result'
                )
                {}
                configurations;

            insert
            =   { ... } @ result:
                { configuration, source, ... } @ config:
                  let
                    stringContext       =   string.getContext key;
                    key                 =   "${context.formatRelative source}";
                    # Should be safe, as long the keys of resulting attribute set are discarded?
                    key'                =   "${type.getVariant config} ${string.discardContext key}";
                    value               =   result.${key'} or null;
                  in
                    debug.debug "sortUniqueChecked"
                    {
                      text              =   "Remove String-Context of ${key}";
                      data              =   stringContext;
                      when              =   stringContext != {};
                    }
                    (
                      if      configuration ==  {}
                      ||      configuration ==  null
                      then
                        result
                      else if value == null
                      then
                        result
                        //  {
                              ${key'}   =   config;
                            }
                      else
                        # Brackets are necessary to compare functions.
                        # See: https://cs.tvl.fyi/depot/-/blob/tvix/docs/value-pointer-equality.md
                        if [ value ] == [ config ]
                        then
                          result
                        else
                          debug.panic "sortUniqueChecked"
                          {
                            text        =   "Confliciting configurations from the same source ${key'} o.O";
                            data
                            =   {
                                  prev  =   value;
                                  next  =   config;
                                };
                            nice        =   true;
                          }
                          result
                    );
          in
            set.values configurations';
  in
  {
    inherit Configuration Configuration' LegacyConfiguration;
    inherit collect load mapToArguments mapToLegacy sortUniqueChecked;
  }
