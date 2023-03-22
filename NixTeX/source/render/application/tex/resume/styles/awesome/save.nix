{
    formatChapter
    =   { body, title }:
        [
          "\\markleft{#1}%"
          "{\\fontsize{32pt}{1em}${selectFont.headerLight}\\color{graytext} ${title}}\\newline%"
          "{\\ignorespaces\\unskip{${body}}}%"
        ];

                formatItem
    =   { body, title }:
          [ "\\item{${if title != null then "\\textbf{${title}}\\newline" else ""}%" indentation.more ]
          ++  body
          ++  [ indentation.less "}" ];

    formatItemList
    =   { config, body }:
        [
          "\\relax%"
          "\\begin{cvitems}[${config}]%" indentation.more
          "${body}%"
          indentation.less "\\end{cvitems}%"
        ];

    formatNote
    =   { body, ... }:
        [
          ''
            \def\@note{}
            \ifnotempty{\@ResumeColumns}
              {\def\@note{\@multispan{\@ResumeColumns}}}
            \@note{{\tiny ${body}\hfill}}
          ''
        ];

    formatSubEntry
    =   { date, description, grade, place, position, title, ... }:
          let
            date'                       =   "\\subentrydatestyle{${formatDate date language}}";
            description'
            =   if description != null
                then
                  [ "\\multicolumn{2}{L{17.0cm}}{\\subdescriptionstyle{${description}}}\\\\" ]
                else
                  [];
            grade'
            =   if grade != null  then  ", ${grade}"
                else                    "";
            position'
            =   if position != null
                then
                [
                  "\\subentrypositionstyle{${position}${grade}} & ${date'}\\\\"
                  "${title'}\\\\"
                ]
                else
                [
                  "${title'} & ${date'}\\\\"
                ];
            title'                      =   "\\subentrytitlestyle{${title}}";
          in
            [
              "\\setlength\\tabcolsep{0pt}"
              "\\setlength{\\extrarowheight}{0pt}"
              "\\begin{tabular*}{\\textwidth}{@{\\extracolsep{\\fill}} L{\\textwidth - 4.5cm} R{4.5cm}}" indentation.more
              "\\setlength\\leftskip{0.2cm}"
            ]
            ++  position'
            ++  description'
            ++  [ indentation.less "\\end{tabular*}" ];

    formatSubSection'
    =   { body, environment ? null, title, ... }:
        [
          "\\vspace{-3mm}%"
          "\\phantomsection%"
          "\\addsubsectiontocentry{}{}%"
          "{\\fontsize{12pt}{1em}\\sourcesanspro\\scshape\\textcolor{text}{${title}}{${body}}}%"
        ];
}