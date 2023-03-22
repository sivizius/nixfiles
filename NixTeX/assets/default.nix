{ core, ... } @ libs:
  let
    inherit(core) library;
  in
  {
    acronyms                            =   library.import ./acronyms       libs;
    hazardous                           =   library.import ./hazardous.nix  libs;
    people                              =   library.import ./people         libs;
  }