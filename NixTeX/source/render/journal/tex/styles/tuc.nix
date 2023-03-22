{ core, journal, vanilla, ... }:
let
  inherit(core)   indentation list string time;
  inherit(journal) formatAuthor;
in
{
  name                                  =   "Chemnitz University of Technology";
  titlePage
  =   { authors, date, journal, place, title, ... }:
      [
        "\\vspace*{-1.2cm}"
        "{" indentation.more
        "\\centering"
        "\\raisebox"
        "  {-1ex}"
        "  {\\includegraphics[scale=1.4]{tuc/assets/green.pdf}}%\\\\[2.22em]%"
        "\\\\[-2.15\\normalbaselineskip]{\\tikz\\node [opacity=0.0,text width=10cm,align=center]%"
        "  {\\Large TECHNISCHE UNIVERSITÄT\\\\[.07\\normalbaselineskip]CHEMNITZ};}%"
        "\\\\[-0.43\\normalbaselineskip+2.22em]%"
        "\\hrulefill\\hspace{0pt}\\\\[2.84em]"
        "{\\Large ${journal.organisation.department}}\\hspace{0pt}\\\\[0.50em]"
        "{${journal.organisation.group}}\\hspace{0pt}\\\\[3.00em]"
        "{\\Huge ${title}}\\hspace{0pt}\\\\[2.00em]"
        "{\\large ${journal.title}}\\hspace{0pt}\\\\[1.00em]"
        "{${string.concatCSV ( list.map formatAuthor authors )}}\\hspace{0pt}\\\\[1.00em]"
        "{\\scriptsize ${place}, ${time.formatDate date.from "deu"} bis ${time.formatDate date.till "deu"}}"
         indentation.less "}"
         "\\clearpage"
       ];
}
