{ core, nixpkgs, ... } @ libs:
  let
    inherit(core) check library string target;
    lib                                 =   library.load  ./lib    libs;
    tests                               =   check.load    ./tests  libs lib;
  in
  {
    inherit lib tests;

    stdenv
    =   target.System.mapStdenv
        (
          system:
            nixpkgs.legacyPackages.${string system}.stdenv
        );

    checks                              =   check tests {};
  }
