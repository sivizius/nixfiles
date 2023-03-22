{ core, thesis, ... }:
let
  inherit(core)   indentation list string time;
  inherit(thesis) formatAuthor formatAuthorTableLine thesisVersion;
in
{
  name                                  =   "Vanilla";
  titlePage
  =   { authors, date, place, title, ... }:
      [
        "\\centering"
        "{\\Large ${journal.organisation.department}} \\\\"
        "{${journal.organisation.group}} \\\\"
        "{\\Huge ${title}} \\\\"
        "{\\large ${journal.title}} \\\\"
        "{${string.concatCSV ( list.map formatAuthor authors )}} \\\\"
        "{\\scriptsize ${place}, ${time.formatDate date.from "deu"} bis ${time.formatDate date.till "deu"}}"
        "\\clearpage"
      ];
}
