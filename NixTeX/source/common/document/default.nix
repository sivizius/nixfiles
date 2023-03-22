{ core, ... } @ libs:
  let
    inherit(core) library;
    chunks                              =   library.import ./chunks       (libs // { inherit evaluator renderer; } );
    evaluator                           =   library.import ./evaluate.nix (libs // { inherit chunks; } );
    renderers                           =   library.import ./renderer     (libs // { inherit chunks; } );
    renderer                            =   renderers.LaTeX;
  in
    {
      inherit(evaluator) escapeEncode evaluate;
      toMarkdown
      =   { ... } @ document:
          body:
            if body != null
            then
              renderers.Markdown.render
              (
                document
                //  {
                      level             =   [ "chapter" "section" "subsection" "subsubsection" ];
                    }
              )
              body
            else
              [ ];
      toTex
      =   { ... } @ document:
          body:
            if body != null
            then
              renderers.LaTeX.render
              (
                document
                //  {
                      level             =   [ "chapter" "section" "subsection" "subsubsection" ];
                    }
              )
              body
            else
              [ ];
    }
    //  chunks.chunks
