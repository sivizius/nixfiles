{
  description                           =   "Core library of general-purpose expressions worth implementing as intrinsics";
  inputs
  =   {
        libintrinsics.url               =   "github:sivizius/nixfiles/development?dir=libs/intrinsics";
      };
  outputs
  =   { self, libintrinsics, ... }:
        let
          intrinsics                    =   libintrinsics.lib;

          adjustArguments
          =   { arguments, fileName, moduleName, source, ... }:
                intrinsics.mapAttrs
                (
                  moduleName:
                  module:
                    let
                      initialisationData'
                      =   {
                            inherit fileName moduleName;
                            source
                            =   source
                                {
                                  inherit fileName;
                                  attribute
                                  =   if moduleName != null
                                      then
                                        moduleName
                                      else
                                        intrinsics.baseNameOf fileName;
                                };
                          };
                    in
                    if module.__type__ or null == "NeedInitialisation"
                    then
                      module.initialise module.body initialisationData'
                    else
                      module
                )
                arguments;

          minimal
          =   intrinsics.scopedImport
                { inherit Library; }
                ./lib
                { inherit intrinsics; };

          Library
          =   {
                __functor
                =   { ... }:
                    libraryName:
                    { ... } @ environment:
                    { ... } @ modules:
                      let
                        arguments
                        =   library
                        //  environment;
                        library
                        =   intrinsics.mapAttrs
                            (
                              moduleName:
                              fileName:
                                intrinsics.import fileName
                                  (adjustArguments { inherit arguments fileName moduleName source; })
                            )
                            modules;
                        source          =   library.context libraryName;
                      in
                        library;
              };

          env                           =   { inherit intrinsics; };
          lib                           =   minimal.library.load ./lib env;
          tests                         =   lib.check.load ./tests env lib;
        in
        {
          inherit lib tests;
          checks                        =   lib.check tests {};
        };
}