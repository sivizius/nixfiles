{ context, core, ... }:
  let
    inherit(core) indentation;
  in
    { ... }:
    mainmatter:
    (
      [
        "{" indentation.more
        "\\cleardoublepage"
        "\\renewcommand*\\chapterpagestyle{scrheadings}"
        "\\pagestyle{scrheadings}"
        "\\pagenumbering{arabic}"
      ]
      ++  mainmatter
      ++  [ indentation.less "}" ]
    )
