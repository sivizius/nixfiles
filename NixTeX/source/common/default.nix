{ core, ... } @ libs:
let
  inherit (core.library) Library;
in
  Library "common"
    libs
    {
      bibliography                      =   ./bibliography;
      chemistry                         =   ./chemistry;
      document                          =   ./document;
      fonts                             =   ./fonts;
      glossaries                        =   ./glossaries;
      letters                           =   ./letters;
      phonenumbers                      =   ./phonenumbers;
      physical                          =   ./physical;
      symbols                           =   ./symbols;
      urls                              =   ./urls;
    }
