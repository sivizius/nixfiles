# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug indentation list string type;
    inherit(evaluator)  evaluate;
    inherit(renderer)   putCaption toBody toTitle render;

    evaluateHeading
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

    renderHeading
    =   { level, ... } @ document:
        { before, body, clearDoublePage, clearPage, clearPageOnLastQuarter, concise, label, rotate, title, ... } @ heading:
        output:
          let
            body'                         =   render (document // { level = list.tailOr level []; }) body;
            level'                        =   list.headOr level "paragraph";
          in
            if output == "LaTeX"
            then
              let
                label'
                =   if label != null
                    then
                      [ "\\label{${label}}%" ]
                    else
                      [ ];
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
                    else if clearPageOnLastQuarter
                    then
                      [ "\\clearPageOnLastQuarter%" ]
                    else
                      [];
                rotate'
                =   if rotate
                    then
                      [ "\\rotatePages%" ]
                    else
                      [ "\\unrotatePages%" ];
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
                before' ++ clearPage' ++ rotate' ++ label' ++ header' ++ body'
            else if output == "Markdown"
            then
              let
                level''
                =   {
                      chapter           =   "# ";
                      section           =   "## ";
                      subsection        =   "### ";
                      subsubsection     =   "#### ";
                    }.${level'} or "";
              in
                [
                  "${level''}${string.concatWords title.caption}"
                ]
                ++  body'
            else
              [];

    Heading                             =   title: body: Heading' title body {};
    Heading'
    =   title:
        body:
        {
          after           ? null,
          before          ? null,
          clearDoublePage ? false,
          clearPage       ? false,
          clearPageOnLastQuarter  ? false,
          concise         ? false,
          dependencies    ? [],
          label           ? null,
          LaTeX           ? false,
          rotate          ? false,
        }:
          chunks.Chunk "Heading"
          {
            render                      =   renderHeading;
            evaluate                    =   evaluateHeading;
          }
          {
            inherit after before clearDoublePage clearPage clearPageOnLastQuarter concise dependencies label rotate;
            title                       =   toTitle title LaTeX;
            body                        =   toBody  body;
          };
  in
    { inherit Heading Heading'; }