{ chunks, core, ... } @ libs:
  let
    inherit(core)           debug error indentation list set string type;
    inherit(chunks)         Chunk addToLastItem;
    inherit(chunks.chunks)  Paragraph;

    escape                              =   string.char.escape;

    splitLines                          =   text: string.splitLines ( string.trim text );

    libs'
    =   libs
    //  {
          chemistry
          =   libs.chemistry
          //  {
                compound
                =   name:
                      let
                        parts           =   string.split "[|]" name;
                        parts'          =   list.filter (foo: string.isInstanceOf foo) parts;
                      in
                        string.concat parts';
                formatNMRnucleus
                =   nucleus:
                      nucleus;
              };
          physical
          =   libs.physical
          //  {
                formatValue
                =   value:
                    unit:
                      let
                        value'
                        =   if set.isInstanceOf value
                            then
                              if value ? value
                              then
                                string value.value
                              else
                                "<value>"
                            else
                              string value;
                        unit'
                        =   if string.isInstanceOf unit
                            then
                              unit
                            else
                              "<unit>";
                      in
                        "${value'} ${unit'}";
              };
        };

    # { ... } -> lambda | list | path | set | string -> [ string ]
    render
    =   { ... } @ document:
        body:
          type.matchPrimitiveOrPanic body
          {
            bool                        =   error.throw "Bool in render?";
            lambda                      =   render document ( body libs' document );
            list                        =   list.concatMap (render document) body;
            path                        =   render document ( import body );
            set                         =   ( Chunk.expect body ).render document body "Markdown";
            string                      =   list.map ( toLine true ) ( splitLines body );
          };

    putCaption
    =   { caption, description, cite ? null, ... }:
        [];

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
    toCaption                           =   text: list.map ( toLine true ) ( splitLines text );

    # string -> [ string ]
    toDescription                       =   text: list.map ( toLine true ) ( splitLines text );

    toLine
    =   checkCommands:
        line:
          let
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
                            text        =   "${text}${token}";
                          }
                        else if stack == []
                        ||      ( list.head stack ) != ( list.head token )
                        then
                          {
                            stack       =   token ++ stack;
                            text        =   "${text}"; # \textit{
                          }
                        else
                          {
                            text        =   "${text}"; # }
                            stack       =   list.tail stack;
                          }
                    )
                    {
                      stack             =   [];
                      text              =   "";
                    }
                    ( string.split "(~~|__|\\*\\*|//|\\+\\+|--|`|##|\")" line )
                ).text;
          in
            string.concat ( string.splitAt "${escape}(.*)${escape}" line' );

      # string | [ string ] -> [ string ] | !
    toLines
    =   toLines' true;

    toLines'
    =   checkCommands:
        body:
          type.matchPrimitiveOrPanic body
          {
            bool                        =   error.throw "Bool in toLines'?";
            list                        =   list.map ( toLine checkCommands ) body;
            string                      =   list.map ( toLine checkCommands ) ( splitLines body );
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
  in
  {
    inherit splitLines toBody toCaption toDescription toLine toLines toTitle;
    inherit putCaption render;
  }