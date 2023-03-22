{ context, debug, path, set, type, ... }:
  let
    adjustArguments
    =   { arguments, fileName, moduleName ? null, ... }:
          let
            source
            =   arguments.source
                {
                  inherit fileName;
                  attribute
                  =   if moduleName != null
                      then
                        moduleName
                      else
                        path.getBaseName fileName;
                };
          in
            (initialise arguments { inherit fileName moduleName source; })
            //  { inherit source; };

    initialise
    =   { ... } @ self:
        { ... } @ initialisationData:
        (
          set.map
          (
            name:
            module:
              if      NeedInitialisation.isInstanceOf module
              then
                debug.debug "initialise"
                {
                  text                  =   "Initialise module ${name}:";
                  data                  =   initialisationData;
                  when                  =   name != "debug";
                }
                module.initialise module.body
                (
                  initialisationData // { inherit name; }
                )
              else if Library.isInstanceOf            module
              then
                debug.debug "initialise"
                {
                  text                  =   "Initialise library ${name}:";
                  data                  =   initialisationData;
                }
                initialise module
                (
                  initialisationData // { inherit name; }
                )
              else
                module
          )
          self
        ) // { isInitialised = true; };

    Library
    =   type "Library"
        {
          inherit adjustArguments initialise;

          from
          =   libraryName:
              { ... } @ environment:
              { ... } @ modules:
                let
                  __functor
                  =   this:
                      { self, ... } @ initialisationData:
                        initialise this
                        (
                          environment
                          //  initialisationData
                          //  {
                                source  =   context self.outPath;
                              }
                        );
                  arguments
                  =   library
                  //  environment
                  //  {
                        source          =   context libraryName;
                      };
                  library
                  =   (
                        set.map
                        (
                          moduleName:
                          fileName:
                            path.import fileName
                              (adjustArguments { inherit arguments fileName moduleName; })
                        )
                        modules
                      )
                  //  {
                        inherit __functor;
                        isInitialised   =   false;
                      };
                in
                  Library.instanciateAs libraryName library;

          import
          =   fileName:
              arguments:
                path.import fileName
                  (adjustArguments { inherit arguments fileName; });

          load
          =   fileName:
                path.importScoped { inherit Library; } fileName;
        };

    NeedInitialisation
    =   type "NeedInitialisation"
        {
          from
          =   initialise:
              body:
                NeedInitialisation.instanciate
                {
                  inherit body initialise;
                  __functor
                  =   { initialise, body, ... }:
                        initialise body;
                };
        };
  in
    Library
    //  {
          inherit Library NeedInitialisation;
        }
