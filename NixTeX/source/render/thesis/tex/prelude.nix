{ context, core, ... }:
  let
    inherit(core) indentation set string;

    boldFont
    =   {
          BoldFont                        =   "*-Bold";
          UprightFont                     =   "*-Regular";
        };

    regularFont
    =   {
          UprightFont                     =   "*-Regular";
        };

    lightFont
    =   {
          BoldFont                        =   "*-Bold";
          ItalicFont                      =   "*-Light";
          UprightFont                     =   "*-Regular";
        };

    usualFont
    =   {
          BoldFont                        =   "*-Bold";
          BoldItalicFont                  =   "*-BoldItalic";
          ItalicFont                      =   "*-Italic";
          UprightFont                     =   "*-Regular";
        };

    defaultFontFeatures
    =   fontName:
        { ... } @ features:
        [
          "\\defaultfontfeatures[${fontName}]{" indentation.more
          "Path = \\source/fonts/,"
          "Extension = .ttf,"
        ]
        ++  (set.mapToList (key: value: "${key} = ${value},") features)
        ++  [ indentation.less "}" ];
  in
    { ... }:
    { assets, acronyms, packages, references, source, substances, ... }:
    (
      [
        ''
          \documentclass[
            12pt,
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
          {scrreprt}
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
          ]
      ++  ( defaultFontFeatures "Arimo"                     usualFont   )
      ++  ( defaultFontFeatures "Cousine"                   usualFont   )
      ++  ( defaultFontFeatures "DejaVu Sans"               regularFont )
      ++  ( defaultFontFeatures "Liberation Mono"           usualFont   )
      ++  ( defaultFontFeatures "Liberation Sans"           usualFont   )
      ++  ( defaultFontFeatures "Liberation Serif"          usualFont   )
      ++  ( defaultFontFeatures "Noto Sans"                 usualFont   )
      ++  ( defaultFontFeatures "Noto Serif"                usualFont   )
      ++  ( defaultFontFeatures "Noto Color Emoji"          regularFont )
      ++  ( defaultFontFeatures "Noto Kufi Arabic"          lightFont   )
      ++  ( defaultFontFeatures "Noto Music Regular"        regularFont )
      ++  ( defaultFontFeatures "Noto Naskh Arabic"         boldFont    )
      ++  ( defaultFontFeatures "Noto Naskh Arabic UI"      boldFont    )
      ++  ( defaultFontFeatures "Noto Nastaliq Urdu"        boldFont    )
      ++  ( defaultFontFeatures "Noto Rashi Hebrew"         lightFont   )
      ++  ( defaultFontFeatures "Noto Sans Adlam"           boldFont    )
      ++  ( defaultFontFeatures "Noto Sans Adlam Unjoined"  boldFont    )
      ++  ( defaultFontFeatures "Noto Sans Hebrew"          lightFont   )
      ++  ( defaultFontFeatures "Noto Serif Hebrew"         lightFont   )
      ++  ( defaultFontFeatures "Roboto"                    usualFont   )
      ++  ( defaultFontFeatures "Roboto Condensed"          usualFont   )
      ++  ( defaultFontFeatures "Roboto Mono"               usualFont   )
      ++  ( defaultFontFeatures "Roboto Slab"               lightFont   )
      ++  ( defaultFontFeatures "Tinos"                     usualFont   )
      ++  ( defaultFontFeatures "unifont"                   regularFont )
      ++  [
            "\\def\\fullStop{\\foreignlanguage{british}{.}}"
            "\\def\\comma{\\foreignlanguage{british}{,}}"
            "\\setmainfont{Tinos}[]"
            "\\setsansfont{Roboto}[]"
            "\\setmonofont{Roboto Mono}[]"
            "\\setmathfont{latinmodern-math.otf}[]"
            "\\babelprovide[import]{british}"
            "\\babelprovide[import,main]{ngerman}"
            "\\babelfont{rm}{Tinos}"
            "\\babelfont{sf}{Roboto}"
            "\\babelfont{tt}{Roboto Mono}"
            "\\babelprovide[import]{arabic}"
            "\\babelfont[*arabic]{rm}[RawFeature=]{Noto Naskh Arabic}"
            "\\babelfont[*arabic]{sf}[RawFeature={fallback=NotoSansFallback}]{Noto Kufi Arabic}"
            "\\babelprovide[import]{greek}"
            "\\babelfont[greek]{rm}{Noto Serif}"
            "\\babelfont[greek]{sf}{Roboto}"
            "\\babelfont[greek]{tt}{Roboto}"
            "\\babelprovide[import]{hebrew}"
            "\\babelfont[*hebrew]{rm}{Noto Serif Hebrew}"
            "\\babelfont[*hebrew]{sf}{Noto Sans Hebrew}"
            "\\babelfont[*hebrew]{tt}{Noto Sans Hebrew}"
            #"\\babelprovide[import]{japanese}"
            #"\\babelfont[japanese]{rm}{Noto Serif Japanese}"
            #"\\babelfont[japanese]{sf}{Noto Sans Japanese}"
            #"\\babelfont[japanese]{tt}{Noto Sans Japanese}"
            "\\renewcommand{\\familydefault}{\\sfdefault}"
            "\\pdfvariable suppressoptionalinfo ${string ( 32 + 64 + 512 )}"    # Makes the PDF constant
            "\\setstretch{1.433}"                                                     # 1/2-spacing

            "\\DeclareFloatingEnvironment[" indentation.more
            "fileext = los,"
            "listname = {Schema\\-verzeichnis},"
            "name = Schema,"
            indentation.less "]{scheme}"

            # Positons, Lengths, Alingments, etc. for TOC
            "\\setlength{\\parindent}{0cm}"
            "\\newlength{\\chapterindent}"
            "\\setlength{\\chapterindent}{0em}"
            "\\newlength{\\chapterspace}"
            "\\settowidth{\\chapterspace}{6. }"
            "\\renewcommand{\\chapterheadstartvskip}{\\vspace{0pt}}"
            "\\newlength{\\sectionindent}"
            "\\setlength{\\sectionindent}{\\chapterindent}"
            "\\addtolength{\\sectionindent}{\\chapterspace}"
            "\\newlength{\\sectionspace}"
            "\\settowidth{\\sectionspace}{6.6. }"
            "\\newlength{\\subsectionindent}"
            "\\setlength{\\subsectionindent}{\\sectionindent}"
            "\\addtolength{\\subsectionindent}{\\sectionspace}"
            "\\newlength{\\subsectionspace}"
            "\\settowidth{\\subsectionspace}{6.6.66. }"
            "\\newlength{\\subsubsectionindent}"
            "\\setlength{\\subsubsectionindent}{\\subsectionindent}"
            "\\addtolength{\\subsubsectionindent}{\\subsectionspace}"
            "\\newlength{\\subsubsectionspace}"
            "\\settowidth{\\subsubsectionspace}{6.6.66.66. }"
            # Redefine Sections and Paragraphs
            "\\RedeclareSectionCommands[tocpagenumberwidth=6ex]%"
            "  {part,chapter,section,subsection,subsubsection,paragraph,subparagraph}"
            ''
              \RedeclareSectionCommands[
                tocentryformat=\tocentryformat,
                tocpagenumberformat=\tocentryformat
              ]
              {section,subsection,subsubsection,paragraph,subparagraph}
            ''
            ''
              \makeatletter
              \patchcmd     {\l@chapter}                          {\chapterindent       }{\chapterspace}{}{}
              \renewcommand {\l@section}      {\@dottedtocline{1} {\sectionindent       }{\sectionspace}}
              \renewcommand {\l@subsection}   {\@dottedtocline{2} {\subsectionindent    }{\subsectionspace}}
              \renewcommand {\l@subsubsection}{\@dottedtocline{3} {\subsubsectionindent }{\subsubsectionspace}}
              \makeatother
            ''

            # Header and Footer
            "\\def\\pagemark{\\thepage}"
            "\\pagestyle{scrheadings}"
            "\\clearpairofpagestyles"
            "\\ohead{\\leftmark}"
            "\\ofoot[\\pagemark]{\\pagemark}"
          ]
      ++  (
            if substances != null
            then
              [ "\\directlua{substances.load(source..\"${string.slice 0 ((string.length substances) - 4) substances}\")}%" ]
            else
              []
          )
      ++  [ "\\addbibresource{\\source/${references}}" ]
    )
