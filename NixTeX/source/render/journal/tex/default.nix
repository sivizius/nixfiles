{ bibliography, chemistry, core, glossaries,... } @ libs:
  let
    inherit(core) indentation path list string;
    libs'
    =   libs
    //  {
          journal
          =   {
                formatAuthor
                =   author:
                      let
                        author'         =   "${author.forename} ${author.surname}";
                        matched         =   string.match "[BM][.]?[A-Za-z.]+" author.title;
                      in
                        if author.title or null != null
                        then
                          if matched != null
                          then
                            "${author'} (${author.title})"
                          else
                            "${author.title} ${author'}"
                        else
                          author';
              };
        };

    appendix                            =   path.import ./appendix.nix       libs';
    beginDocument                       =   path.import ./beginDocument.nix  libs';
    frontMatter                         =   path.import ./frontMatter.nix    libs';
    mainMatter                          =   path.import ./mainMatter.nix     libs';
    prelude                             =   path.import ./prelude.nix        libs';
    titleMatter                         =   path.import ./titleMatter.nix    libs';
  in
    { configuration, content, dependencies, resources, style, ... } @ document:
      let
        document'
        =   document
        //  {
              style                     =   (path.import ./styles libs').${style};
            };
        toTex                           =   libs.document.toTex { inherit configuration resources; };

        #list.map (name: "\\input{${../tex/${name}.tex}}")

        packages
        =   [
              "logging"
              "dependencies"
              "chemistry/chem"
              "chemistry/elements"
              "bibliography/citation"
              "floats/floats"
              "fonts"
              "geometry"
              "glossaries/glossaries"
              "links"
              "numbers"
              "text/text"
              "utils"
            ];
        acronyms                        =   glossaries.acronyms.loadAcronyms    { inherit configuration resources; };
        references                      =   bibliography.loadReferences         { inherit configuration resources; };
        substances                      =   chemistry.substances.loadSubstances { inherit configuration resources; };

        preludeArguments
        =   {
              acronyms                  =   acronyms.dst;
              assets                    =   "assets/";
              packages                  =   list.map (name: "\\input{\\source/source/${name}.tex}") packages;
              references                =   references.dst;
              source
              =   {
                    lua                 =   "source/lua/";
                    tex                 =   "source/";
                  };
              substances                =   substances.dst;
            };
      in
        document'
        //  {
              content
              =   indentation { initial = ""; tab = "  "; }
                  (
                    []
                    ++  ( prelude       document' preludeArguments)
                    ++  [ "\\begin{document}" indentation.more ]
                    ++  ( beginDocument document' [])
                    ++  ( titleMatter   document' null)
                    ++  ( frontMatter   document' null)
                    ++  ( mainMatter    document' (toTex ( content.journal  or null )))
                    ++  ( appendix      document' (toTex ( content.appendix or null )))
                    ++  [ "\\directlua{commonFinal()}" ] # ToDo: Remove!
                    ++  [ indentation.less "\\end{document}" ]
                  );
              dependencies
              =   dependencies
              ++  [
                    acronyms
                    references
                    substances
                  ];
            }
