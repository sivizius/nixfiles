{ core, ... } @ libs:
  let
    inherit(core) check library;
    lib                                 =   library.load  ./lib    libs;
    tests                               =   check.load    ./tests  libs lib;
  in
  {
    inherit lib tests;
    checks                              =   check tests {};
  }
