{ core, document, helpers, symbols, styles, toTex, ... }:
{ maxStars ? 5, ...  }:
  let
    inherit(core) debug indentation list number set string type;
    inherit(document) Multilingual;
    inherit(helpers) formatSection;
    inherit(symbols.forkAwesome) star star-half-o star-o;

    toTex'                              =   body: string.concatWords (toTex body);

    languageLevels
    =   {
          "native"
          =   {
                description
                =   {
                      deu               =   "Muttersprache";
                      eng               =   "Native Language";
                    };
                level                   =   Multilingual { deu = "nativ"; eng = "native"; };
                stars                   =   1.0;
              };
          "C2"
          =   {
                description
                =   {
                      deu               =   "Kompetente Sprachverwendung";
                      eng               =   "Proficient User";
                    };
                level                   =   "C2";
                stars                   =   7 / 8.;
              };
          "C1"
          =   {
                description
                =   {
                      deu               =   "Kompetente Sprachverwendung";
                      eng               =   "Proficient User";
                    };
                level                   =   "C1";
                stars                   =   6 / 8.;
              };
          "B2"
          =   {
                description
                =   {
                      deu               =   "Selbstständige Sprachverwendung";
                      eng               =   "Independent User";
                    };
                level                   =   "B2";
                stars                   =   5 / 8.;
              };
          "B1"
          =   {
                description
                =   {
                      deu               =   "Selbstständige Sprachverwendung";
                      eng               =   "Independent User";
                    };
                level                   =   "B1";
                stars                   =   4 / 8.;
              };
          "A2"
          =   {
                description
                =   {
                      deu               =   "Elementare Sprachverwendung";
                      eng               =   "Basic User";
                    };
                level                   =   "A2";
                stars                   =   3 / 8.;
              };
          "A1"
          =   {
                description
                =   {
                      deu               =   "Elementare Sprachverwendung";
                      eng               =   "Basic User";
                    };
                level                   =   "A1";
                stars                   =   2 / 8.;
              };
          "latinum"
          =   {
                description
                =   {
                      deu               =   "Latinum";
                      eng               =   "Latinum";
                    };
                level                   =   null;
                stars                   =   1 / 8.;
              };
        };

    languageNames
    =   {
          ces                           =   { deu = "Tschechisch";  eng = "Czech";      };
          deu                           =   { deu = "Deutsch";      eng = "German";     };
          eng                           =   { deu = "Englisch";     eng = "English";    };
          epo                           =   { deu = "Esperanto";    eng = "Esperanto";  };
          heb                           =   { deu = "Ivrit";        eng = "Ivrit";      };
          lat                           =   { deu = "Latein";       eng = "Latin";      };
        };

    rateHalfStars
    =   value:
        maximum:
          let
            full                        =   number.floor (value * maximum);
            empty                       =   number.floor ((1 - value) * maximum);
            half                        =   maximum - full - empty;
          in
            (list.generate (_: star) full)
            ++  (list.ifOrEmpty (half != 0) star-half-o)
            ++  (list.generate (_: star-o) empty);

    formatLanguage
    =   name:
        { description, level, stars, ... }:
          let
            name'                       =   styles.skillType (toTex' (Multilingual name));
            level'                      =   if level != null then styles.skillSet (toTex' level) else "";
            description'                =   styles.description (toTex' (Multilingual description));
            stars'
            =   if stars != null
                then
                  string.concat (rateHalfStars stars maxStars)
                else
                  "";
          in
            "${name'} & ${description'} & ${level'} & ${styles.entryLocation stars'} \\\\%";
  in
    languages:
      let
        emptyLevel
        =   {
              description               =   "";
              level                     =   "";
              stars                     =   0;
            };
        languages'
        =   set.mapToList
              (
                language:
                level:
                {
                  name                  =   languageNames.${language} or language;
                  level
                  =   type.matchPrimitiveOrPanic level
                      {
                        null            =   emptyLevel;
                        int
                        =   debug.panic "languages'"
                            {
                              text      =   "Level of type integer must be between 0 and `maxStars` (${string maxStars}) inclusive, got:";
                              data      =   level;
                              when      =   level < 0 || level > maxStars;
                            }
                            ( emptyLevel // { stars = 1.0 * level / maxStars; });
                        float
                        =   debug.panic "languages'"
                            {
                              text      =   "Level of type float must be between 0.0 and 1.0 inclusive, got:";
                              data      =   level;
                              when      =   level < 0.0 || level > 1.0;
                            }
                            ( emptyLevel // { stars = level; });
                        set             =   emptyLevel // level;
                        string          =   languageLevels.${level};
                      };
                }
              )
              languages;
        compare                         =   foo: bar: foo.level.stars > bar.level.stars;
      in
        formatSection
          (
            Multilingual
            {
              deu                       =   "Sprachen";
              eng                       =   "Languages";
            }
          )
          (
            [
              "\\vspace{-1em}%"
              "\\begin{center}%" indentation.more
              "\\setlength{\\tabcolsep}{1ex}%"
              "\\setlength{\\extrarowheight}{0pt}%"
              "\\begin{tabularx}{\\textwidth}{rXrl}%" indentation.more
            ]
            ++  (
                  list.map
                    ({ name, level }: formatLanguage name level)
                    (list.sort compare languages')
                )
            ++  [
                  indentation.less "\\end{tabularx}%"
                  indentation.less "\\end{center}%"
                ]
          )
