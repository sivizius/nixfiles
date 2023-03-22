# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug indentation list string type;
    inherit(evaluator)  evaluate;
    inherit(renderer)   putCaption toBody toTitle render;

    evaluateSlide
    =   { ... } @ document:
        { ... } @ state:
        { body, dependencies, notes, ... } @ slide:
          let
            state'                      =   evaluate document state body;
            label                       =   state'.notes.label + 1;
            label'                      =   string label;
            pages
            =   list.imap
                (
                  overlay:
                  note:
                  {
                    inherit note overlay;
                    label               =   label';
                  }
                )
                notes;
          in
            state'
            //  {
                  dependencies          =   state'.dependencies ++ dependencies;
                  notes
                  =   state'.notes
                  //  {
                        inherit label;
                        pages           =   state'.notes.pages ++ pages;
                      };
                };

    renderSlide
    =   {  ... } @ document:
        { align, body, notes, ... } @ slide:
        output:
          [ "\\begin{frame}[${align}]" indentation.more ]
          ++  ( render document body )
          ++  (list.ifOrEmpty (notes != [] && notes != null) "\\only<1-${string (list.length notes)}>{}%")
          ++  [ indentation.less "\\end{frame}" ];

    Slide
    =   {
          align         ? "c",
          dependencies  ? [],
          notes         ? [],
        }:
        body:
          chunks.Chunk "Slide"
          {
            render                      =   renderSlide;
            evaluate                    =   evaluateSlide;
          }
          {
            inherit align dependencies notes;
            body                        =   toBody  body;
          };
  in
    { inherit Slide; }