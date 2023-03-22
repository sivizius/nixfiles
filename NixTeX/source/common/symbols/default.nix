{ core, fork-awesome, ... }:
  let
    inherit(core) set;

    fromFontAwesome
    =   {
          Regular                       =   codePoint: "\\textFontAwesome{\\upshape^^^^${codePoint}}";
          Solid                         =   codePoint: "\\textFontAwesome{\\itshape^^^^${codePoint}}";
          Brands                        =   codePoint: "\\textFontAwesome{\\scshape^^^^${codePoint}}";
        };
    fromForkAwesome                     =   codePoint: "\\textForkAwesome{^^^^${codePoint}}";

    forkAwesome                         =   fork-awesome.packages.x86_64-linux.default.icons;
  in
  {
    inherit fromFontAwesome fromForkAwesome;
    forkAwesome                         =   set.mapValues fromForkAwesome forkAwesome;
  }
