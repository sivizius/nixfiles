{ core, chemistry, ... }:
let
  inherit(core) indentation;
in
  { resources, ... }:
  appendix:
  (
    [
      "\\addtocontents{toc}{\\protect\\setcounter{tocdepth}{\\sectiontocdepth}}"
      "\\appendix{" indentation.more
      "\\setcounter{secnumdepth}{5}"
      "\\renewcommand*\\thesubsection{\\thechapter.\\arabic{ctrAppendix}}"
      "\\renewcommand*\\thesubsubsection{\\thechapter.\\arabic{ctrAppendix}}"
      "\\phantomsection"
      "\\addxcontentsline{toc}{chapter}{Anhang}"
      "\\renewcommand*\\addchaptertocentry[2]{\\addtocentrydefault{section}{#1}{#2}}"
      "\\renewcommand*\\addsectiontocentry[2]{\\addtocentrydefault{subsection}{#1}{#2}}"
      "\\renewcommand*\\addsubsectiontocentry[2]{\\addtocentrydefault{subsection}{#1}{#2}}"
      "\\renewcommand*\\addsubsubsectiontocentry[2]{\\addtocentrydefault{subsection}{#1}{#2}}"
      "\\chapter{Charakterisierungen}"
      "{" indentation.more
    ]
    ++  ( chemistry.substances.checkNovel resources.substances )
    ++  [
          indentation.less "}"
          "\\chapter{Literaturverzeichnis}"
          "\\printbibliography[heading=none]"
        ]
    ++  appendix
    ++  [ "\\clearpage" indentation.less "}" ]
  )
