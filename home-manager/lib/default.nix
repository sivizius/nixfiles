{ core, ... } @ libs:
  let
    inherit(core) library;
  in
    library "homemanager"
      libs
      {
        htop                            =   ./htop.nix;
      }
