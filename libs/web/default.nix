{ core, ... } @ libs:
  let
    inherit(core) check library path string target;
    lib                                 =   library.load  ./lib    libs;
    module                              =   path.import   ./module  libs;
    tests                               =   check.load    ./tests  libs lib;
  in
  {
    inherit lib tests;
    checks                              =   check tests {};

    nixosModules
    =   {
          default                       =   module;
          web                           =   module;
        };
  }
