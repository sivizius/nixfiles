# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug indentation list type;
    inherit(evaluator)  evaluate;
    inherit(renderer)   putCaption toBody toTitle render;

    evaluateJournal
    =   { ... } @ document:
        { ... } @ state:
        { body, dependencies, ... } @ journal:
          let
            state'                      =   evaluate document state body;
          in
            state'
            //  {
                  dependencies          =   state'.dependencies ++ dependencies;
                };

    renderJournal
    =   { level, ... } @ document:
        { before, body, clearDoublePage, clearPage, concise, label, rotate, title, ... } @ journal:
        output:
          let
            label'
            =   if label != null
                then
                  [ "\\label{${label}}%" ]
                else
                  [ ];
            level'                      =   list.headOr level "paragraph";
            header
            =   [ "\\${level'}[\\nolink{%" indentation.more ]
            ++  title.bookmark
            ++  [ indentation.less "}]{%" indentation.more ]
            ++  title.caption
            ++  [ indentation.less "}" ];
            header'
            =   if title.visible
                then
                  header
                else
                  [
                    "\\begingroup" indentation.more
                    "\\makeatletter\\let\\@makechapterhead\\@gobble\\makeatother"
                  ]
                  ++  header
                  ++  [ indentation.less "\\endgroup" ];
            clearPage'
            =   if  !concise
                &&  ( clearDoublePage || level' == "chapter" )
                then
                  [ "\\cleardoublepage%" ]
                else if clearPage
                then
                  [ "\\clearpage%" ]
                else
                  [ ];
            rotate'
            =   if rotate
                then
                  [ "\\rotatePages%" ]
                else
                  [ "\\unrotatePages%" ];
            body'                       =   render (document // { level = list.tailOr level []; }) body;
            before'
            =   if before == null
                then
                  [ ]
                else if list.isInstanceOf before
                then
                  before
                else
                  [ before ];
          in
            before' ++ clearPage' ++ rotate' ++ label' ++ header' ++ [ "{" indentation.more ] ++ body' ++ [ indentation.less "}" null ];
  in
  {
    Journal
    =   {
          __functor
          =   self:
              { ... }:
              {

              };
          Entry
          =   self:
              title:
              body:
              {
                after           ? null,
                before          ? null,
                clearDoublePage ? false,
                clearPage       ? false,
                concise         ? false,
                dependencies    ? [],
                label           ? null,
                LaTeX           ? false,
                rotate          ? false,
              }:
                chunks.Chunk "Journal"
                {
                  render                =   renderJournal;
                  evaluate              =   evaluateJournal;
                }
                {
                  inherit after before clearDoublePage clearPage concise dependencies label rotate;
                  title                 =   toTitle title LaTeX;
                  body                  =   toBody  body;
                };
        };
  }