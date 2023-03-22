{ core, ... } @ libs:
  let
    inherit(core) library;
    libs'
    =   libs
    //  {
          inherit bibliography;
        };

    bibliography                        =   library.import ./definition.nix libs';
    toBibTeX                            =   library.import ./biblatex.nix   libs';
    prepare                             =   library.import ./prepare.nix    libs';
    evaluate                            =   library.import ./evaluate.nix   libs';
  in
  {
    inherit bibliography;
    inherit prepare evaluate toBibTeX;
  }