{ core, ... } @ libs:
  let
    inherit(core) path;

    libs'
    =   libs
    //  {
          helpers                       =   path.import ./helpers.nix libs';
        };
  in
  {
    awesome                             =   path.import ./awesome libs';
  }
