{ core, ... } @ libs:
  let
    inherit(core) check library target;
    lib                                 =   library.load  ./lib    libs;
    tests                               =   check.load    ./tests  libs lib;
  in
  {
    inherit lib tests;

    checks
    =   check tests
        {
          targetSystem                  =   target.System.all.x86_64-linux;
        };
  }