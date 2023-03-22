{ extendPath, ... } @ lib:
let
  inherit(builtins) all attrNames attrValues concatMap concatStringsSep dirOf elem elemAt filter foldl'
                    fromJSON functionArgs genList getFlake head listToAttrs isAttrs isBool isFloat
                    isFunction isInt isList isPath isString map match removeAttrs replaceStrings
                    split storeDir stringLength substring toString tryEval trace typeOf
                    unsafeGetAttrPos;

  checks                                =   import ./checks.nix lib;
  merge                                 =   import ./merge.nix  lib;

  coerceToString
  =   {
        bool
        =   { value, ... }:
              if value
              then
                "true"
              else
                "false";
        default
        =   { value, ... }:
              toString value;
        dictionary
        =   { value, ... }:
              let
                keyValuePairs
                =   attrValues
                    (
                      mapAttrs
                      (
                        name:
                        value:
                          "${extendPath null name} = ${toObject value};"
                      )
                      value
                    );
              in
                "{ ${concatStringsSep " " keyValuePairs} }";
        string
        =   { value, ... }:
              "\"${value}\"";
      };

  convertLegacy
  =   {
        "abi"
        =   context:
            { ... } @ value:
            {
              __type__        =   "ApplicationBinaryInterface";
              abi             =   value.abi         or  null;
              assertions      =   value.assertions  or  [];
              family          =   value.family;
              float           =   value.float       or  null;
              name            =   value.name;
            };
        "cpuType"
        =   context:
            { ... } @ value:
            {
              __type__        =   "CPUType";
              arch            =   value.arch    or  null;
              bits            =   value.bits;
              endianess       =   toObject (extendPath context "significantByte") value.significantByte;
              name            =   value.name;
              version         =   value.version or  null;
            };
        "exec-format"
        =   context:
            { ... } @ value:
            {
              __type__        =   "ExecutableFormat";
              __toString      =   { name, ... }: name;
              name            =   value.name;
            };
        "if"
        =   context:
            { ... } @ value:
            {
              __type__        =   "ConfigureIf";
              condition       =   value.condition;
              content         =   value.content;
            };
        "kernel"
        =   context:
            { ... } @ value:
            {
              __type__        =   "Kernel";
              executables     =   toObject (extendPath context "execFormat") value.execFormat;
              families        
              =   let
                    context'  =   extendPath context "families";
                  in
                    mapAttr 
                      (name: toObject (extendPath context' name)) 
                      value.families;
              name            =   value.name;
              version         =   value.version or null;
            };
        "literalDocBook"
        =   context:
            { ... } @ value:
            {
              __type__        =   "LiteralDocBook";
              __toString      =   { text, ... }: text;
              text            =   value.text;
            };
        "literalExpression"
        =   context:
            { ... } @ value:
            {
              __type__        =   "LiteralExpression";
              __toString      =   { text, ... }: text;
              text            =   value.text;
            };
        "literalMD"
        =   context:
            { ... } @ value:
            {
              __type__        =   "LiteralMarkdown";
              __toString      =   { text, ... }: text;
              text            =   value.text;
            };
        "mdDoc"
        =   context:
            { ... } @ value:
            {
              __type__        =   "Markdown";
              __toString      =   { text, ... }: text;
              text            =   value.text;
            };
        "merge"
        =   context:
            { ... } @ value:
            {
              __type__        =   "MergeConfigurations";
              contents        =   values.contents;
            };
        "option"              
        =   context:
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
            } @ option:
            {
              __type__                  =   "Option";
              documentation
              =   if visible
                  then
                  {
                    default
                    =   if defaultText != null
                        then
                          defaultText
                        else
                          toString default;
                    inherit description example relatedPackages;
                    type                =   { inherit(type) description descriptionClass name; };
                  }
                  else
                    null;
              inherit apply default internal readOnly;
              path                      =   context;
              optionType                =   toObject context type;
              source
              =   if option ? description
                  then
                    unsafeGetAttrPos "description" option
                  else if option ? example
                  then
                    unsafeGetAttrPos "example" option
                  else
                    unsafeGetAttrPos (head (attrNames option)) option;
            };
        "option-type"         
        =   path:
            {
              check,                        # T -> bool
              deprecationMessage,           # string?
              description,                  # string
              descriptionClass,             # string?
              emptyValue,                   # {} | { value: T; }
              functor,                      # { name: string, type: OptionType?, wrappend: any, payload: any, binOp: T -> T -> T },
            # getSubOptions,                # T -> { string -> U }
            # getSubModules,                # [ LegacyModule ]?
            # merge,                        # [ string ] -> [ { file: path; value: T; } ] -> { string -> T }
              name,                         # string
              nestedTypes,                  # { elemType: OptionType } | { freeformType: OptionType } | { left: OptionType, right: OptionType } | { coercedType: OptionType, finalType: OptionType }
            # substSubModules,              # T -> U
            # typeMerge,                    # T -> T -> T
              ...
            }:
              let
                inherit(functor) payload;

                applyFn
                =   { check, name, ... }:
                    self:
                    (
                      args:
                        let
                          result        =   self args;
                        in
                          if check result
                          then
                            result
                          else
                            throw "Function application did not result in return-value of type `${name}`."
                    );

                documentation
                =   {
                      inherit name description descriptionClass;
                    };

                empty                   =   emptyValue != {};

                inner                   
                =   mapAttrs 
                      (name: toObject (extendPath path name)) 
                      nestedTypes;

                name'
                =   let
                      variant           =   match "([^ ]*) (.*)" name;
                    in
                      if variant != null
                      then
                      {
                        name            =   elemAt 0 variant;
                        variant         =   elemAt 1 variant;
                      }
                      else
                      {
                        inherit name variant;
                      };

                new
                =   {
                      check,
                      documentation ? documentation,
                      merge,
                      ...
                    }:
                    {
                      inherit check documentation;
                    };

                pattern
                =   let
                      len               =   stringLength description - 28;
                    in
                      substring 28 len description;

                range
                =   let
                      parts             =   split "(.+between | and | [(].+)" description;
                      from              =   elemAt parts 2;
                      till              =   elemAt parts 4;
                    in
                      {
                        from            =   fromJSON from;
                        till            =   fromJSON till;
                      };

                variants
                =   {
                      anything          =   new {                         check = checks.isAny;                           merge = merge.anything;             };
                      attrs             =   new {                         check = checks.isSet;                           merge = merge.sets;                 };
                      attrsOf           =   new {                         check = checks.isSetOf inner;                   merge = merge.sets;                 };
                      bool              =   new {                         check = checks.isBool;                          merge = merge.equal;                };
                      deferredModule    =   new {                         check = checks.isNever;                         merge = merge.never;                };
                      either            =   new {                         check = checks.isEitherOr either;               merge = merge.eitherOr inner;       };
                      enum              =   new {                         check = checks.isInList payload;                merge = merge.equal;                };
                      float             =   new {                         check = checks.isFloat;                         merge = merge.equal;                };
                      functionTo        =   new { apply = applyFn inner;  check = checks.isFunction;                      merge = merge.functions inner;      };
                      int               =   new {                         check = checks.isInteger;                       merge = merge.equal;                };
                      intBetween        =   new {                         check = checks.isIntegerBetween range;          inherit(variants.int) merge;        };
                      lazyAttrsOf       =   new {                         check = checks.isSetOf inner;                   merge = merge.sets;                 };
                      listOf            =   new {                         check = checks.isListOf empty inner;            merge = merge.lists;                };
                      nonEmptyStr       =   new {                         check = checks.isNonEmptyString;                inherit(variants.str) merge;        };
                      nullOr            =   new {                         check = checks.isNullOr inner;                  merge = merge.nullOr inner;         };
                      numberBetween     =   new {                         check = checks.isNumberBetween range;           merge = merge.equal;                };
                      numberNonnegative =   new {                         check = checks.isNonNegativeNumber;             merge = merge.equal;                };
                      numberPositive    =   new {                         check = checks.isPositiveNumber;                merge = merge.equal;                };
                      optionType        =   new {                         check = checks.isOptionType;                    merge = merge.null;                 };
                      package           =   new {                         check = checks.isPackage;                       merge = merge.never;                };
                      passwdEntry       =   new {                         inherit check;                                  merge = merge.never;                };
                      path              =   new {                         check = checks.isPath;                          merge = merge.equal;                };
                      positiveInt       =   new {                         check = checks.isPositiveInteger;               inherit(variants.int) merge;        };
                      raw               =   new {                         check = checks.isAny;                           merge = merge.never;                };
                      separatedString   =   new {                         check = checks.isString;                        merge = merge.stringsWith payload;  };
                      signedInt8        =   new {                         check = checks.isSignedByte;                    inherit(variants.int) merge;        };
                      signedInt16       =   new {                         check = checks.isSignedWord;                    inherit(variants.int) merge;        };
                      signedInt32       =   new {                         check = checks.isSignedLong;                    inherit(variants.int) merge;        };
                      singleLineStr     =   new {                         check = checks.isStringMatching "[^\n\r]*\n?";  merge = merge.line;                 };
                      str               =   new {                         check = checks.isString;                        merge = merge.equal;                };
                      string            =   new {                         check = checks.isString;                        merge = merge.stringsWith "";       };
                      strMatching       =   new {                         check = checks.isStringMatching pattern;        inherit(variants.str) merge;        };
                      submodule         =   new {                         check = checks.isNever;                         merge = merge.never;                };
                      uniq              =   new {                         inherit(inner) check;                           merge = merge.never;                };
                      unique            =   new {                         inherit(inner) check;                           merge = merge.never;                };
                      unsignedInt       =   new {                         check = checks.isUnsignedInteger;               inherit(variants.int) merge;        };
                      unsignedInt8      =   new {                         check = checks.isSignedByte;                    inherit(variants.int) merge;        };
                      unsignedInt16     =   new {                         check = checks.isSignedWord;                    inherit(variants.int) merge;        };
                      unsignedInt32     =   new {                         check = checks.isSignedLong;                    inherit(variants.int) merge;        };
                      unspecified       =   new {                         check = checks.isAny;                           merge = merge.default;              };
                    };
              in
                {
                  __type__              =   "OptionType";
                }
                //  (
                      variants.${name'.name}
                      or  (
                            throw
                              "Type-Conversion of legacy option-type `${name}` not implemented yet!."
                          );
                    );
        "order"
        =   context:
            { ... } @ value:
            {
              __type__        =   "ConfigurationOrder";
              content         =   value.content;
              priority        =   value.priority;
            };
        "override"
        =   context:
            { ... } @ value:
            {
              __type__        =   "ConfigurationOverride";
              content         =   value.content;
              priority        =   value.priority;
            };
        "param"
        =   context:
            { ... } @ value:
            {
              __type__        =   "ConfigurationParameter";
              option          =   toObject (extendPath context "option") values.option;
              render          =   value.render;
            };
        "significant-byte"
        =   context:
            { ... } @ value:
            {
              __type__        =   "Endianess";
              __toString      =   { name, ... }: name;
              name            =   value.name;
            };
        "system"
        =   context:
            { ... } @ value:
            {
              __type__        =   "System";
              abi             =   toObject (extendPath context "abi")     values.abi;
              cpu             =   toObject (extendPath context "cpu")     values.cpu;
              kernel          =   toObject (extendPath context "kernel")  values.kernel;
              vendor          =   toObject (extendPath context "vendor")  values.vendor;
            };
        "vendor"
        =   context:
            { ... } @ value:
            {
              __type__        =   "Vendor";
              __toString      =   { name, ... }: name;
              name            =   value.name;
            };
      };

  functionToObject
  =   context:
      value:
      { 
        __type__                        =   "Function";  
        __functor                       
        =   { value, ... }:
            argument:
              toObject context (value argument);
        inherit value;  
      };

  listToObject
  =   context:
      value:
      {
        __type__                  =   "List";
        __functor
        =   { value, ... }:
            index:
              let
                type              =   typeOf index;
                max               =   length value;
              in
                if type == "int"
                then
                  if index >= 0 && index < max
                  then
                    elemAt index value
                  else
                    throw "Index ${toString index} out of bounds (0–${toString max})!"
                else
                  throw "Integer as index expected, got `${type}`!";
        __toString
        =   { value, ... }:
              let
                value'
                =   map
                    (
                      { __type__, ... } @ value:
                        if value ? __toString
                        then
                          "${value}"
                        else
                          throw "Cannot coerce object of type `${__type__}` to string!"
                    )
                    value;
              in
                "[ ${concatStringsSep ", " value'} ]";
        value
        =   genList
              (
                index:
                  toObject
                    "${context}[${toString index}]"
                    (elemAt index value)
              )
              (length value);
      };

  setToObject
  =   context:
      {
        __type__    ? null,
        _type       ? null,
        type        ? null,
        ...
      } @ value:
        if __type__
        then
          value
        else if _type != null
        then
          let
            convert           
            =   convertLegacy.${_type} 
            or  (throw "No wrapper for type `${type}` implemented.");
          in
            convert context value
        else if type == "derivation"
        then
          value
          //  {
                __type__          =   "Derivation";
                __toString        =   { outPath, ... }: "<Derivation ${outPath}>";
              }
        else
        {
          __type__                =   "Dictionary";
          __functor               
          =   { value, ... }:
              name:
                let
                  name'           =   toObject null name;
                  key             =   "${name'}";
                in
                  if name' ? __toString
                  then
                    value.${key} or (throw "Missing field `${key}` in dictionary.")
                  else
                    throw "Cannot coerce key to string.";
          __toString              =   dictionaryToString;
          value                   
          =   mapAttrs 
                (name: toObject "${context}[\"${name}\"]") 
                value;
        };

  toObject
  =   context:
      value:
        {
          bool                    =   { __type__ = "Bool";      inherit value;  __toString  = coerceToString.bool;    };
          float                   =   { __type__ = "Float";     inherit value;  __toString  = coerceToString.default; };
          int                     =   { __type__ = "Integer";   inherit value;  __toString  = coerceToString.default; };
          lambda                  =   functionToObject  context value;
          list                    =   listToObject      context value;
          null                    =   { __type__ = "Null";                      __toString  = _: "null";              };
          path                    =   { __type__ = "Path";      inherit value;  __toString  = coerceToString.default; };
          set                     =   setToObject       context value;
          string                  =   { __type__ = "String";    inherit value;  __toString  = coerceToString.string;  };
        }.${typeOf value};
in
  toObject
