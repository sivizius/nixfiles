{ core, thesis, ... }:
  let
    inherit(core)   indentation list string time;
    inherit(thesis) formatAuthor thesisVersion;
  in
  {
    name                                =   "Vanilla";
    originalityDeclaration
    =   { thesis, title, ... }:
          let
            withTitle                   =   "mit dem Titel \\textit{${title}}";
            followingWork
            =   if thesis.article == "den"
                || thesis.article == "diesen"
                then
                  "vorliegenden"
                else
                  "vorliegende";
          in
            [
              "Ich erkläre,"
              "  dass ich ${thesis.article} ${followingWork} ${thesis.title}"
              "    ${withTitle}"
              "  selbstständig und ohne Benutzung anderer als der angegebenen Quellen und Hilfsmittel angefertigt habe.\\par"
              "Die vorliegende Arbeit ist frei von Plagiaten. Alle Ausführungen, die wörtlich oder inhaltlich aus anderen Schriften entnommen sind,"
              "  habe ich als solche kenntlich gemacht."
              "Diese Arbeit wurde in gleicher oder ähnlicher Form noch nicht als Prüfungsleistung eingereicht und ist auch noch nicht veröffentlicht."
            ];
    titlePage
    =   { authors, date, place, thesis, title, version, ... }:
        [
          "\\centering"
          "{\\Large ${thesis.organisation.department}} \\\\"
          "{${thesis.organisation.group}} \\\\"
          "{\\Huge ${title}} \\\\"
          "{\\large ${thesis.title}} \\\\"
          "{${string.concatCSV ( list.map formatAuthor authors )}}"
          "\\vfill"
          "\\begin{tabularx}{\\linewidth}{@{}lX@{}}" indentation.more
        ]
        ++  [ ( thesis.auditors or { title = ""; } ).title or "Prüfer"    ]
        ++  ( list.map thesis.formatAuthorTableLine ( thesis.auditors or { people = []; } ).people )
        ++  [ ( thesis.advisors or { title = ""; } ).title or "Betreuer"  ]
        ++  ( list.map thesis.formatAuthorTableLine ( thesis.advisors or { people = []; } ).people )
        ++  [
              "${thesisVersion version} & ${time.formatDate date "deu"} in ${place} \\\\"
              indentation.less "\\end{tabularx}"
              "\\clearpage"
            ];
  }
