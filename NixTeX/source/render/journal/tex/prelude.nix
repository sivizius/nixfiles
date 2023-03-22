{ core, ... }:
  let
    inherit(core) string;
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
            dofile("${source.lua}common.lua")
          }
        ''
        "\\newcommand{\\inputCode  }[1]{\\input{\\source/${source.tex}#1}}"
        "\\newcommand{\\inputAssets}[1]{\\input{\\source/${assets}#1}}"
        "\\def\\biblatexStyle{${assets}biblatex/chem-angew}"
        "\\makeatletter"
      ]
      ++  packages
      ++  [
            "\\makeatother"
            "\\usepackage{scrlayer-scrpage}"
            "\\pdfvariable suppressoptionalinfo ${string ( 32 + 64 + 512 )}"    # Makes the PDF constant
            "\\setstretch{1.433}"                                                     # 1/2-spacing

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
            "\\robkoma"
          ]
      ++  (
            if substances != null
            then
              [ "\\loadSubstances{${string.slice 0 ((string.length substances) - 4) substances}}" ]
            else
              []
          )
      ++  [ "\\addbibresource{${references}}" ]
    )
