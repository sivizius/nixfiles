# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug error indentation list string type;
    inherit(evaluator)  evaluate;
    inherit(renderer)   toBody render;

    evaluateDedication
    =   { ... } @ document:
        { ... } @ state:
        { body, ... } @ dedication:
          let
            state'                      =   evaluate document state body;
          in
            state';

    replaceNewline
    =   text:
          string.replace
            [ "\n" ]
            [ "\\noexpand\\linebreak " ]
            (string.trim text);

    renderDedication
    =   { ... } @ document:
        { body, epigraph, ... } @ dedication:
        output:
          let
            epigraph'
            =   if epigraph != null
                then
                {
                  author
                  =   let
                        author          =   epigraph.author or null;
                      in
                        type.matchPrimitiveOrPanic author
                        {
                          null          =   null;
                          string        =   { name = author; about = null; };
                          set           =   { name = author.name; about = author.about or null; };
                        };
                  text
                  =   let
                        text            =   epigraph.text or null;
                      in
                        type.matchPrimitiveOrPanic text
                        {
                          null          =   error.throw "Must not be null";
                          string
                          =   {
                                language=   null;
                                original=   text;
                              };
                          set           =   { language = null; } // text;
                        };
                  translation           =   epigraph.translation or null;
                }
                else
                  null;

            epigraphTeX
            =   let
                  transliteration
                  =   let
                        lines
                        =   let
                              lines     =   list.filter (line: line != "") (list.map string.trim (string.splitLines epigraph'.text.latin));
                              first     =   list.head lines;
                              last      =   list.foot lines;
                              middle    =   list.map (line: "${line}\\linebreak%") ( list.body ( list.tail lines ) );
                              length    =   list.length lines;
                            in
                              if length == 1
                              then
                                [ "[${first}]%" ]
                              else
                                [ "[${first}\\linebreak%" ]
                                ++  middle
                                ++  [ "${last}]%" ];
                      in
                        if  epigraph'.text.language  !=  null
                        &&  epigraph'.text ? latin
                        then
                          [
                            "\\par%"
                            "{\\tiny%" indentation.more
                          ]
                          ++  lines
                          ++  [ indentation.less "}%" ]
                        else
                          [];

                  text
                  =   let
                        lines
                        =   let
                              lines     =   list.filter (line: line != "") (list.map string.trim (string.splitLines epigraph'.text.original));
                              first     =   list.head lines;
                              last      =   list.foot lines;
                              middle    =   list.map (line: "${line}\\linebreak%") ( list.body ( list.tail lines ) );
                            in
                              if list.length lines == 1
                              then
                                if epigraph'.text.language != null
                                then
                                  "\\foreignquote{${epigraph'.text.language}}{${first}}%"
                                else
                                  [ "${first}%" ]
                              else
                                [ "\\begin{quote}%" indentation.more ]
                                ++  (
                                      if epigraph'.text.language != null
                                      then
                                        [ "\\selectlanguage{${epigraph'.text.language}}%" ]
                                      else
                                        []
                                    )
                                ++  [ "${first}\\linebreak%" ]
                                ++  middle
                                ++  [
                                      last
                                      indentation.less "\\end{quote}%"
                                    ];

                        text
                        =   [ "{\\normalsize%" indentation.more ]
                            ++  lines
                            ++  [ indentation.less "}%" ];
                      in
                        text ++ transliteration;

                  translation
                  =   let
                        formatTranslation
                        =   text:
                              let
                                lines   =   list.filter (line: line != "") (list.map string.trim (string.splitLines text));
                                first   =   list.head lines;
                                last    =   list.foot lines;
                                middle  =   list.map (line: "${line}\\newline%") ( list.body ( list.tail lines ) );
                              in
                                if list.length lines == 1
                                then
                                  [ "\\par\\footnotesize(»${text}«)%" ]
                                else
                                  [ "\\par\\footnotesize(»${first}\\newline%" ]
                                  ++  middle
                                  ++  [ "${last}«)%" ];
                      in
                        type.matchPrimitiveOrPanic epigraph'.translation
                        {
                          null          =   [];
                          string        =   formatTranslation epigraph'.translation;
                          set           =   formatTranslation epigraph'.translation.deu;
                        };

                  author
                  =   if epigraph'.author != null
                      then
                        if epigraph'.author.about != null
                        then
                          [ "\\par{\\raggedleft\\footnotesize– \\person{${epigraph'.author.name}}~(${replaceNewline epigraph'.author.about})}" ]
                        else
                          [ "\\par{\\raggedleft\\footnotesize– \\person{${epigraph'.author.name}}}" ]
                      else
                        [];
                in
                  text
                  ++  translation
                  ++  author;

            epigraphTeX'
            =   if epigraph != null
                then
                  [
                    "{~\\vfill\\hfill\\parbox[][][t]{0.666\\linewidth}{{%" indentation.more
                    "\\tolerance 500%"
                    "\\emergencystretch 3em%"
                    "\\hfuzz=2pt%"
                    "\\vfuzz=2pt%"
                    "\\hyphenchar\\font=-1%"
                  ]
                  ++  epigraphTeX
                  ++  [ indentation.less "}}\\newpage}" ]
                else
                  [];
          in
            ( render document body ) ++ epigraphTeX';

    Dedication
    =   body:
        epigraph:
          chunks.Chunk "Dedication"
          {
            render                      =   renderDedication;
            evaluate                    =   evaluateDedication;
          }
          {
            body                        =   toBody body;
            inherit epigraph;
          };
  in
  {
    inherit Dedication;
    Epigraph                            =   Dedication [];
  }