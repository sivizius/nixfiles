# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug list;
    inherit(evaluator)  evaluateLine;
    inherit(renderer)   toLines;

    evaluateParagraph
    =   { ... }:
        { ... } @ state:
        { body, dependencies, ... }:
          let
            state'                      =   list.fold evaluateLine state body;
          in
            state'
            //  {
                  dependencies          =   state'.dependencies ++ dependencies;
                };

    # { ... } -> Paragraph -> [ string ]
    renderParagraph
    =   { ... }:
        { body, endParagraph, ...}:
        output:
          if output == "LaTeX"
          then
            chunks.addToLastItem body endParagraph
          else if output == "Markdown"
          then
            body
          else
            debug.panic "render" "Unknown output ${output}";

    # string | [ string ] -> Document::Chunk::Paragraph
    Paragraph                           =   body: Paragraph' body {};

    # string | [ string ] -> { ... } -> Document::Chunk::Paragraph
    Paragraph'
    =   body:
        {
          endParagraph ? "\\par",
        }:
          chunks.Chunk "Paragraph"
          {
            render                      =   renderParagraph;
            evaluate                    =   evaluateParagraph;
          }
          {
            inherit endParagraph;
            body                        =   toLines body;
            dependencies                =   [];
          };
  in
    { inherit Paragraph Paragraph'; }