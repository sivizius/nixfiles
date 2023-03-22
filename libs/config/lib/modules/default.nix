{ configurations, core, ... } @ libs:
  let
    inherit(core) debug library list set string type;

    Module#: [ Module ] -> { string -> Option } -> ({ ... } -> { string -> T }) -> Module
    =   {
          __type__                      =   "Type";
          __variant__                   =   "Module";
          isInstanceOf                  =   configurations.check Module.__variant__;
          __functor
          =   { __variant__, ... }:
              { ... } @ options:
              evaluate:
              {
                __type__                =   __variant__;
                inherit evaluate options;
                extraConfig             =   {};

                __functor
                =   { config, ... } @ self:
                    { ... } @ extraConfig:
                      self
                      //  {
                            config      =   config // extraConfig;
                          };
              };
        };

    Option
    =   {
          __type__                      =   "Type";
          __variant__                   =   "Option";
          isInstanceOf                  =   configurations.check Option.__variant__;

          __functor
          =   { __variant__, ... }:
                let
                  __type__              =   __variant__;
                in
                  type:
                  { default ? null }:
                  meta:
                  {
                    inherit __type__ default type;
                    meta                =   toMeta meta;
                  };

          ifEnabled
          =   { enable, ... }:
              { ... } @ value:
                if enable
                then
                  value
                else
                  {};
        }
    //  (library.import ./options.nix libs);

    configureModules
    =   modulePath:
        environment:
          set.map
          (
            moduleName:
            {
              __type__      ? null,
              dependencies  ? null,
              evaluate      ? null,
              options       ? null,
              source        ? null,
              ...
            } @ module:
              let
                name
                =   if modulePath != null
                    then
                      "${modulePath}.${string.escapeKey moduleName}"
                    else
                      string.escapeKey moduleName;
              in
                if __type__ != null
                then
                {
                  inherit __type__ name source;
                  dependencies
                  =   debug.panic
                        "configureModules"
                        {
                          text          =   "The dependencies of module ${name} are not of type `[ Module ]`";
                          data          =   dependencies;
                          nice          =   true;
                          when          =   !(type.isList dependencies);
                        }
                        list.map
                          (
                            source:
                              load source environment
                          )
                          dependencies;
                  evaluate
                  =   debug.panic
                        "configureModules"
                        {
                          text          =   "The evaluator of module ${name} ist not of type `T -> U`";
                          data          =   evaluate;
                          nice          =   true;
                          when          =   !(type.isFunction evaluate);
                        }
                        evaluate;
                  options
                  =   configureOptions
                        name
                        environment
                        (
                          loadOptions
                            options
                            environment
                        );
                }
                else
                  configureModules name environment module
          );

    configureOptions
    =   optionPath:
        environment:
          set.map
          (
            optionName:
            {
              __type__  ? null,
              ...
            } @ option:
              let
                name                    =   "${optionPath}.${string.escapeKey optionName}";
              in
                if __type__ != null
                then
                  option // { inherit name; }
                else
                  configureOptions name environment option
          );

    constructors
    =   {
          inherit Module Option;
        };

    expandName
    =   optionPath:
        optionName:
          if optionPath != null
          then
            "${optionPath}.${optionName}"
          else
            optionName;

    load
    =   source:
        environment:
          let
            config                      =   loadModules       source environment;
            config'                     =   configureModules  config environment;
          in
            config';

    loadModules
    =   source:
        environment:
          configurations.load
            source
            environment
            constructors
            Module.isInstanceOf;

    loadOptions
    =   source:
        environment:
          configurations.load
            source
            environment
            constructors
            Option.isInstanceOf;

    toMeta
    =   let
          setToMeta
          =   {
                example     ? null,
                description ? null,
              }:
              {
                inherit example description;
              };
        in
          meta:
            type.matchPrimitiveOrPanicOrFail meta
            {
              null
              =   {
                    description         =   null;
                    example             =   null;
                  };
              set                       =   setToMeta meta;
              string
              =   {
                    description         =   meta;
                    example             =   null;
                  };

            };
  in
    constructors
    //  {
          inherit load;
        }
