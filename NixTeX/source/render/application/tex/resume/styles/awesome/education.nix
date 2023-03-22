{ core, helpers, toTex, ... }:
{ ... }:
  let
    inherit(core) indentation list string;
    inherit(helpers) formatEntry formatSection;

    toTex'                              =   body: string.concatWords (toTex body);

    formatEducationEntries
    =   list.concatMap
        (
          { date, degree, description ? null, grade ? null, institution, place ? null, show ? true }:
            list.ifOrEmpty' show
            (
              formatEntry
              {
                inherit date description place;
                position
                =   if grade != null
                    then
                      "${toTex' degree}, ${toTex' grade}"
                    else
                      degree;
                title                   =   institution;
              }
            )
        );
  in
    { body, show ? true, title }:
      list.ifOrEmpty' show
      (
        formatSection title
        (
          [
            "\\begin{center}%" indentation.more
            "\\vspace{-1em}%"
            "\\setlength{\\tabcolsep}{0pt}%"
            "\\setlength{\\extrarowheight}{0pt}%"
            "\\begin{tabularx}{\\textwidth}{Xr}%" indentation.more
          ]
          ++  (
                list.concatMap
                  (
                    { body, title }:
                      formatEducationEntries body
                  )
                  body
              )
          ++  [
                indentation.less "\\end{tabularx}%"
                indentation.less "\\end{center}%"
              ]
        )
      )
