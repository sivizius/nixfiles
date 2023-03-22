{ core, fonts, formatAuthor, ... }:
  let
    inherit(core) debug indentation list set string time;

    facultyColours                      =   "natwi";
  in
    { title, authors, date, disputation, ... }:
    { assets, acronyms, packages, references, source, substances, ... } @ args:
    (
      [
        ''
          \documentclass[
            8pt,
            bookmarks                             =   true,
            pdfborder                             =   {0 0 0},
            pdfencoding                           =   auto,
            unicode                               =   true,
            aspectratio                           =   169,
            sections,
            listof                                =   flat,
            numbers                               =   noenddot,
            table,
          ]
          {beamer}
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
            "\\usetikzlibrary{shapes.misc}"
          ]
      ++  fonts
      ++  [
            "\\renewcommand{\\familydefault}{\\sfdefault}"
            "\\pdfvariable suppressoptionalinfo ${string ( 32 + 64 + 512 )}"    # Makes the PDF constant
            "\\setstretch{1.433}"                                                     # 1/2-spacing

            "\\DeclareFloatingEnvironment[" indentation.more
            "fileext = los,"
            "listname = {Schema\\-verzeichnis},"
            "name = Schema,"
            indentation.less "]{scheme}"
            "\\resetcounteronoverlays{scheme}"

            # Slides
            "\\renewcommand<>{\\cfigure}[1][]{\\thecfigure{h}{#2}{#1}}"
            "\\renewcommand<>{\\hfigure}[1][]{\\thecfigure{H}{#2}{#1}}"
            "\\renewcommand<>{\\cgnuplot}[1][]{\\thegnuplot{h}{#2}{#1}}"
            "\\renewcommand<>{\\hgnuplot}[1][]{\\thegnuplot{H}{#2}{#1}}"
            "\\renewcommand<>{\\cFigure}[1][]{\\Thecfigure{h}{#2}{#1}}"
            "\\renewcommand<>{\\hFigure}[1][]{\\Thecfigure{H}{#2}{#1}}"
            "\\renewcommand<>{\\subchem}[4][b]{\\thesubchem{#1}{#2}{#3}{#4}{#5}}"
            "\\renewcommand<>{\\subfig}[4][b]{\\thesubfig{#1}{#2}{#3}{#4}{#5}}"
            "\\renewcommand<>{\\Subfig}[4][b]{\\theSubfig{#1}{#2}{#3}{#4}{#5}}"
            "\\renewcommand<>{\\subgnuplot}[6][b]{\\thesubgnuplot{#1}{#2}{#3}{#4}{#5}{#6}{#7}}"
            "\\renewcommand<>{\\Subgnuplot}[6][b]{\\theSubgnuplot{#1}{#2}{#3}{#4}{#5}{#6}{#7}}"
            "\\renewcommand<>{\\wrapfig}[6][0.3]{\\thewrapfig{#1}{#2}{#3}{#4}{#5}{#6}{#7}}"
            "\\renewcommand<>{\\footcite}[1]{\\footnote#2[frame]{\\fullcite{#1}}}"
            "\\renewcommand{\\thefootnote}{\\relax\\textsuperscript{[\\arabic{footnote}]}}"
            "\\def\\labelitemi{{\\NotoSansMono▶}}"
            "\\makeatletter"
            ''
              \def\setfixbeamer{
                \def\fix@beamer@close{\ifnum\beamer@trivlistdepth>0\beamer@closeitem\fi}
                \def\fix@beamer@open{\ifnum\beamer@trivlistdepth>0\gdef\beamer@closeitem{}\fi}
              }
              \def\clrfixbeamer{
                \def\fix@beamer@close{}
                \def\fix@beamer@open{}
              }

              \BeforeBeginEnvironment{enumerate}{\fix@beamer@close}
              \AfterEndEnvironment{enumerate}{\fix@beamer@open}
              \BeforeBeginEnvironment{itemize}{\fix@beamer@close}
              \AfterEndEnvironment{itemize}{\fix@beamer@open}
              \BeforeBeginEnvironment{description}{\fix@beamer@close}
              \AfterEndEnvironment{description}{\fix@beamer@open}
              %\newcommand{\bookmarkthis}[1][2]{\bookmark[page=\the\c@page,level=#1]{\GetTitleStringResult}}
              \let\footnoterule\relax
              \setfixbeamer
            ''
            ''
              \makeatother
              \directlua{
                fakultaet = "${facultyColours}"
              }
              \usepackage{\source/tuc/source/beamerthemetuc2014}
              \mode<article>{\usepackage{\source/tuc/source/beamerarticletuc2014}}
              %\makeglossaries
              \setbeameroption{}
              \setbeamertemplate{note page}[plain]
              \setbeamertemplate{caption}[numbered]
              \beamertemplatenavigationsymbolsempty

              \title{${title}}
              \subtitle{${disputation.title}}
              \author{${string.concatCSV (list.map formatAuthor authors)}}
              \date{${time.formatDate date "deu"}}
              \tucurl{}
            ''
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
