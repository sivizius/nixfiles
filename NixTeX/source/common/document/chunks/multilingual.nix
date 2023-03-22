{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug list type;
    inherit(evaluator)  evaluate;
    inherit(renderer)   render;

    evaluateMultilingual
    =   { language, ... } @ document:
        { ... } @ state:
        { ... } @ body:
          evaluate document state body.${language};

    renderMultilingual
    =   { language, ... } @ document:
        { ... } @ body:
        output:
          render document body.${language};
  in
  {
    Multilingual
    =   { ... } @ body:
          chunks.Chunk "Multilingual"
          {
            render                      =   renderMultilingual;
            evaluate                    =   evaluateMultilingual;
          }
          body;
  }