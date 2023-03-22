# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug list;
    inherit(evaluator)  evaluate;
    inherit(renderer)   toBody render;

    evaluatePhantomHeading
    =   { ... } @ document:
        { ... } @ state:
        { body, dependencies, ... } @ heading:
          let
            state'                      =   evaluate document state body;
          in
            state'
            //  {
                  dependencies          =   state'.dependencies ++ dependencies;
                };

    renderPhantomHeading
    =   { level, ... } @ document:
        { body, ... } @ heading:
        output:
          render
            (
              document
              //  {
                    level               =   list.tailOr level [];
                  }
            )
            body;

    PhantomHeading
    =   body:
          chunks.Chunk "PhantomHeading"
          {
            render                      =   renderPhantomHeading;
            evaluate                    =   evaluatePhantomHeading;
          }
          {
            body                        =   toBody body;
            dependencies                =   [];
          };
  in
    { inherit PhantomHeading; }