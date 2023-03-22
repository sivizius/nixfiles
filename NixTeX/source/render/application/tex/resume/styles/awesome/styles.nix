{ ... }:
  let
    colours
    =   {
          grayText                      =   "gray";
          main                          =   "awesome-red";
          mainLight                     =   "awesome-orange";
          text                          =   "darkgray";
          lightText                     =   "lightgray";
          darkText                      =   "black";
        };
    fonts
    =   {
          header                        =   "\\setmainfont{Roboto}";
          headerLight                   =   "\\setmainfont{Roboto}";
          footer                        =   "\\setmainfont{Roboto}";
          body                          =   "\\setmainfont{Roboto}";
          bodyLight                     =   "\\setmainfont{Roboto}";
        };
  in
  {
    committeeDate                       =   text: ''{\fontsize{8pt}{1em}${fonts.body}\color{${colours.grayText}} ${text}}'';
    committeeInstitute                  =   text: ''{\fontsize{9pt}{1em}${fonts.bodyLight}\slshape\color{${colours.main}} ${text}}'';
    committeePosition                   =   text: ''{\fontsize{9pt}{1em}${fonts.body}\color{${colours.grayText}} ${text}}'';
    committeeTitle                      =   text: ''{\fontsize{9pt}{1em}${fonts.body}\bfseries\color{${colours.darkText}} ${text}}'';
    description                         =   text: ''{\fontsize{9pt}{1em}${fonts.bodyLight}\upshape\color{${colours.text}} ${text}}'';
    entryDate                           =   text: ''{\fontsize{10pt}{1em}${fonts.bodyLight}\slshape\color{${colours.mainLight}} ${text}}'';
    entryLocation                       =   text: ''{\fontsize{9pt}{1em}${fonts.bodyLight}\slshape\color{${colours.main}} ${text}}'';
    entryPosition                       =   text: ''{\fontsize{8pt}{1em}${fonts.body}\scshape\color{${colours.grayText}} ${text}}'';
    entryTitle                          =   text: ''{\fontsize{10pt}{1em}${fonts.body}\bfseries\color{${colours.darkText}} ${text}}'';
    footer                              =   text: ''{\fontsize{8pt}{1em}${fonts.footer}\scshape\color{${colours.lightText}} ${text}}'';
    headerAddress                       =   text: ''{\fontsize{8pt}{1em}${fonts.header}\itshape\color{${colours.lightText}} ${text}}'';
    headerFirstName                     =   text: ''{\fontsize{32pt}{1em}${fonts.headerLight}\color{${colours.grayText}} ${text}}'';
    headerLastName                      =   text: ''{\fontsize{32pt}{1em}${fonts.header}\bfseries\color{${colours.text}} ${text}}'';
    headerPosition                      =   text: ''{\fontsize{7.6pt}{1em}${fonts.body}\scshape\color{${colours.main}} ${text}}'';
    headerQuote                         =   text: ''{\fontsize{9pt}{1em}${fonts.body}\itshape\color{${colours.darkText}} ${text}}'';
    headerSocialClose                   =         "}";
    headerSocialOpen                    =         ''{\fontsize{6.8pt}{1em}${fonts.header}\color{${colours.text}}'';
    honorDate                           =   text: ''{\fontsize{9pt}{1em}${fonts.body}\color{${colours.grayText}} ${text}}'';
    honorLocation                       =   text: ''{\fontsize{9pt}{1em}${fonts.bodyLight}\slshape\color{${colours.main}} ${text}}'';
    honorPosition                       =   text: ''{\fontsize{9pt}{1em}${fonts.body}\bfseries\color{${colours.darkText}} ${text}}'';
    honorTitle                          =   text: ''{\fontsize{9pt}{1em}${fonts.body}\color{${colours.grayText}} ${text}}'';
    letterDate                          =   text: ''{\fontsize{9pt}{1em}${fonts.bodyLight}\slshape\color{${colours.grayText}} ${text}}'';
    letterEnclosure                     =   text: ''{\fontsize{10pt}{1em}${fonts.bodyLight}\slshape\color{${colours.lightText}} ${text}}'';
    letterName                          =   text: ''{\fontsize{10pt}{1em}${fonts.body}\bfseries\color{${colours.darkText}} ${text}}'';
    letterSection                       =   text: ''{\fontsize{14pt}{1em}${fonts.body}\bfseries\color{${colours.text}}\sectioncolor ${text}}'';
    letterText                          =         ''{\fontsize{10pt}{1.4em}${fonts.bodyLight}\upshape\color{${colours.grayText}}}'';
    letterTitle                         =   text: ''{\fontsize{10pt}{1em}${fonts.bodyLight}\bfseries\color{${colours.darkText}} \underline{${text}}}'';
    paragraphClose                      =         "}";
    paragraphOpen                       =         ''{\fontsize{9pt}{1em}${fonts.bodyLight}\upshape\color{${colours.text}}'';
    recipientAddress                    =   text: ''{\fontsize{9pt}{1em}${fonts.body}\scshape\color{${colours.grayText}} ${text}}'';
    recipientTitle                      =   text: ''{\fontsize{11pt}{1em}${fonts.body}\bfseries\color{${colours.darkText}} ${text}}'';
    sectionBodyClose                    =   ''}\vfill%'';
    sectionBodyOpen                     =   ''\makeatletter\color{${colours.grayText}}\leavevmode\leaders\hrule\@height0.9pt\hfill\kern\z@\makeatother{%'';
    sectionTitle                        =   text: ''{\fontsize{16pt}{1em}${fonts.body}\bfseries\color{${colours.text}}\sectioncolor ${text}}'';
    sectionTitleOpen                    =   ''{\fontsize{16pt}{1em}${fonts.body}\bfseries\color{${colours.text}}\sectioncolor%'';
    sectionTitleClose                   =   ''}%'';
    sectionColor                        =   text: ''{\color{${colours.main}} ${text}}'';
    skillSet                            =   text: ''{\fontsize{9pt}{1em}${fonts.bodyLight}\color{${colours.text}} ${text}}'';
    skillType                           =   text: ''{\fontsize{10pt}{1em}${fonts.body}\bfseries\color{${colours.darkText}} ${text}}'';
    subDescription                      =   text: ''{\fontsize{8pt}{1em}${fonts.bodyLight}\upshape\color{${colours.text}} ${text}}'';
    subEntryDate                        =   text: ''{\fontsize{7pt}{1em}${fonts.bodyLight}\slshape\color{${colours.grayText}} ${text}}'';
    subEntryLocation                    =   text: ''{\fontsize{7pt}{1em}${fonts.bodyLight}\slshape\color{${colours.main}} ${text}}'';
    subEntryPosition                    =   text: ''{\fontsize{7pt}{1em}${fonts.body}\scshape\color{${colours.grayText}} ${text}}'';
    subEntryTitle                       =   text: ''{\fontsize{8pt}{1em}${fonts.body}\mdseries\color{${colours.grayText}} ${text}}'';
    subSection                          =   text: ''{\fontsize{12pt}{1em}${fonts.body}\scshape\textcolor{${colours.text}}{${text}}}'';
  }
