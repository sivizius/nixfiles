{ core, journal, ... }:
let
  inherit(core)     indentation list string;
  inherit(journal)  formatAuthor;
in
  { authors, title, journal, ... }:
  beginDocument:
  [
    "\\hypersetup{" indentation.more
      "pdfauthor={${string.concatCSV (list.map formatAuthor authors)}},"
      "pdftitle={${title}},"
      "pdfsubject={${journal.title}},"
      "pdfkeywords={},"
      "pdfproducer={},"
      "pdfcreator={},"
    indentation.less "}"
    "\\tolerance 500%"
    "\\emergencystretch 3em%"
    "\\hfuzz=2pt%"
    "\\vfuzz=2pt%"
    "\\hyphenchar\\font=-1%"
  ] ++ beginDocument
