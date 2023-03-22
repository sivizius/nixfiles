{ core, journal, ... }:
  let
    inherit(core)   indentation list string time;
    inherit(journal) formatAuthor;
  in
    { authors, date, journal, place, title, style, ... } @ document:
    _:
    let
      authorList                        =   string.concatCSV ( list.map formatAuthor authors );
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
            "{\\def\\Linebreak{\\newline}\\textit{${title}}}\\\\"
            "${journal.title}, ${journal.organisation.department}\\\\"
            "${journal.organisation.name}, ${time.formatYearMonth date.from "deu"} bis ${time.formatYearMonth date.till "deu"}"
            "\\cleardoublepage"
            indentation.less "\\end{titlepage}"
            indentation.less "}"
          ]
    )
