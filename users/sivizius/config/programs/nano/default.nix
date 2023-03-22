{ registries, ... }:
{
  environment
  =   {
        shellAliases.n                  =   "${registries.nix.nano}/bin/nano";
      };
  programs.nano
  =   {
        enable                          =   true;
        atBlanks                        =   true;
        autoIndentation                 =   true;
        backup                          =   true;
        backupDirectory                 =   "~/.cache/nano/backups/";
        constantShow                    =   true;
        historyLog                      =   true;
        include
        =   [
              ./fasm.nanorc
              ./purebasic.nanorc
              ./yasic.nanorc
            ];
        lineNumbers                     =   true;
        locking                         =   true;
        matchBrackets                   =   "(<[{»›)>]}«‹";
        multiBuffer                     =   true;
        noHelp                          =   true;
        numberColour                    =   { fg   = "brightyellow"; bg   = "normal"; };
        punctuation                     =   "–;:,.¿?¡!";
        regexSearch                     =   true;
        showCursor                      =   true;
        smartHome                       =   true;
        spellChecker                    =   "aspell -x -c";
        suspendable                     =   true;
        tabulatorSize                   =   2;
        tabulatorToSpaces               =   true;
        whiteSpace                      =   "→·";
        wordBounds                      =   true;
      };
}
