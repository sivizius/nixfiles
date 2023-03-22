{ core, intrinsics, ... }:
  let
    inherit (intrinsics) attrNames concatStringsSep;

    Layout
    =   name:
        { ... } @ bindings:
          { inherit name bindings; };

    toXKB
    =   let
          mapKey
          =   key:
              {
                "1"                       =   "AE01";
                "2"                       =   "AE02";
                "3"                       =   "AE03";
                "4"                       =   "AE04";
                "5"                       =   "AE05";
                "6"                       =   "AE06";
                "7"                       =   "AE07";
                "8"                       =   "AE08";
                "9"                       =   "AE09";
                "0"                       =   "AE10";
                "-"                       =   "AE11";
                "="                       =   "AE12";
                "q"                       =   "AD01";
                "w"                       =   "AD02";
                "e"                       =   "AD03";
                "r"                       =   "AD04";
                "t"                       =   "AD05";
                "y"                       =   "AD06";
                "u"                       =   "AD07";
                "i"                       =   "AD08";
                "o"                       =   "AD09";
                "p"                       =   "AD10";
                "["                       =   "AD11";
                "]"                       =   "AD12";
                "a"                       =   "AC01";
                "s"                       =   "AC02";
                "d"                       =   "AC03";
                "f"                       =   "AC04";
                "g"                       =   "AC05";
                "h"                       =   "AC06";
                "j"                       =   "AC07";
                "k"                       =   "AC08";
                "l"                       =   "AC09";
                ";"                       =   "AC10";
                "'"                       =   "AC11";
                "~"                       =   "TLDE";
                "\\"                      =   "BKSL";
                "z"                       =   "AB01";
                "x"                       =   "AB02";
                "c"                       =   "AB03";
                "v"                       =   "AB04";
                "b"                       =   "AB05";
                "n"                       =   "AB06";
                "m"                       =   "AB07";
                ","                       =   "AB08";
                "."                       =   "AB09";
                "/"                       =   "AB10";
                "<"                       =   "LSGT";
              }.${key};
          mapCharacters
          =   map
              (
                char:
                  if isString char
                  then
                    (
                      lib.foldl
                      (
                        result:
                        char:
                          result // { ${char} = char; }
                      )
                      {}
                      [
                        "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"
                        "a" "b" "c" "d" "e" "f" "g" "h" "i" "j"
                        "k" "l" "m" "n" "o" "p" "q" "r" "s" "t"
                        "u" "v" "w" "x" "y" "z"
                      ]
                    )
                    {
                      "!"                 =   "exclam";
                      "¡"                 =   "exclamdown";
                    }.${char}
                  else if char == null  then  "NoSymbol"
                  else if char == Grave then  "grave"
                  else                        null
              );
          toXKB
          =   { ... } @ bindings:
                concatStringsSep "\n"
                (
                  map
                  (
                    key:
                      "  key <${mapKey key}> { [${concatStringsSep ", " (mapCharacters bindings.${key})}] };"
                  )
                  ( attrNames bindings )
                );

        in
          { name, bindings, ... }:
          ''
            default
            xkb_symbols "${name}" {
            ${toXKB bindings}
            };
          '';
  in
    Layout  "de"
    {
      # First
      "~"   =   [ "^"   "°"   "′"   "″"   ];
      "1"   =   [ "1"   "!"   "¹"   "¡"   ];
      "2"   =   [ "2"   "\""  "²"   "⅛"   ];
      "3"   =   [ "3"   "§"   "³"   "£"   ];
      "4"   =   [ "4"   "$"   "¼"   "¤"   ];
      "5"   =   [ "5"   "%"   "½"   "⅜"   ];
      "6"   =   [ "6"   "&"   "¬"   "⅝"   ];
      "7"   =   [ "7"   "/"   "{"   "⅞"   ];
      "8"   =   [ "8"   "("   "["   "™"   ];
      "9"   =   [ "9"   ")"   "]"   "±"   ];
      "0"   =   [ "0"   "="   "}"   "°"   ];
      "-"   =   [ "ß"   "?"   "\\"  "¿"   ];
      "="   =   [ "´"   "`"   "¸"   "˛"   ];
      ""
    }