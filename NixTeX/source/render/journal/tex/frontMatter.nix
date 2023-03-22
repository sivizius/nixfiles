{ core, ... }:
let
  inherit(core)   indentation;
in
  { state, ... }:
  _frontmatter:
  (
    [
      "{" indentation.more
      "\\cleardoublepage"
      "\\renewcommand*\\chapterpagestyle{scrheadings}"
      "\\pagestyle{scrheadings}"
      "\\addxcontentsline{toc}{chapter}{Inhaltsverzeichnis}"
      "\\tableofcontents{" indentation.more
      "\\elaborate[0]"
      "\\clearpage\\addchap{Abkürzungs- und Symbol\\-verzeichnis}{\\printAcronyms}\\afteracronyms"
      "\\clearpage\\listSubstancesByNumber{Substanzverzeichnis}"
      "\\elaborate[2]"
      indentation.less "}"
    ]
    ++  (
          if state.schemes.counter > 0
          then
            [ "\\clearpage\\listofschemes" ]
          else
            [ ]
        )
    ++  (
          if state.figures.counter > 0
          then
            [ "\\clearpage\\listoffigures" ]
          else
            [ ]
        )
    ++  (
          if state.tables.counter > 0
          then
            [ "\\clearpage\\listoftables" ]
          else
            [ ]
        )
    ++  [ indentation.less "}" ]
  )
