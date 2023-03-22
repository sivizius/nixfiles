{ core, ... }:
  let
    inherit(core) context debug path set string type;

    loadSet
    =   config:
        environment:
        scope:
          let
            config'
            =   type.matchPrimitiveOrPanic config
                {
                  lambda                =   config;
                  path                  =   importScoped config;
                  set                   =   config;
                  string                =   importScoped config;
                };
            importScoped                =   path.importScoped scope;
          in
            type.matchPrimitiveOrPanic config'
            {
              lambda                    =   config' environment;
              set                       =   config';
            };

    loadWithSource
    =   config:
        { ... } @ environment:
        { ... } @ scope:
        objectType:
          let
            loadSet'
            =   config:
                  loadSet
                    config
                    environment
                    scope;
            loadWithSource'
            =   source:
                name:
                config:
                  let
                    config'             =   loadSet' config;
                    fileName
                    =   type.matchPrimitiveOrPanic config
                        {
                          lambda        =   null;
                          path          =   config;
                          set           =   null;
                          string        =   config;
                        };
                    source'
                    =   source
                        {
                          attribute =   name;
                          inherit fileName;
                        };
                  in
                    if type.getType config' != null
                    then
                      { source = source'; }
                      //  (objectType.expect config')
                      //  { inherit name; }
                    else
                      debug.debug "loadWithSource'"
                      {
                        text            =   name;
                        data            =   set.names config';
                      }
                      set.map
                        (loadWithSource' source')
                        config';
          in
            debug.debug "loadWithSource"
            {
              text                      =   "Called with:";
              data                      =   { inherit config environment scope; };
              nice                      =   true;
              when = false;
            }
            loadWithSource'
              ( context "Peers" )
              null
              config;
  in
    loadWithSource
