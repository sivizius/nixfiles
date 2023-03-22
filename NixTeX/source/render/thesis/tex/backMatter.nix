{ context, core, thesis, ... }:
  let
    inherit(core) indentation;
  in
    { configuration, ... }:
    backmatter:
    (
      [
        "{" indentation.more
      ]
      ++  [
            "\\renewcommand*\\chapterpagestyle{empty}"
            "\\pagestyle{empty}"
            "\\renewcommand*\\thechapter{}"
            "\\renewcommand*\\thesection{}"
            "\\renewcommand*\\thesubsection{}"
            "\\renewcommand*\\thesubsubsection{}"
          ]
      ++  (
            if configuration.concise or false
            then
              [ ]
            else
              [ "\\newpage\\unrotatePages\\thispagestyle{empty}\\mbox{}" ]
          )
      ++  backmatter
      ++  [ indentation.less "}" ]
    )
