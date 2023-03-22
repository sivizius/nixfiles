# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug indentation list string type;
    inherit(chunks)     declare;
    inherit(evaluator)  evaluate;
    inherit(renderer)   putCaption toBody toTitle render;

    evaluateSection
    =   { ... } @ document:
        { level ? 0, notes, ... } @ state:
        { body, title, ... } @ section:
          let
            state'
            =   state
            //  {
                  level                 =   level + 1;
                  notes
                  =   notes
                  //  {
                        pages
                        =   notes.pages
                        ++  [
                              {
                                inherit level;
                                title   =   title.caption;
                              }
                            ];
                      };
                };
            state''                     =   evaluate document state' body;
          in
            state'' // { inherit level; };

    renderSection
    =   { nested ? false, ... } @ document:
        { body, title, ... } @ section:
        output:
          [ "\\${if nested then "sub" else ""}section{" indentation.more ]
          ++  title.caption
          ++  [ indentation.less "}" ]
          ++  ( render ( document // { nested = true; } ) body );

    Section
    =   title:
        body:
          chunks.Chunk "Section"
          {
            render                      =   renderSection;
            evaluate                    =   evaluateSection;
          }
          {
            body                        =   toBody  body;
            title                       =   toTitle title false;
          };
  in
    { inherit Section; }