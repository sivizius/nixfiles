{ context, core, thesis, ... }:
  let
    inherit(core)   indentation;
    inherit(thesis) cleardoublepage;
  in
    { configuration, state, ... }:
    frontMatter:
      let
        cleardoublepage'                =   cleardoublepage configuration;
      in
      (
        [
          "{%" indentation.more
          "\\cleardoublepage%"
          "\\renewcommand*\\chapterpagestyle{scrheadings}%"
          "\\pagestyle{scrheadings}%"
        ]
        ++  [
              "\\addxcontentsline{toc}{chapter}{Inhaltsverzeichnis}%"
              "\\tableofcontents{%" indentation.more
              "\\directlua{text.elaborate(\"0\")}%"
              "${cleardoublepage'}%"
              "\\addchap{Abkürzungs- und Symbol\\-verzeichnis}{\\directlua{acronyms.printList([[single-line]])}}%"
              "\\afteracronyms%"
            ]
        ++  (
              if  configuration.substances.enable
              &&  configuration.substances.list
              then
                [ "${cleardoublepage'}\\addchap{Substanzverzeichnis}{\\directlua{substances.printList(true)}}" ]
              else
                [ ]
            )
        ++  [
              "\\directlua{text.elaborate(\"2\")}%"
              indentation.less "}"
            ]
        ++  (
              if state.schemes.counter > 0
              then
                [ "${cleardoublepage'}\\listofschemes" ]
              else
                [ ]
            )
        ++  (
              if state.figures.counter > 0
              then
                [ "${cleardoublepage'}\\listoffigures" ]
              else
                [ ]
            )
        ++  (
              if state.tables.counter > 0
              then
                [ "${cleardoublepage'}\\listoftables" ]
              else
                [ ]
            )
        ++  frontMatter
        ++  [ indentation.less "}" ]
      )
