# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
let
  inherit(core)       debug error indentation list string type;
  inherit(evaluator)  evaluate;
  inherit(renderer)   toBody toCaption toDescription putCaption render;

  # { ... } -> [ string ]:
  mapChemeToken
  =   token:
        let
          phantom
          =   text:
                if token.phantom or false
                then
                  "\\phantom{${text}}"
                else
                  text;
        in
        if      token ? plus
        then
          [ "\\+" ]
        else if token ? arrow
        then
          let
            optionals
            =   list.map
                (
                  argument:
                    type.matchPrimitiveOrPanic argument
                    {
                      bool              =   error.throw "Bool in mapChemeToken?";
                      null              =   "[]";
                      int               =   "[${string argument}]";
                      float             =   "[${string argument}]";
                      string            =   "[\\tiny{${argument}}]";
                      set
                      =   if argument ? text
                          then let
                            pos
                            =   if argument ? pos
                                then
                                  ".${argument.pos}"
                                else
                                  "";
                          in
                            "[*{0${pos}}\\tiny{${argument.text}}]"
                          else
                            debug.panic "mapChemeToken" "Argument does not has a text.";
                    }
                )
                token.arguments;
            from                        =   token.config.from or "";
            till                        =   token.config.till or "";
            fromTo
            =   if from != ""
                || till != ""
                then
                  "(${string from}--${string till})"
                else
                  "";
            angle                       =   token.config.angle  or "";
            length                      =   token.config.length or "";
            config
            =   if angle != "" || length != ""
                then
                  "[${string angle},${string length}]"
                else
                  "";
          in
            [ (phantom "\\arrow${fromTo}{${token.arrow}${string.concat optionals}}${config}") ]
        else let
          yield                         =   token.config.yield or null;
          withYield                     =   if yield != null then "Yield{${string yield}}" else "";
        in if token ? substance
        then
          if token.number or false
          && token.code or false
          then
            [ (phantom "\\directlua{substances.printMoleculeWithNumberCode([[${token.substance}]])}") ]
          else if token.number or false
          then
            [ (phantom "\\directlua{substances.printMoleculeWithNumber([[${token.substance}]])}") ]
          else if token.code or false
          then
            [ (phantom "\\directlua{substances.printMoleculeWithCode([[${token.substance}]])}") ]
          else if token.text or null != null
          then
            [ (phantom "\\chemname{\\directlua{substances.printMolecule([[${token.substance}]])}}{\\tiny ${token.text}}") ]
          else
            [ (phantom "\\directlua{substances.printMolecule([[${token.substance}]])}") ]
        else let
          movPart
          =   type.matchPrimitiveOrPanic token.movPart
              {
                list                    =   string.concat token.movPart;
                string                  =   token.movPart;
              };
          movPart'
          =   if token ? movPart
              then
                [ "\\chemmove{${movPart}}" ]
              else
                [];
          figPart
          =   type.matchPrimitiveOrPanic token.figPart
              {
                list                    =   string.concat token.figPart;
                string                  =   token.figPart;
              };
        in if token ? name
        then
          [
            (phantom "\\chemname{\\chemfig{${figPart}}}{\\tiny{${token.name}}}")
          ] ++ movPart'
        else
          [ (phantom "\\chemfig{${figPart}}") ] ++ movPart';


  # [ { ... } ] -> [ string ]:
  mapChemeLine
  =   line:
        list.concatMap
        (
          { scale ? 1.5, scheme, skip ? null, only ? null, uncover ? null, ... } @ line:
          (
            if      only != null
            then
              [ "\\only<${only}>{%" ]
            else if uncover != null
            then
              [ "\\uncover<${uncover}>{%" ]
            else
              []
          )
          ++  [
                "\\scalebox{${string scale}}%"
                "{%" indentation.more
              ]
          ++  [ "\\schemestart%" ]
          ++  ( list.concatMap mapChemeToken scheme )
          ++  [ "\\schemestop%" ]
          ++  (
                if line ? movPart
                then
                  [ "\\chemmove{%" indentation.more ]
                  ++  line.movPart
                  ++  [ indentation.less "}%" ]
                else
                  []
              )
          ++  [ indentation.less "}%" ]
          ++  (
                let
                  skip'
                  =   if skip != null
                      then
                        "[${string skip}\\normalbaselineskip]"
                      else
                        "";

                in
                  [ "\\chemnameinit{}\\\\${skip'}%" ]
              )
          ++  (
                if only != null || uncover != null
                then
                  [ "}%" ]
                else
                  []
              )
        )
        line;

  evaluateCheme
  =   { ... } @ document:
      { ... } @ state:
      { dependencies, ... } @ scheme:
        let
          state'                        =   state;
        in
          state
          //  {
                dependencies            =   state'.dependencies ++ dependencies;
                schemes
                =   state'.schemes
                //  {
                      counter           =   state'.schemes.counter + 1;
                    };
              };

  # { ... } -> Document::Chunk::Cheme -> [ indentation | string ]:
  renderCheme
  =   _:
      { numbers, body, label ? null, ... } @ scheme:
      output:
        if output == "LaTeX"
        then
          [
            "\\begin{scheme}[H]" indentation.more
          ]
          ++  (
                if numbers
                then
                  [ "\\numAtoms" ]
                else
                  []
              )
          ++  [
                "\\centering{%" indentation.more
              ]
          ++  ( mapChemeLine body )
          ++  [ indentation.less "}%" ]
          ++  ( putCaption scheme )
          ++  (
                if label != null
                then
                  [ "\\labelScheme{${label}}%" ]
                else
                  [ ]
              )
          ++  [ indentation.less "\\end{scheme}" ]
      else if output == "Markdown"
      then
        []
      else
        debug.panic "render" "Unknown output ${output}";
in
{
  # string | set -> [ T ] -> Document::Chunk::Cheme:
  Cheme
  =   {
        Arrow
        =   arrow:
            config:
            arguments:
              { inherit arrow config arguments; };
        Plus                            =   { plus = null; };
        __functor
        =   self:
            config:
            body:
              chunks.Chunk "Cheme"
              {
                render                  =   renderCheme;
                evaluate                =   evaluateCheme;
              }
              (
                type.matchPrimitiveOrPanic config
                {
                  string
                  =   {
                        caption         =   toCaption     config;
                        description     =   toDescription config;
                        label           =   null;
                        numbers         =   false;
                        dependencies    =   [];
                      };
                  set
                  =   {
                        caption         =   toCaption     ( config.caption     or config.description or "" );
                        description     =   toDescription ( config.description or config.caption     or "" );
                        label           =   config.label        or null;
                        numbers         =   config.numbers      or false;
                        dependencies    =   config.dependencies or [];
                      };
                }
                //  {
                      body              =   list.expect body;
                    }
              );
      };
}