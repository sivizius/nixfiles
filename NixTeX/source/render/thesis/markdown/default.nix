{ core, ... } @ libs:
{ authors, configuration, content, date, dependencies, name, place, resources, thesis, ... } @ document:
  let
    inherit(core) indentation path;
    toMarkdown                          =   libs.document.toMarkdown { inherit configuration resources; };

    mainMatter                          =   toMarkdown ( content.mainMatter  or content.body        or null );

    content'
    =   indentation { initial = ""; tab = "  "; }
        (
          mainMatter
        );
    mdFile                              =   path.toFile "${name}.md" content';
  in
    document
    //  {
          content                       =   content';
          dependencies
          =   dependencies
          ++  [
                {
                  src                   =   mdFile;
                  dst                   =   "${name}.tex";
                }
              ];
        }
