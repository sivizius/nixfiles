{ core, ... }:
let
  inherit(core) indentation list string;
in
  { enclosures, language, ... }:
    let
      title
      =   {
            deu                         =   "Anlagen";
            eng                         =   "Enclosures";
          }.${language};
    in
      list.ifOrEmpty' (enclosures != null)
      (
        [
          "\\cleardoublepage%"
          "\\markboth{}{}%"
          "\\markleft{${title}}%"
          "\\thispagestyle{empty}%"
          "\\phantomsection%"
          "\\addsectiontocentry{}{${title}}%"
          "\\begin{center}" indentation.more
          "\\mbox{}%"
          "\\vfill"
          "{\\Huge \\textbf{${title}}}"
          "\\vfill"
          "\\begin{itemize}" indentation.more
        ]
        ++  (
              list.map
                (
                  { title, ... }:
                    "\\item ${title}"
                )
                enclosures
            )
        ++  [
              indentation.less "\\end{itemize}"
              indentation.less "\\end{center}"
            ]
        ++  (
              list.concatMap
                (
                  { content, title, ... }:
                    [ "\\clearpage\\markleft{${title}}%" ]
                    ++  (
                          list.map
                            (
                              file:
                                "\\includegraphics[width=\\textwidth]{\\source/${string file}}\\clearpage%"
                            )
                            content
                        )
                )
                enclosures
            )
      )
