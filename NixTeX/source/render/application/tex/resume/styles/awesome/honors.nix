{ core, helpers, styles, toTex, ... }:
{ language, ... }:
  let
    inherit(core) indentation list string;
    inherit(helpers) formatDate formatSection;

    toTex'                              =   body: string.concatWords (toTex body);

    formatHonor
    =   { date, description, place, show ? true, title }:
          let
            date'                       =   styles.honorDate     (formatDate date language);
            place'                      =   styles.honorLocation (toTex' place);
            position'                   =   styles.honorPosition (toTex' title);
            title'                      =   styles.honorTitle    (toTex' description);
          in
            list.ifOrEmpty show "${date'} & ${position'}, ${title'} & ${place'} \\\\%";
  in
    list.concatMap
    (
      { body, show ? true, title }:
        list.ifOrEmpty' show
        (
          formatSection title
          (
            [
              "\\vspace{-1em}%"
              "\\begin{center}%" indentation.more
              "\\setlength{\\tabcolsep}{1ex}%"
              "\\setlength{\\extrarowheight}{0pt}%"
              "\\begin{tabularx}{\\textwidth}{lXr}%" indentation.more
            ]
            ++  (list.concatMap formatHonor body)
            ++  [
                  indentation.less "\\end{tabularx}%"
                  indentation.less "\\end{center}%"
                ]
          )
        )
    )
