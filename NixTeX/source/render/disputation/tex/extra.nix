{ core, ... }:
  let
    inherit(core) debug;
  in
    { ... }:
    extra:
      [
        "\\newcounter{finalframe}%"
        "\\setcounter{finalframe}{\\value{framenumber}}%"
        "\\setcounter{framenumber}{0}%"
        "\\ifx\\finalExtraSlide\\undefined\\xdef\\finalExtraSlide{???}\\fi%"
        "\\renewcommand{\\printslidenumber}[2]{Extra \\arabic{framenumber}/\\finalExtraSlide}%"
      ]
      ++  extra
      ++  [
            "\\makeatletter%"
            "\\immediate\\write\\@auxout{\\string\\xdef\\string\\finalExtraSlide{\\arabic{framenumber}}}%"
            "\\makeatother%"
            "\\setcounter{framenumber}{\\value{finalframe}}%"
          ]
