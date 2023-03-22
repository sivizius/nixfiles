{ core, helpers, styles, toTex, urls, ... }:
{ ... }:
  let
    inherit(core) indentation list string;
    inherit(helpers) formatSection;

    toTex'                              =   body: string.concatWords (toTex body);

    formatSkill
    =   { description, extra ? null, show ? true, title, url ? null, ... }:
          let
            description'                =   styles.skillSet (toTex' description);
            extra'
            =   if      extra != null then  toTex' extra
                else if url   != null then  urls.formatHttpsTeXboxed url url
                else                        null;
            extra''                     =   if extra' != null then "& ${styles.description extra'} " else "";
            title'                      =   styles.skillType (toTex' title);
          in
            list.ifOrEmpty show "${title'} & ${description'} ${extra''}\\\\%";
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
              "\\begin{tabularx}{\\textwidth}{rXl}%" indentation.more
            ]
            ++  (list.concatMap formatSkill body)
            ++  [
                  indentation.less "\\end{tabularx}%"
                  indentation.less "\\end{center}%"
                ]
          )
      )
    )
