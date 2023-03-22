# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)   debug;

    evaluatePage
    =   { ... } @ document:
        { ... } @ state:
        { body, ... }:
          state;

    renderClearPage
    =   { ... } @ document:
        { body, ... }:
        output:
          if output == "LaTeX"
          then
            [ body ]
          else if output == "Markdown"
          then
            []
          else
            debug.panic "render" "Unknown output ${output}";
  in
  {
    ClearPage
    =   chunks.Chunk "ClearPage"
        {
          render                        =   renderClearPage;
          evaluate                      =   evaluatePage;
        }
        {
          body                          =   "\\clearpage";
        };
  }