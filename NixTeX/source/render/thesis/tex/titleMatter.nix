{ context, core, thesis, ... }:
  let
    inherit(core)   indentation list string time;
    inherit(thesis) formatAuthor;
  in
    { authors, date, place, style, thesis, title, ... } @ document:
    titleMatter:
      let
        authorList                      =   string.concatCSV ( list.map formatAuthor authors );
      in
      (
        [
          "{" indentation.more
          "\\cleardoublepage"
          "\\pagenumbering{roman}"
          "\\renewcommand*\\chapterpagestyle{empty}"
          "\\pagestyle{empty}"
          "\\currentpdfbookmark{Titelseite}{titlepage}"
          "\\begin{titlepage}" indentation.more
        ]
        ++  ( style.titlePage document )
        ++  [
              "~\\vfill"
              "\\textbf{${authorList}}\\\\"
              "{\\textit{${title}}}\\\\"
              "${thesis.title}, ${thesis.organisation.department}\\\\"
              "${thesis.organisation.name}, ${time.formatYearMonth date "deu"}"
              "\\cleardoublepage"
            ]
        ++  titleMatter
        ++  [
              indentation.less "\\end{titlepage}"
              indentation.less "}"
            ]
      )
