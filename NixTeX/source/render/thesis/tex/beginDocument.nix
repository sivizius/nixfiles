{ context, core, thesis, ... }:
  let
    inherit(core)   indentation list string;
    inherit(thesis) formatAuthor;

    setTolerances
    =   {
          pretolerance      ? 100,      #
          tolerance         ? 200,      #
          hfuzz             ? "0.1pt",  #
          vfuzz             ? "0.1pt",  #
          hbadness          ? 1000,     #
          vbadness          ? 1000,     #
          emergencystretch  ? "3em",    #
        }:
        [
          "\\pretolerance=${string pretolerance}%"
          "\\tolerance=${string tolerance}%"
          "\\hfuzz=${string hfuzz}%"
          "\\vfuzz=${string vfuzz}%"
          "\\hbadness=${string hbadness}%"
          "\\vbadness=${string vbadness}%"
          "\\emergencystretch=${string emergencystretch}%"
        ];

    setPenalties
    =   {
          binaryOperator    ?   700,  # for a line break in math mode after a binary operator.
          brokenHyphen      ?   100,  # for a page break, where the last line of the previous page contains a hyphenation.
          club              ?   150,  # for a broken page, with a single line of a paragraph remaining on the bottom of the preceding page.
          displayWidow      ?    50,  # for a break before last line of a paragraph.
          doubleHyphen      ? 10000,  # for two consecutive hyphenated lines.
          explicitHyphen    ?    50,  # for hyphenating a word which already contains a hyphen.
          finalHyphen       ?  5000,  # for a hyphen in the last full line of a paragraph.
          floating          ? 20000,  # for splitting an insertion.
          hyphen            ?    50,  # for line breaking at an automatically inserted hyphen.
          incompatibleLines ? 10000,  # for two consecutive lines are visually incompatible.
          interDisplay      ?   100,  # for breaking a display on two pages.
          interFootnote     ?   100,  # for breaking a footnote on two pages.
          interLine         ?     0,  # for the penalty added after each line of a paragraph
          line              ?    10,  # for each line within a paragraph.
          postDisplay       ?     0,  # for a break after a display.
          preDisplay        ? 10000,  # for a break before a display.
          relationOperator  ?   500,  # for a line break in math mode after a a relation operator.
          widow             ?   150,  # for a broken page, with a single line of a paragraph remaining on the top of the succeeding page.
        }:
        [
          "\\adjdemerits=${string incompatibleLines}%"
          "\\binoppenalty=${string binaryOperator}%"
          "\\brokenpenalty=${string brokenHyphen}%"
          "\\clubpenalty=${string club}%"
          "\\doublehyphendemerits=${string doubleHyphen}%"
          "\\displaywidowpenalty=${string displayWidow}%"
          "\\exhyphenpenalty=${string explicitHyphen}%"
          "\\finalhyphendemerits=${string finalHyphen}%"
          "\\floatingpenalty=${string floating}%"
          "\\hyphenpenalty=${string hyphen}%"
          "\\interdisplaylinepenalty=${string interDisplay}%"
          "\\interfootnotelinepenalty=${string interFootnote}%"
          "\\interlinepenalty=${string interLine}%"
          "\\linepenalty=${string line}%"
          "\\postdisplaypenalty=${string postDisplay}%"
          "\\predisplaypenalty=${string preDisplay}%"
          "\\relpenalty=${string relationOperator}%"
          "\\widowpenalty=${string widow}%"
        ];
  in
    { authors, thesis, title, ... }:
    beginDocument:
      [
        "\\hypersetup{" indentation.more
          "pdfauthor={${string.concatCSV (list.map formatAuthor authors)}},"
          "pdftitle={${title}},"
          "pdfsubject={${thesis.title}},"
          "pdfkeywords={},"
          "pdfproducer={},"
          "pdfcreator={},"
        indentation.less "}"
        #"\\hyphenchar\\font=-1%"
      ]
      ++  (
            setTolerances
            {
              tolerance                 =   500;
              emergencystretch          =   "3em";
              hfuzz                     =   "2pt";
              vfuzz                     =   "2pt";
            }
          )
      ++  (
            setPenalties
            {
              brokenHyphen              =   100;
              club                      =   350;
              hyphen                    =   10000;
              widow                     =   350;
            }
          )
      ++  beginDocument
