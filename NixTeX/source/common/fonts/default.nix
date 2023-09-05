{ core, ... }:
  let
    inherit(core) indentation set;

    boldFont
    =   {
          BoldFont                      =   "*-Bold";
          UprightFont                   =   "*-Regular";
        };

    regularFont
    =   {
          UprightFont                   =   "*-Regular";
        };

    lightFont
    =   {
          BoldFont                      =   "*-Bold";
          ItalicFont                    =   "*-Light";
          UprightFont                   =   "*-Regular";
        };

    usualFont
    =   {
          BoldFont                      =   "*-Bold";
          BoldItalicFont                =   "*-BoldItalic";
          ItalicFont                    =   "*-Italic";
          UprightFont                   =   "*-Regular";
        };

    boldFont'                           =   boldFont // { UprightFont = "*"; };
    regularFont'                        =   regularFont // { UprightFont = "*"; };
    lightFont'                          =   lightFont // { UprightFont = "*"; };
    usualFont'                          =   usualFont // { UprightFont = "*"; };

    defaultFontFeatures
    =   fontName:
        { ... } @ features:
        [
          "\\defaultfontfeatures[${fontName}]{" indentation.more
        ]
        ++  (
              set.mapToList
                (key: value: "${key} = ${value},")
                (
                  {
                    Path                =   "\\source/fonts/";
                    Extension           =   ".ttf";
                  }
                  //  features
                )
            )
        ++  [ indentation.less "}" ];
  in []
  ++  ( defaultFontFeatures "Arimo"                     usualFont     )
  ++  ( defaultFontFeatures "Cousine"                   usualFont     )
  ++  ( defaultFontFeatures "DejaVu Sans"               regularFont   )
  ++  ( defaultFontFeatures "Liberation Mono"           usualFont     )
  ++  ( defaultFontFeatures "Liberation Sans"           usualFont     )
  ++  ( defaultFontFeatures "Liberation Serif"          usualFont     )
  ++  ( defaultFontFeatures "Noto Sans"                 usualFont'    )
  ++  ( defaultFontFeatures "Noto Serif"                usualFont'    )
  ++  ( defaultFontFeatures "Noto Color Emoji"          regularFont'  )
  ++  ( defaultFontFeatures "Noto Kufi Arabic"          lightFont'    )
  ++  ( defaultFontFeatures "Noto Music Regular"        regularFont'  )
  ++  ( defaultFontFeatures "Noto Naskh Arabic"         boldFont'     )
  ++  ( defaultFontFeatures "Noto Naskh Arabic UI"      boldFont'     )
  ++  ( defaultFontFeatures "Noto Nastaliq Urdu"        boldFont'     )
  ++  ( defaultFontFeatures "Noto Rashi Hebrew"         lightFont'    )
  ++  ( defaultFontFeatures "Noto Sans Adlam"           boldFont'     )
  ++  ( defaultFontFeatures "Noto Sans Adlam Unjoined"  boldFont'     )
  ++  ( defaultFontFeatures "Noto Sans Hebrew"          lightFont'    )
  ++  ( defaultFontFeatures "Noto Serif Hebrew"         lightFont'    )
  ++  ( defaultFontFeatures "Roboto"                    usualFont     )
  ++  ( defaultFontFeatures "Roboto Condensed"          usualFont     )
  ++  ( defaultFontFeatures "Roboto Mono"               usualFont     )
  ++  ( defaultFontFeatures "Roboto Slab"               lightFont     )
  ++  ( defaultFontFeatures "Tinos"                     usualFont     )
  ++  ( defaultFontFeatures "unifont"                   regularFont'  )
  ++  (
          defaultFontFeatures "forkawesome"
          {
            UprightFont                 =   "*-webfont";
          }
      )
  ++  (
        defaultFontFeatures "Font-Awesome"
        {
          Extension                     =   ".otf";
          UprightFont                   =   "*-6-Free-Regular-400";
          ItalicFont                    =   "*-6-Free-Solid-900";
          SmallCapsFont                 =   "*-6-Brands-Regular-400";
        }
      )
  ++  [
        "\\newfontfamily{\\fontAwesome}{Font-Awesome}"
        "\\DeclareTextFontCommand{\\textFontAwesome}{\\fontAwesome}"
        "\\newfontfamily{\\forkAwesome}{forkawesome}"
        "\\DeclareTextFontCommand{\\textForkAwesome}{\\forkAwesome}"
        "\\def\\fullStop{\\foreignlanguage{british}{.}}"
        "\\def\\comma{\\foreignlanguage{british}{,}}"
        "\\setmainfont{Liberation Serif}[]"
        "\\setsansfont{Roboto}[]"
        "\\setmonofont{Roboto Mono}[]"
        "\\setmathfont{latinmodern-math.otf}[]"
        "\\babelprovide[import]{british}"
        "\\babelprovide[import,main]{ngerman}"
        "\\babelfont{rm}{Liberation Serif}"
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
      ]
