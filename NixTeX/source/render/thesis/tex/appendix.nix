{ context, core, ... }:
  let
    inherit(core) indentation;
  in
    { configuration, ... }:
    appendix:
    (
      [
        "\\addtocontents{toc}{\\protect\\setcounter{tocdepth}{\\sectiontocdepth}}"
        "\\appendix{" indentation.more
        "\\setcounter{secnumdepth}{5}"
        "\\renewcommand*\\thesubsection{\\thechapter.\\arabic{ctrAppendix}}"
        "\\renewcommand*\\thesubsubsection{\\thechapter.\\arabic{ctrAppendix}}"
      ]
      ++  (
            if configuration.concise or false
            then
              []
            else
              [
                "\\newpage"
                "\\thispagestyle{empty}"
                "~"
                "\\cleardoublepage"
              ]
          )
      ++  [
            "\\phantomsection"
            "\\addxcontentsline{toc}{chapter}{Anhang}"
            "\\renewcommand*\\addchaptertocentry[2]{\\addtocentrydefault{section}{#1}{#2}}"
            "\\renewcommand*\\addsectiontocentry[2]{\\addtocentrydefault{subsection}{#1}{#2}}"
            "\\renewcommand*\\addsubsectiontocentry[2]{\\addtocentrydefault{subsection}{#1}{#2}}"
            "\\renewcommand*\\addsubsubsectiontocentry[2]{\\addtocentrydefault{subsection}{#1}{#2}}"
            "\\chapter{Literaturverzeichnis}"
            "\\printbibliography[heading=none]"
          ]
      ++  appendix
      ++  [ "\\clearpage" ]
      ++  (
            if configuration.concise or false
            then
              []
            else
              [ "\\thispagestyle{empty}" ]
          )
      ++  [ indentation.less "}" ]
    )
