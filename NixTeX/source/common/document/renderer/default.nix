{ core, ... } @ libs:
  let
    inherit(core) library;
  in
  {
    LaTeX                                 =   library.import ./LaTeX.nix    libs;
    Markdown                              =   library.import ./Markdown.nix libs;
  }