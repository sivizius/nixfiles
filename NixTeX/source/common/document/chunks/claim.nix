# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug error string type;
    inherit(evaluator)  evaluate;
    inherit(renderer)   toBody render;

    evaluateClaim
    =   { ... } @ document:
        { bibliography, ... } @ state:
        { body, dependencies, reference, ... } @ claim:
          let
            state'                      =   evaluate document state body;
            cite
            =   type.matchPrimitiveOrPanic reference
                {
                  bool                  =   error.throw "Bool in evaluateClaim?";
                  list                  =   reference;
                  set                   =   [ reference ];
                  string                =   [ reference ];
                };
          in
            state'
            //  {
                  dependencies          =   state'.dependencies ++ dependencies;
                };

    renderClaim
    =   { ... } @ document:
        { body, reference, ... }:
        output:
          let
            cite
            =   type.matchPrimitiveOrPanic reference
                {
                  bool                  =   error.throw "Bool in renderClaim?";
                  list                  =   string.concatMappedWith ({ name, ... }: name) "," reference;
                  set                   =   reference.name;
                };
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
    Claim
    =   claim:
        reference:
          chunks.Chunk "Claim"
          {
            render                      =   renderClaim;
            evaluate                    =   evaluateClaim;
          }
          {
            body                        =   toBody claim;
            dependencies                =   [];
            inherit reference;
          };
  }
