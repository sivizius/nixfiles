{ core, document, helpers, ... }:
{ ... }:
  let
    inherit(core) indentation list;
    inherit(document) Multilingual;
    inherit(helpers) formatSection;
  in
    publications:
      formatSection
      (
        Multilingual
        {
          deu                         =   "Publikationen";
          eng                         =   "Publicationen";
        }
      )
      (
        [ "\\vspace{-1em}%" ]
        ++  (list.map ({ name, ... }: "\\nocite{${name}}%") publications)
        ++  [
              "\\begin{refcontext}[sorting=ydnt]%" indentation.more
              "\\printbibliography[heading=none,category=ResumePublications]%"
              indentation.less "\\end{refcontext}%"
            ]
      )
