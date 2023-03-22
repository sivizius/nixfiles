{ lib, fetchFromGitHub, stdenv }:

let
  inherit(builtins) filter foldl' head isString match readFile split;

  version = "8e30d063c283f87043adca087f0897d210dc8717";

  fork-awesome = fetchFromGitHub {
    owner = "sivizius";
    repo = "Fork-Awesome";
    rev = version;
    sha256 = "sha256-50iWohxQ2AhO8oQ9hM5AJRCyes9gXvzSTXMDBTYiDHo=";
  };

  splitLines = text: filter isString (split "\n" text);
  lines = splitLines (readFile "${fork-awesome}/src/icons/icons.yml");

  parsedIcons = foldl' (
      { icons, id, unicode } @ state:
      line:
        let
          nameLine    = match "  - name: +(.*)" line;
          idLine      = match "    id: +(.*)" line;
          unicodeLine = match "    unicode: +(.*)" line;
        in
          if nameLine != null then {
            icons = icons // { ${id} = unicode; };
            id = null;
            unicode = null;
          }
          else if idLine != null then state // { id = head idLine; }
          else if unicodeLine != null then state // { unicode = head unicodeLine; }
          else state
    )
    {
      icons = {};
      id = null;
      unicode = null;
    }
    lines;
in (stdenv.mkDerivation {
  pname = "fork-awesome";
  inherit version;

  src = fork-awesome;

  installPhase = ''
    install -m444 -Dt $out/share/fonts/truetype/fork-awesome ${fork-awesome}/fonts/forkawesome-webfont.ttf

  '';

  meta = let
    inherit(lib) licenses platforms;
  in {
    description = "Fork Awesome Icon Font";
    license = licenses.ofl;
    maintainers = [ ];
    platforms   = platforms.all;
  };
}) // { inherit(parsedIcons) icons; }
