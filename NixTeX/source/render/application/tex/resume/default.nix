{ core, ... } @ libs:
{ language, style, title, ... } @ resume:
  let
    inherit(core) indentation library;
    config                              =   { inherit language; } // (style.config or {});
    style'                              =   (library.import ./styles libs).${style.name or style} config;
  in
    [
      "\\cleardoublepage"
      "\\phantomsection"
      "\\addsectiontocentry{}{${title}}"
    ]
    ++  style' resume
