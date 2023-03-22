{ core, fonts, ... }:
  let
    inherit(core) indentation list set string;
  in
    { acronyms, assets, packages, publications, references, source, substances, ... }:
    (
      [
        ''
          \documentclass[
            11pt,
            a4paper,
            twoside,
            bookmarks                             =   true,
            pdfborder                             =   {0 0 0},
            pdfencoding                           =   auto,
            unicode                               =   true,
            sections,
            BCOR                                  =   10mm,
            listof                                =   flat,
            numbers                               =   noenddot,
            toc                                   =   listof,
            toc                                   =   index,
            table,
          ]
          {scrartcl}
        ''
        ''
          \directlua{
            acronymFile                           =   "${acronyms}"
            jobname                               =   [[\jobname]]
            source                                =   [[\source]].."/"
            buildDirectory                        =   [[\build]].."/"
            dofile(source.."${source.lua}common.lua")
          }
        ''
        "\\newcommand{\\inputCode  }[1]{\\input{\\source/${source.tex}#1}}"
        "\\newcommand{\\inputAssets}[1]{\\input{\\source/${assets}#1}}"
        "\\def\\biblatexStyle{\\source/${assets}biblatex/chem-angew}"
        "\\makeatletter"
      ]
      ++  packages
      ++  [
            "\\makeatother"
            "\\usepackage{scrlayer-scrpage}"
            "\\usepackage{scrletter}"
          ]
      ++  fonts
      ++  [
            "\\pdfvariable suppressoptionalinfo ${string ( 32 + 64 + 512 )}"    # Makes the PDF constant
            "\\setstretch{1.433}"                                                     # 1/2-spacing

            "\\DeclareFloatingEnvironment[" indentation.more
            "fileext = los,"
            "listname = {Schema\\-verzeichnis},"
            "name = Schema,"
            indentation.less "]{scheme}"

            # Header and Footer
            ''
              \def\pagemark{\thepage~/~\thelastpage}
              \pagestyle{scrheadings}
              \clearscrheadfoot
              \ohead{\leftmark}
              \ihead{\rightmark}
              %\cfoot[\pagemark]{\pagemark}
              \ofoot{\pagemark}
              \newgeometry{
                margin=2.5cm
              }
            ''

            /*
                ''
      \newcommand{\enclosureSection           }[2]%
      {%
        \phantomsection%
        \mbox{}\\[-\normalbaselineskip]\nopagebreak%
        \addsubsectiontocentry{}              {#1}%
        \markleft                             {#1}%
        \ignorespaces#2\clearpage%
      }%

      \constPDF
        {\@LetterSenderFirstName\ \@LetterSenderLastName}
        {\@LetterSubject vom \@LetterDate}
        {\@LetterType}

      % Positons, Lengths, Alingments, etc.
      \newgeometry
      {
        textwidth = 16.5cm,
        left      = 2.5cm,
      }
    ''
            */
          ]
      ++  (
            set.mapToList
              (
                name:
                colour:
                  "\\definecolor{${name}}{HTML}{${colour}}"
              )
              {
                white                   =   "FFFFFF";
                black                   =   "000000";
                darkgray                =   "333333";
                gray                    =   "5D5D5D";
                lightgray               =   "999999";
                green                   =   "C2E15F";
                orange                  =   "FDA333";
                purple                  =   "D3A4F9";
                red                     =   "FB4485";
                blue                    =   "6CE0F1";
                darktext                =   "414141";
                awesome-emerald         =   "00A388";
                awesome-skyblue         =   "0395DE";
                awesome-red             =   "DC3522";
                awesome-pink            =   "EF4089";
                awesome-orange          =   "FF6138";
                awesome-nephritis       =   "27AE60";
                awesome-concrete        =   "95A5A6";
                awesome-darknight       =   "131A28";
              }
          )
      ++  (
            if substances != null
            then
              [ "\\directlua{substances.load(source..\"${string.slice 0 ((string.length substances) - 4) substances}\")}%" ]
            else
              []
          )

      ++  [
            "\\addbibresource{\\source/${references}}"
            "\\DeclareBibliographyCategory{ResumePublications}%"
          ]
      ++  (list.map ({ name, ... }: "\\addtocategory{ResumePublications}{${name}}%") publications)
    )
