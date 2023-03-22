{ core, thesis, vanilla, ... }:
  let
    inherit(core)   indentation list string time;
    inherit(thesis) formatAuthor formatAuthorTableLine thesisVersion;
  in
  {
    name                                =   "Chemnitz University of Technology";
    inherit(vanilla)  originalityDeclaration;
    titlePage
    =   { authors, date, place, thesis, title, version, ... }:
        [
          "\\vspace*{-1.2cm}"
          "{" indentation.more
          "\\centering"
          "\\raisebox"
          "  {-1ex}"
          "  {\\includegraphics[scale=1.4]{\\source/tuc/assets/green.pdf}}%\\\\[2.22em]%"
          "\\\\[-2.15\\normalbaselineskip]{\\tikz\\node [opacity=0.0,text width=10cm,align=center]%"
          "  {\\Large TECHNISCHE UNIVERSITÄT\\\\[.07\\normalbaselineskip]CHEMNITZ};}%"
          "\\\\[-0.43\\normalbaselineskip+2.22em]%"
          "\\hrulefill\\hspace{0pt}\\\\[2.84em]"
          "{\\Large ${thesis.organisation.department}}\\hspace{0pt}\\\\[0.50em]"
          "{${thesis.organisation.group}}\\hspace{0pt}\\\\[3.00em]"
          "{\\Huge ${title}}\\hspace{0pt}\\\\[2.00em]"
          "{\\large ${thesis.title}}\\hspace{0pt}\\\\[1.00em]"
        ]
        ++  (
              if thesis.degree != null
              then
                let
                  author                =   list.head authors;
                in
                [
                  "{zur Erlangung des akademischen Grades}\\\\[1.00em]"
                  "{${thesis.degree.long}}\\\\"
                  "{(${thesis.degree.short})}"
                  "\\vfill"
                  "\\begin{tabularx}{\\linewidth}{@{}lX@{}}" indentation.more
                  "Vorgelegt von & ${formatAuthor author}\\\\"
                  "Fachsemester & ${string author.studies.semester}\\\\"
                  "Studiengang & ${author.studies.course}\\\\"
                ]
              else
              [
                "{${string.concatCSV ( list.map formatAuthor authors )}}"
                "\\vfill"
                "\\begin{tabularx}{\\linewidth}{@{}lX@{}}" indentation.more
              ]
            )
        ++  [ ( thesis.auditors or { title = ""; } ).title or "Prüfer"    ]
        ++  ( list.map formatAuthorTableLine ( thesis.auditors or { people = []; } ).people )
        ++  [ ( thesis.advisors or { title = ""; } ).title or "Betreuer"  ]
        ++  ( list.map formatAuthorTableLine ( thesis.advisors or { people = []; } ).people )
        ++  [
              "${thesisVersion version} & ${time.formatDate date "deu"} in ${place} \\\\"
              indentation.less "\\end{tabularx}"
              indentation.less "}"
              "\\clearpage"
            ];
  }

  /*
                {
                  \normalsize
                  zur Erlangung des akademischen Grades\\[1em]
                  \@ThesisTypeTitleLong\\
                  (\@ThesisTypeTitleShort)\\[1em]
                  \ifthenelse{\equal{\@ThesisTypeShort}{Dissertation}}
                  {
                    vorgelegt\\[1em]
                    der \@ThesisDepartment\\der Technischen Universität Chemnitz\\[1em]
                    von \@ThesisAuthorATitle\@ThesisAuthorAFirstName\ \@ThesisAuthorALastName\ifnotempty{\@ThesisAuthorANumber}{\ (\@ThesisAuthorANumber)}\\
                    geboren am \@ThesisAuthorABirthDate\ in \@ThesisAuthorABirthPlace
                    \vfill
                    \begin{tabular}{@{}ll@{}}
                      \ifnotempty{\@ThesisAuditorsNames}
                        {
                          \textbf{\@ThesisAuditorsTitle}
                          \directlua
                          {
                            for name in string.gmatch([[\@ThesisAuditorsNames]], "[^,]+")
                            do
                              tex.print("&"..name..tex.newline)
                            end
                          }
                        }
                      \ifnotempty{\@ThesisAdvisorsNames}
                        {
                          \textbf{\@ThesisAdvisorsTitle}
                          \directlua
                          {
                            for name in string.gmatch([[\@ThesisAdvisorsNames]], "[^,]+")
                            do
                              tex.print("&"..name..tex.newline)
                            end
                          }
                        }
                    \end{tabular}
                    \begin{flushleft}
                      \@ThesisPlace, den \@ThesisDate
                    \end{flushleft}
                  }
                  {
                    \vfill
                    \begin{tabularx}{\linewidth}{@{}lX@{}}
                      Vorgelegt von & \@ThesisAuthorATitle\@ThesisAuthorAFirstName\ \@ThesisAuthorALastName\ifnotempty{\@ThesisAuthorAThanks}{\footnotemark}
                                      \ifnotempty{\@ThesisAuthorBFirstName}
                                      {\@ThesisAuthorBTitle\@ThesisAuthorBFirstName\ \@ThesisAuthorBLastName\ifnotempty{\@ThesisAuthorBThanks}{\footnotemark}}
                      \\
                      \ifnotempty{\@ThesisAuthorASemester}  {Fachsemester & \@ThesisAuthorASemester\\}
                      \ifnotempty{\@ThesisAuthorACourse}    {Studiengang  & \@ThesisAuthorACourse\\}
                      \ifnotempty{\@ThesisAuditorsNames}
                        {%
                          \@ThesisAuditorsTitle
                          \directlua
                          {
                            for name in string.gmatch([[\@ThesisAuditorsNames]], "[^,]+")
                            do
                              tex.print("&"..name..tex.newline)
                            end
                          }
                        }
                      \ifnotempty{\@ThesisAdvisorsNames}
                        {%
                          \@ThesisAdvisorsTitle
                          \directlua
                          {
                            for name in string.gmatch([[\@ThesisAdvisorsNames]], "[^,]+")
                            do
                              tex.print("&"..name..tex.newline)
                            end
                          }
                        }
                      \ifthenelse         {\equal{\@ThesisVersion}{final}}
                        {Eingereicht am}
                        {%
                          \ifthenelse     {\equal{\@ThesisVersion}{prelimary}}
                            {Vorläufige Abgabe am}
                            {%
                              \ifthenelse {\equal{\@ThesisVersion}{revised}}
                                {Überarbeitet, Abgegeben am}
                                {\q{\@ThesisVersion}, Abgegeben am}
                            }
                        }
                      & \@ThesisDate\ in \@ThesisPlace \\
                    \end{tabularx}
                  }
                }
  */