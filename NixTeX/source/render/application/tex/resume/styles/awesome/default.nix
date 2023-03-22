{ core, helpers, toTex, ... } @ libs:
{
  highlight ? 3,
  language,
  order ? [
    "summary"
    "education"
    "committees"
    "honors"
    "skills"
    "languages"
    "publications"
    "motivation"
  ],
  ...
} @ config:
  let
    inherit(core) indentation list path string time;
    inherit(helpers) formatDate;

    toTex'                              =   body: string.concatWords (toTex body);

    libs'
    =   libs
    //  {
          inherit styles;
          helpers
          =   helpers
          //  {
                inherit formatSection;

                formatEntry
                =   { date, description ? null, place ? null, position, title ? null }:
                      let
                        description'
                        =   "\\multicolumn{2}{L{\\textwidth}}{${styles.description (toTex' description)}} \\\\%";
                        title'
                        =   if title != null
                            then
                              "${styles.entryTitle (toTex' title)} "
                            else
                              "";
                        place'
                        =   if place != null
                            then
                              "${styles.entryLocation (toTex' place)}"
                            else
                              "";
                      in []
                      ++  (list.ifOrEmpty (title != null || place != null) "${title'}& ${place'} \\\\%")
                      ++  [ "${styles.entryPosition (toTex' position)} & ${styles.entryDate (formatDate date language)} \\\\%" ]
                      ++  (list.ifOrEmpty (description != null) description');

                formatItems
                =   title:
                    items:
                      formatSection title
                      (
                        [
                          "\\vspace{-1em}%"
                          "\\begin{justify}%" indentation.more
                          "\\begin{itemize}[label=\\bullet, #1, leftmargin=2ex, nosep, noitemsep]%" indentation.more
                          "\\setlength{\\parskip}{0pt}%"
                        ]
                        ++  items
                        ++  [
                              indentation.less "\\end{itemize}%"
                              indentation.less "\\end{justify}%"
                              "\\vspace{-1em}%"
                            ]
                      );

                formatParagraph
                =   title:
                    body:
                      formatSection title
                      (
                        [ "\\\\[0pt]${styles.paragraphOpen}%" indentation.more ]
                        ++  (toTex body)
                        ++  [ indentation.less "\\vspace{1em}${styles.paragraphClose}%" ]
                      );
              };
        };


    formatCommittees                    =   path.import ./committees.nix    libs' config;
    formatEducation                     =   path.import ./education.nix     libs' config;
    formatHeader                        =   path.import ./header.nix        libs' config;
    formatHonors                        =   path.import ./honors.nix        libs' config;
    formatLanguages                     =   path.import ./languages.nix     libs' config;
    formatMotivation                    =   path.import ./motivation.nix    libs' config;
    formatPublications                  =   path.import ./publications.nix  libs' config;
    formatSkills                        =   path.import ./skills.nix        libs' config;
    formatSummary                       =   path.import ./summary.nix       libs' config;

    formatSection
    =   title:
        body:
          [
            "\\pagebreak[3]\\phantomsection%"
            "\\addsubsectiontocentry{}{%" indentation.more
          ]
          ++  (toTex title)
          ++  [
                indentation.less "}{%" indentation.more
                styles.sectionTitleOpen indentation.more
              ]
          ++  (toTex title)
          ++  [
                indentation.less styles.sectionTitleClose
                indentation.less "}%"
                styles.sectionBodyOpen indentation.more
              ]
          ++  body
          ++  [ indentation.less styles.sectionBodyClose ];

    styles                              =   path.import ./styles.nix libs';
  in
    {
      about         ? null,
      birth         ? null,
      committees    ? null,
      date,
      education     ? null,
      honors        ? null,
      languages     ? null,
      motivation    ? null,
      name,
      nationality   ? null,
      photo         ? null,
      place         ? null,
      publications  ? null,
      quote         ? null,
      skills        ? null,
      social        ? null,
      summary       ? null,
      title,
      ...
    } @ resume:
      [
        "\\pagestyle{scrheadings}%"
        "\\clearscrheadfoot%"
        "\\ifoot{${styles.footer (time.formatDate date language)}}%"
        "\\cfoot{${styles.footer "${name.given} ${name.family}\\quad \\leftmark"}}%"
        "\\ofoot{${styles.footer "\\pagemark"}}%"
        "\\markboth{}{}%"
        "\\markleft{${title}}%"
        "\\newgeometry{%" indentation.more
          "bottom    = 2.0cm,%"
          "footskip  = 0.5cm,%"
          "left      = 2.0cm,%"
          "right     = 2.0cm,%"
          "top       = 1.5cm,%"
        indentation.less "}%"

        "\\newsavebox\\acvHeaderSocialSepBox%"
        "\\sbox\\acvHeaderSocialSepBox{\\textbar}%"
        (
          let
            args
            =   string.concat
                (
                  list.generate
                    (index: "#${string (index + 1)}")
                    highlight
                );
          in
            "\\def\\sectioncolor${args}{${styles.sectionColor args}}%"
        )
      ]
      ++  (formatHeader resume)
      #++  [ "\\vspace{2.5\\normalbaselineskip}%" ]
      ++  (
            list.concatMap
              (
                sectionName:
                {
                  committees            =   list.ifOrEmpty' (committees   != null) (formatCommittees   committees  );
                  education             =   list.ifOrEmpty' (education    != null) (formatEducation    education   );
                  honors                =   list.ifOrEmpty' (honors       != null) (formatHonors       honors      );
                  languages             =   list.ifOrEmpty' (languages    != null) (formatLanguages    languages   );
                  motivation            =   list.ifOrEmpty' (motivation   != null) (formatMotivation   motivation  );
                  publications          =   list.ifOrEmpty' (publications != null) (formatPublications publications);
                  skills                =   list.ifOrEmpty' (skills       != null) (formatSkills       skills      );
                  summary               =   list.ifOrEmpty' (summary      != null) (formatSummary      summary     );
                }.${sectionName}
              )
              order
          )
      ++  [ "\\vfill%" ]
