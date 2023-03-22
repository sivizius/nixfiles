{ core, ... } @ libs:
  let
    inherit(core) library;
  in
  {
    acronyms                              =   library.import ./acronyms   libs;
    people                                =   library.import ./people.nix libs;
  }