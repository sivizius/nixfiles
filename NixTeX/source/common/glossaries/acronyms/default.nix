{ core, ... } @ libs:
let
  inherit(core) library;
in
  (library.import ./definition.nix libs)
  //  {
        prepare                         =   library.import ./prepare.nix  libs;
        toLua                           =   library.import ./lua.nix      libs;
      }