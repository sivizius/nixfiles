{ chunks, core, ... } @ libs:
  let
    inherit(core)           debug error indentation list path set string type;
    inherit(chunks)         Chunk addToLastItem;
    inherit(chunks.chunks)  Paragraph;

    escape                              =   string.char.escape;

    # { ... } -> lambda | list | path | set | string -> [ string ]
    render                              =  render' false;

    render'
    =   paragraphs:
        { ... } @ document:
        body:
          type.matchPrimitiveOrPanic body
          {
            bool                        =   error.throw "Bool in render?";
            lambda                      =   render' paragraphs document ( body libs document );
            list                        =   list.concatMap (render' true document) body;
            path                        =   render' paragraphs document ( path.import body );
            set                         =   ( Chunk.expect body ).render document body "LaTeX";
            string
            =   let
                  body'                 =   list.map ( toLine true ) ( splitTexLines body );
                in
                  if paragraphs
                  then
                    addToLastItem body' "\\par"
                  else
                    body';
          };

    # string -> [ string ]
    splitTexLines                       =   text: string.splitLines ( string.trim ( verifyString text ) );

    # { caption, description, ... } -> [ Chunk ]
    putCaption
    =   { caption, description, cite ? null, ... }:
          if  description != null
          &&  description != []
          then
            (
              if caption != null
              then
                [ "\\caption[\\nolink{%" indentation.more ]
                ++  caption
                ++  [ indentation.less "}]{%" indentation.more ]
              else
                [ "\\caption{%" indentation.more ]
            )
            ++  [
                  "\\tolerance 500%"
                  "\\emergencystretch 3em%"
                  "\\hfuzz=2pt%"
                  "\\vfuzz=2pt%"
                  "\\hyphenchar\\font=-1%"
                ]
            ++  (
                  type.matchPrimitiveOrPanic cite
                  {
                    null                =   description;
                    list                =   addToLastItem description "\\cite{${string.concatMappedWith ({ name, ... }: name) "," cite}}";
                    set                 =   addToLastItem description "\\cite{${cite.name}}";
                  }
                )
            ++  [ indentation.less "}%" ]
          else
            [];

    # [ T ] | null | set | string -> [ T ] | [ ]
    toBody
    =   body:
          type.matchPrimitiveOrPanic body
          {
            bool                        =   error.throw "Bool in toBody?";
            list                        =   body;
            null                        =   [ ];
            set                         =   [ body ];
            string                      =   [ ( Paragraph body ) ];
          };

    # string -> [ string ]
    toCaption
    =   text:
          if text != null
          then
            list.map ( toLine true ) ( splitTexLines text )
          else
            null;

    # string -> [ string ]
    toDescription
    =   text:
          if text != null
          then
            list.map ( toLine true ) ( splitTexLines text )
          else
            null;

    toLine
    =   checkCommands:
        line:
          let
            knownCommands
            =   let
                  greekLetters
                  =   [
                        "alpha"   "Alpha"
                        "beta"    "Beta"
                        "gamma"   "Gamma"
                        "delta"   "Delta"
                        "epsilon" "Epsilon"
                        "zeta"    "Zeta"
                        "eta"     "Eta"
                        "theta"   "Theta"   "vartheta"
                        "iota"    "Iota"
                        "kappa"   "Kappa"
                        "lambda"  "Lambda"
                        "mu"      "Mu"
                        "nu"      "Nu"
                        "xi"      "Xi"
                        "omicron" "Omicron"
                        "pi"      "Pi"
                        "rho"     "Rho"
                        "sigma"   "Sigma"
                        "tau"     "Tau"
                        "upsilon" "Upsilon"
                        "phi"     "Phi"
                        "chi"     "Chi"
                        "psi"     "Psi"
                        "omega"   "Omega"
                      ];
                  knownCommands
                  =   [
                        # Deprecate them soon
                          # Acronyms/Glossary
                          "acrfull" "acrlong" "acrshort" "acrtext"
                          "person"
                          # Chemistry
                          "ch" "compound"
                          "substance" "substanceFull" "substanceName" "substanceWithID"
                          # Labels and References
                          "refAppendix" "refEquation" "refFigure" "refScheme" "refTable"
                          "refPart" "refChapter" "refSection" "refSubsection" "refSubsubsection" "refParagraph" "refSubparagraph" "refSentence"
                        # Primitive
                        "ensuremath"
                        "mbox"
                        "minus"
                        "texorpdfstring"
                        "text"
                        "textsubscript" "textsuperscript"

                        "rightarrow"
                        "directlua"
                      ]
                  ++  greekLetters;
                in
                  list.mapNamesToSet (name: null) knownCommands;
            filter
            =   item:
                  let
                    item'               =   list.head item;
                  in
                    if list.isInstanceOf item
                    then
                      if set.hasAttribute item' knownCommands
                      then
                        [ ] # Replace?
                      else
                        item
                    else
                      [ ];
            commands                    =   list.concatMap filter ( string.split "[\\]([A-Za-z]+)" line );
            formatCommands
            =   {
                  "~~"                  =   "\\strikeThrough{";
                  "__"                  =   "\\underLine{";
                  "**"                  =   "\\textbf{";
                  "//"                  =   "\\textit{";
                  "++"                  =   "\\highLight{";
                  "--"                  =   "{\\scriptsize ";
                  "`"                   =   "\\texttt{";
                  "##"                  =   "\\textsc{";
                  "\""                  =   "\\q{";
                };
            line'
            =   (
                  list.fold
                    (
                      { stack, text }:
                      token:
                        if string.isInstanceOf token
                        then
                        {
                          inherit stack;
                          text          =   "${text}${token}";
                        }
                        else if list.head token != null
                        then
                        {
                          inherit stack;
                          text          =   "${text}${list.foot token}";
                        }
                        else if stack != []
                        ->      list.head stack != list.foot token
                        then
                        {
                          stack         =   list.tail token ++ stack;
                          text          =   "${text}${formatCommands.${list.foot token}}";
                        }
                        else
                        {
                          text          =   "${text}}";
                          stack         =   list.tail stack;
                        }
                    )
                    {
                      stack             =   [];
                      text              =   "";
                    }
                    ( string.split "(\\\\)?(~~|__|\\*\\*|//|\\+\\+|--|`|##|\")" line )
                ).text;
          in
            debug.warn "toLine"
            {
              text                      =   [ "Unknown LaTeX-Commands in line:" line ];
              data                      =   commands;
              when                      =   checkCommands && commands != [];
            }
            ( string.concat ( string.splitAt "${escape}(.*)${escape}" line' ) );

    # string | [ string ] -> [ string ] | !
    toLines
    =   toLines' true;

    toLines'
    =   checkCommands:
          let
            checkLines
            =   list.map
                (
                  line:
                    if string.isInstanceOf line
                    && string.match ".*\n.*" line == null
                    then
                      verifyString line
                    else
                      debug.panic [ "toLines'" "checkLines" ] "Lines must be a list of strings without newline \\n, got »${string line}«!"
                );
          in
            body:
              type.matchPrimitiveOrPanic body
              {
                bool                    =   error.throw "Bool in toLines'?";
                list                    =   list.map ( toLine checkCommands ) ( checkLines body );
                string                  =   list.map ( toLine checkCommands ) ( splitTexLines body );
              };

    # string | { caption: string, bookmark: string?, visible: bool? }
    # -> { caption: string, bookmark: string, visible: bool }
    toTitle
    =   title:
        latex:
          type.matchPrimitiveOrPanic title
          {
            bool                        =   error.throw "Bool in toTitle?";
            string
            =   {
                  caption               =   toLines' latex title;
                  bookmark              =   toLines' latex title;
                  visible               =   true;
                };
            set
            =   {
                  caption               =   toLines' latex ( title.caption                    or (debug.panic "toTitle" "Title needs caption!" ) );
                  bookmark              =   toLines' latex ( title.bookmark  or title.caption or (debug.panic "toTitle" "Title needs bookmark!") );
                  visible               =   title.visible   or true;
                };
          };

    verifyString#: string -> string
    =   text:
          let
            count
            =   char:
                  list.fold
                    (counter: char': counter + (if char == char' then 1 else 0))
                    0
                    (string.toCharacters text);
            openA                       =   count "{";
            closeA                      =   count "}";
            openB                       =   count "[";
            closeB                      =   count "]";
            openC                       =   count "(";
            closeC                      =   count ")";
            warnIfUnequal
            =   a: b:
                msg:
                  if a != b
                  then
                    debug.warn [ "document" "verifyString" ] "Counting ${msg} in\n${text}"
                  else
                    (x: x);
          in
            ( warnIfUnequal openA closeA "${string openA} »{« but ${string closeA} »}«" )
            ( warnIfUnequal openB closeB "${string openB} »[« but ${string closeB} »]«" )
            ( warnIfUnequal openC closeC "${string openC} »(« but ${string closeC} »)«" )
            text;
  in
  {
    inherit toBody toCaption toDescription toLine toLines toTitle;
    inherit putCaption render;
    splitLines                          =   splitTexLines;
  }
