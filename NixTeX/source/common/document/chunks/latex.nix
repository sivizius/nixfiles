{ chunks, core, evaluator, renderer, ... }:
let
  inherit(core)       debug error indentation list string type;
  inherit(evaluator)  evaluate;
  inherit(renderer)   toBody render;

  evaluateLaTeX
  =   { ... } @ document:
      { ... } @ state:
      { dependencies, lines, ... }:
        let
          state'
          =   list.fold
              (
                state:
                chunk:
                  type.matchPrimitiveOrPanic chunk
                  {
                    lambda              =   error.throw "Lambda in evaluateLaTeX?";
                    bool                =   error.throw "Bool in evaluateLaTeX?";
                    null                =   state;
                    set
                    =   if indentation.isInstanceOf chunk
                        then
                          state
                        else
                          evaluate document state chunk;
                    string              =   state;
                  }
              )
              state
              lines;
        in
          state'
          //  {
                dependencies            =   state'.dependencies ++ dependencies;
              };

  renderLaTeX
  =   document:
      { lines, ... }:
      output:
        if output == "LaTeX"
        then
          list.concatMap
          (
            chunk:
              type.matchPrimitiveOrPanic chunk
              {
                bool                    =   error.throw "Bool in renderLaTeX?";
                null                    =   [ chunk ];
                set                     =   if indentation.isInstanceOf chunk then [ chunk ] else render document chunk;
                string                  =   [ chunk ];
              }
          )
          lines
        else if output == "Markdown"
        then
          []
        else
          debug.panic "render" "Unknown output ${output}";
  LaTeX'
  =   lines:
      {
        dependencies ? [],
        ...
      }:
        chunks.Chunk "LaTeX"
        {
          render                        =   renderLaTeX;
          evaluate                      =   evaluateLaTeX;
        }
        (
          {
            inherit dependencies;
            lines
            =   type.matchPrimitiveOrPanic lines
                {
                  string                =   string.splitLines lines;
                  list                  =   lines;
                };
          }
        );
in
{
  inherit LaTeX';
  LaTeX                                 =   lines: LaTeX' lines {};
}