{ core, store, ... } @ libs:
  let
    inherit(core) check library path target;
    lib                                 =   library.load  ./lib     libs;
    module                              =   path.import   ./module  libs;
    tests                               =   check.load    ./tests   libs lib;
  in
  {
    inherit lib tests;

    checks
    =   check tests
        {
          inherit store;
          targetSystem                  =   target.System.all.x86_64-linux;
        };

    nixosModules
    =   {
          default                       =   module;
          vault                         =   module;
        };
  }