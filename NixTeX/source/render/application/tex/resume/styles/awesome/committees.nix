{ core, document, helpers, styles, toTex, ... }:
{ language, ... }:
  let
    inherit(core) indentation list string;
    inherit(document) Multilingual;
    inherit(helpers) formatDate formatSection;

    toTex'                              =   body: string.concatWords (toTex body);

    formatCommitteeEntries
    =   list.concatMap
        (
          { date, institution, position, show ? true, title }:
            let
              date'                     =   styles.committeeDate       (formatDate date language);
              institution'              =   styles.committeeInstitute  (toTex' institution);
              position'                 =   styles.committeePosition   (toTex' position);
              title'                    =   styles.committeeTitle      (toTex' title);
            in
              list.ifOrEmpty show "${date'} & ${title'}, ${position'} & ${institution'} \\\\%"
        );
  in
    committees:
      formatSection
      (
        Multilingual
        {
          deu                           =   "Gremientätigkeit";
          eng                           =   "Committees";
        }
      )
      (
        [
          "\\vspace{-1em}%"
          "\\begin{center}%" indentation.more
          "\\setlength{\\tabcolsep}{1ex}%"
          "\\setlength{\\extrarowheight}{0pt}%"
          "\\begin{tabularx}{\\textwidth}{cXr}%" indentation.more
        ]
        ++  (formatCommitteeEntries committees)
        ++  [
              indentation.less "\\end{tabularx}%"
              indentation.less "\\end{center}%"
            ]
      )
