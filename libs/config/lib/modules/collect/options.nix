{ core, context, extendPath, ... }:
options:
  let
    inherit(core) debug list set string type;

    addOption
    =   { options, ... } @ state:
        name:
        option:
          state
          //  {
                options
                =   options
                //  {
                      ${name}           =   option;
                    };
              };

    collect
    =   {
          __type__,
          apply,
          default,
          documentation,
          internal,
          optionType,
          path,
          readOnly,
        }:
        definitions:
          if type.isList definitions
          then
            let
              value
              =   if definitions == []
                  then
                    if optionType.check default
                    then
                      default
                    else
                      debug.panic
                        "collect"
                        "The default value of `${path}` does not match its type `${optionType.name}`!"
                  else if list.length definitions == 1
                  then
                    let
                      first             =   (list.head definitions).value;
                    in
                      if optionType.check first
                      then
                        first
                      else
                        debug.panic
                          "collect"
                          "The value of `${path}` does not match its type `${optionType.name}`!"
                  else if readOnly
                  then
                    debug.panic
                      "collect"
                      "The option `${path}` is read-only, but was set multiple times!"
                  else if list.any ({ value, ... }: optionType.check value) definitions
                  then
                    optionType.merge [ path ] definitions
                  else
                    debug.panic
                      "collect"
                      "A value of `${path}` does not match its type `${optionType.name}`!";
            in
              debug.warn
                "collect"
                {
                  when                  =   optionType.deprecationMessage != null;
                  text
                  =   ''
                        The type `${optionType.name}' of option `${path}' defined is deprecated.
                        ${optionType.deprecationMessage}
                      '';
                }
                value
          else
            debug.panic
              "collect"
              "A list of definitions expected, got ${type.getPrimitive definitions}";

    collects
    =   { config, options, ... }:
          if type.isSet config
          then
            set.map
            (
              name:
              {
                __type__ ? null,
                ...
              } @ option:
                if __type__ == "Option"
                then
                  collect
                    option
                    (config.${name} or [])
                else
                  collects
                  {
                    config              =   config.${name} or {};
                    options             =   option;
                  }
            )
            options
          else
            debug.panic
              "collects"
              "An attribute set of options expected, got ${type.getPrimitive config}";

    combineLegacy
    =   { ... } @ state:
        options:
          debug.info "combineLegacy"
          {
            text                        =   "mew";
            data                        =   options;
          }
          (
            set.fold
            (
              { options, path, ... } @ state:
              name:
              option:
                let
                  addOption'            =   addOption state name;
                  path'                 =   extendPath path name;
                in
                debug.debug "combineLegacy"
                {
                  text                  =   "${path'}";
                  data                  =   (set.names option);
                }
                (
                  if set.hasAttribute name options
                  then
                    if options.${name} ? __type__
                    then
                      debug.panic
                        "combineLegacy"
                        "Option `${path'}` already defined"
                    else if option.__type__ or null == null
                    then
                      addOption'
                        (
                          combineLegacy
                            {
                              options   =   options.${name};
                              path      =   path';
                            }
                            option
                        ).options
                    else
                      debug.panic
                        "combineLegacy"
                        "Option `${path'}` is already defined as an attribute set, so only attribute sets of options can be added"
                  else if option._type or null == "option"
                  then
                    addOption' (convertLegacy path' option)
                  else
                    addOption'
                      (
                        combineLegacy
                          {
                            options     =   {};
                            path        =   path';
                          }
                          option
                      ).options
                )
            )
            state
            options
          );

    combineModules
    =   state:
        {
          config    ? null,
          evaluate  ? null,
          imports   ? [],
          legacy,
          options,
          ...
        }:
          if legacy
          then
            combineLegacy  state options
          else
            combine        state options;

    combine
    =   state:
        options:
          set.fold
          (
            { options, path, ... } @ state:
            name:
            option:
              let
                addOption'              =   addOption state name;
                path'                   =   extendPath path name;
              in
                if set.hasAttribute name options
                then
                  if options.${name} ? __type__
                  then
                    debug.panic
                      "combine"
                      "Option `${path'}` already defined"
                  else if option.__type__ or null == null
                  then
                    addOption'
                      (
                        combine
                          {
                            options     =   options.${name};
                            path        =   path';
                          }
                          option
                      ).options
                  else
                    debug.panic
                      "combine"
                      "Option `${path'}` is already defined as an attribute set, so only attribute sets of options can be added"
                else
                  addOption' option
          )
          state
          options;

    convertLegacy
    =   path:
        {
          default         ? null,
          defaultText     ? null,
          example         ? null,
          description     ? null,
          relatedPackages ? null,
          type            ? null,
          apply           ? (x: x),
          internal        ? false,
          value           ? null,
          visible         ? true,
          readOnly        ? false,
          ...
        }:
        debug.info "convertLegacy"
        {
          text                          =   "value?";
          when                          =   value != null;
          data                          =   value;
        }
        {
          __type__                      =   "Option";
          documentation
          =   if visible
              then
              {
                default
                =   if defaultText != null
                    then
                      defaultText
                    else
                      string default;
                inherit description example relatedPackages;
                type                    =   { inherit(type) description descriptionClass name; };
              }
              else
                null;
          inherit apply default internal path readOnly;
          optionType                    =   convertLegacyType type;
        };

    convertLegacyType
    =   {
          check,                        # T -> bool
          deprecationMessage,           # string?
          description,                  # string
          descriptionClass,             # irrelevant?
          emptyValue,                   # {} | { value: T; }
          functor,                      # string -> type -> wrapped -> payload: P -> (binop: P -> P -> P) ->
          getSubOptions,                # T -> { string -> U }
          getSubModules,                # [ LegacyModule ]?
          merge,                        # [ string ] -> [ { file: path; value: T; } ] -> { string -> T }
          name,                         # string
          nestedTypes,                  # irrelevant?
          substSubModules,              # T -> U
          typeMerge,                    # T -> T -> T
          ...
        }:
        {
          inherit check deprecationMessage merge name;
        };

    options'
    =   combineLegacy
        {
          options                       =   {};
          path                          =   null;
        }
        (set.remove options [ "_module" ]);
  in
