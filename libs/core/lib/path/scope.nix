{ debug, intrinsics, list, set, string, ... } @ libs:
fileName:
  set.map
  (
    key:
    value:
      if list.isInstanceOf value
      then
        debug.warn [ fileName key ]
          "Use <libcore>.${string.concatWith "." value} instead!"
          (
            list.fold
              (libs: name: libs.${name})
              libs
              value
          )
      else
        value
  )
  {
    __add
    =   x:
        y:
          debug.trace [ fileName "(+)" ]
          {
            text                        =   "Add";
            data                        =   { inherit x y; };
          }
          (intrinsics.add x y);
    __addErrorContext                   =   [ "expression" "addErrorContext" ];
    __all                               =   [ "list" "all" ];
    __any                               =   [ "list" "any" ];
    __appendContext                     =   [ "string" "appendContext" ];
    __attrNames                         =   [ "set" "names" ];
    __attrValues                        =   [ "set" "values" ];
    __bitAnd                            =   [ "integer" "and" ];
    __bitOr                             =   [ "integer" "or" ];
    __bitXor                            =   [ "integer" "xor" ];
    __catAttrs                          =   [ "set" "collect" ];
    __ceil                              =   [ "number" "ceil" ];
    __compareVersions                   =   [ "version" "compare" ];
    __concatLists                       =   [ "list" "concat" ];
    __concatMap                         =   [ "list" "concatMap" ];
    __concatStringsSep                  =   [ "string" "concatWith" ];
    __currentSystem                     =   debug.error [ fileName "__currentSystem" ] "Unavailable in flake!" null;
    __currentTime                       =   debug.error [ fileName "__currentTime" ] "Unavailable in flake!" null;
    __deepSeq                           =   [ "expression" "deepSeq" ];
    __div
    =   x:
        y:
          debug.trace [ fileName "(/)" ]
          {
            text                        =   "Divide";
            data                        =   { inherit x y; };
          }
          (intrinsics.div x y);
    __elem                              =   [ "list" "find" ];
    __elemAt                            =   [ "list" "get" ];
    __fetchurl                          =   [ "path" "fetchURL" ];
    __filter                            =   [ "list" "filter" ];
    __filterSource                      =   [ "path" "filterSource" ];
    __findFile                          =   [ "path" "find" ];
    __floor                             =   [ "number" "floor" ];
    __foldl'                            =   [ "list" "fold" ];
    __fromJSON                          =   [ "expression" "fromJSON" ];
    __functionArgs                      =   [ "lambda" "arguments" ];
    __genList                           =   [ "list" "generate" ];
    __genericClosure                    =   [ "list" "genericClosure" ];
    __getAttr                           =   [ "set" "get" ];
    __getContext                        =   [ "string" "getContext" ];
    __getEnv                            =   [ "environment" "get" ];
    __getFlake                          =   [ "flake" "get" ];
    __groupBy                           =   [ "list" "groupBy" ];
    __hasAttr                           =   [ "set" "hasAttribute" ];
    __hasContext                        =   [ "string" "hasContext" ];
    __hashFile                          =   [ "path" "hash" ];
    __hashString                        =   [ "string" "hash" ];
    __head                              =   [ "list" "head" ];
    __intersectAttrs                    =   [ "set" "intersect" ];
    __isAttrs                           =   [ "set" "isInstanceOf" ];
    __isBool                            =   [ "bool" "isInstanceOf" ];
    __isFloat                           =   [ "float" "isInstanceOf" ];
    __isFunction                        =   [ "lambda" "isInstanceOf" ];
    __isInt                             =   [ "integer" "isInstanceOf" ];
    __isList                            =   [ "list" "isInstanceOf" ];
    __isPath                            =   [ "path" "isInstanceOf" ];
    __isString                          =   [ "string" "isInstanceOf" ];
    __langVersion                       =   [ "version" "language" ];
    __length                            =   [ "list" "length" ];
    __lessThan
    =   x:
        y:
          debug.trace [ fileName "(<)" ]
          {
            text                        =   "Less Than";
            data                        =   { inherit x y; };
          }
          (intrinsics.lessThan x y);
    __listToAttrs                       =   [ "list" "toSet" ];
    __mapAttrs                          =   [ "set" "map" ];
    __match                             =   [ "string" "match" ];
    __mul
    =   x:
        y:
          debug.trace [ fileName "(*)" ]
          {
            text                        =   "Multiply";
            data                        =   { inherit x y; };
          }
          (intrinsics.mul x y);
    __nixPath                           =   [ "path" "nixPaths" ];
    __nixVersion                        =   [ "version" "nix" ];
    __parseDrvName                      =   [ "derivation" "parseName" ];
    __partition                         =   [ "list" "partition" ];
    __path                              =   [ "path" "path" ];
    __pathExists                        =   [ "path" "exists" ];
    __readDir                           =   [ "path" "readDirectory" ];
    __readFile                          =   [ "path" "readFile" ];
    __replaceStrings                    =   [ "string" "replace" ];
    __seq                               =   [ "expression" "seq" ];
    __sort                              =   [ "list" "sort" ];
    __split                             =   [ "string" "split" ];
    __splitVersion                      =   [ "version" "split" ];
    __storeDir                          =   [ "path" "storeDirectory" ];
    __storePath                         =   [ "path" "storePath" ];
    __stringLength                      =   [ "string" "length" ];
    __sub
    =   x:
        y:
          debug.trace [ fileName "(-)" ]
          {
            text                        =   "Subtract";
            data                        =   { inherit x y; };
          }
          (intrinsics.sub x y);
    __substring                         =   [ "string" "slice" ];
    __tail                              =   [ "list" "tail" ];
    __toFile                            =   [ "path" "toFile" ];
    __toJSON                            =   [ "expression" "toJSON" ];
    __toPath                            =   debug.warn [ fileName "__toPath" ] "Deprecated, use `/. + \"/absolute/path\"`!" (x: /. + x);
    __toXML                             =   [ "expression" "toXML" ];
    __trace                             =   debug.warn [ fileName "__trace" ] "Use printers of <libcore>.debug instead!" intrinsics.trace;
    __tryEval                           =   [ "expression" "tryEval" ];
    __typeOf                            =   [ "type" "getPrimitive" ];
    __unsafeDiscardOutputDependency     =   [ "string" "discardOutputDependency" ];
    __unsafeDiscardStringContext        =   [ "string" "discardContext" ];
    __unsafeGetAttrPos                  =   [ "set" "getKeySource" ];
    __zipAttrsWith                      =   [ "set" "zip" ];
    abort                               =   [ "error" "abort" ];
    baseNameOf                          =   [ "path" "getBaseName" ];
    builtins                            =   debug.warn [ fileName "builtins" ] "Use <intrinsics> instead!" intrinsics;
    derivation                          =   [ "derivation" ];
    derivationStrict                    =   [ "derivation" "fromStrict" ];
    dirOf                               =   [ "path" "getDirectory" ];
    fetchGit                            =   [ "path" "fetchGit" ];
    fetchMercurial                      =   [ "path" "fetchMercurial" ];
    fetchTarball                        =   [ "path" "fetchTarball" ];
    fetchTree                           =   [ "path" "fetchTree" ];
    fromTOML                            =   [ "expression" "fromTOML" ];
    import                              =   [ "path" "import" ];
    isNull                              =   debug.warn [ fileName "isNull" ] "Deprecated, use `x == null`!" (x: x == null);
    map                                 =   [ "list" "map" ];
    placeholder                         =   [ "path" "getPlaceholder" ];
    removeAttrs                         =   [ "set" "remove" ];
    scopedImport                        =   [ "path" "importScoped" ];
    throw                               =   [ "error" "throw" ];
    toString                            =   [ "string" "toString" ];
  }