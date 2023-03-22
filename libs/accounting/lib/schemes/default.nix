{ core, ... } @ libs:
  let
    inherit(core) library;
  in
  {
    hgb                                 =   library.import ./hgb.nix libs;
  }
