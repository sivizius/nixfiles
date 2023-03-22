{ core, ... } @ libs:
  let
    inherit(core) library;

    getFormat
    =   outputFormat:
          if outputFormat != null
          then
            outputFormat
          else
            "tex";
    renderTex                           =   library.import ./tex      libs;
    renderMarkdown                      =   library.import ./markdown libs;
  in
  {
    evaluationOrder
    =   [
          "titleMatter"
          "frontMatter"
          "mainMatter"
          "appendix"
          "backMatter"
        ];
    render
    =   outputFormat:
        {
          "tex"                         =   renderTex;
          "markdown"                    =   renderMarkdown;
        }.${getFormat outputFormat};
  }
