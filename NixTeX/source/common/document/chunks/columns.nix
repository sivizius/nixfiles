# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug error string type;
    inherit(evaluator)  evaluate;
    inherit(renderer)   toBody render;

    evaluateColumns
    =   { ... } @ document:
        { bibliography, ... } @ state:
        { body, dependencies, reference, ... } @ columns:
          let
            state'                      =   evaluate document state body;
          in
            state'
            //  {
                  dependencies          =   state'.dependencies ++ dependencies;
                };

    renderColumns
    =   { ... } @ document:
        { body, reference, ... }:
        output:
          let
            body'
            =   if reference != null
                then
                  if output == "LaTeX"
                  then
                    chunks.addToLastItem body "\\cite{${cite}}"
                  else if output == "Markdown"
                  then
                    body
                  else
                    []
                else
                  body;
          in
            render document body';
  in
  {
    Columns
    =   { amount, }:
          chunks.Chunk "Columns"
          {
            render                      =   renderColumns;
            evaluate                    =   evaluateColumns;
          }
          {
            body                        =   toBody claim;
            dependencies                =   [];
          };
  }
