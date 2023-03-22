{ bibliography, chemistry, core, document, glossaries,... } @ libs:
  let
    inherit(core) indentation library list path string time;

    formatAuthor
    =   author:
          let
            author'                     =   "${author.forename} ${author.surname}";
            matched                     =   string.match "[BM][.]?[A-Za-z.]+" author.title;
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

    libs'
    =   libs
    //  {
          thesis
          =   let
                cleardoublepage
                =   configuration:
                      if configuration.concise or false
                      then
                        "\\clearpage"
                      else
                        "\\cleardoublepage";

                formatAuthorTableLine   =   author: "& ${formatAuthor author}\\\\";

                thesisVersion
                =   version:
                    {
                      final             =   "Abgabe am";
                      draft             =   "Vorläufige Abgabe am";
                      revised           =   "Überarbeitet, Abgegeben am";
                    }.${version} or version;
              in
              {
                inherit cleardoublepage formatAuthor formatAuthorTableLine thesisVersion;
              };
        };

    renderAppendix                      =   library.import ./appendix.nix       libs';
    renderBackMatter                    =   library.import ./backMatter.nix     libs';
    renderBeginDocument                 =   library.import ./beginDocument.nix  libs';
    renderFrontMatter                   =   library.import ./frontMatter.nix    libs';
    renderMainMatter                    =   library.import ./mainMatter.nix     libs';
    renderPrelude                       =   library.import ./prelude.nix        libs';
    renderTitleMatter                   =   library.import ./titleMatter.nix    libs';
  in
    { authors, configuration, content, date, dependencies, name, place, resources, thesis, ... } @ document:
    let
      style                             =   (import ./styles libs').${thesis.style};
      document'                         =   document // { inherit style; };
      toTex                             =   libs.document.toTex { inherit configuration resources; };

      #list.map (name: "\\input{${../tex/${name}.tex}}")

      packages
      =   [
            "logging"
            "dependencies"
            "chemistry/chem"
            "chemistry/elements"
            "bibliography/citation"
            "floats/floats"
            "geometry"
            "glossaries/glossaries"
            "links"
            "text/text"
            "utils"
          ];
      acronyms                          =   glossaries.acronyms.toLua   { inherit configuration resources; };
      references                        =   bibliography.toBibTeX       { inherit configuration resources; }  resources.references;
      substances                        =   chemistry.substances.toLua  { inherit configuration resources; }  resources.substances;
      prelude
      =   {
            acronyms                    =   acronyms.dst;
            assets                      =   "assets/";
            packages                    =   list.map (name: "\\input{\\source/source/${name}.tex}") packages;
            references                  =   references.dst;
            source
            =   {
                  lua                   =   "source/lua/";
                  tex                   =   "source/";
                };
            substances                  =   substances.dst;
          };

      titleMatter                       =   toTex ( content.titleMatter or content.titlematter or null );
      frontMatter                       =   toTex ( content.frontMatter or content.frontmatter or null );
      mainMatter                        =   toTex ( content.mainMatter  or content.body        or null );
      appendix                          =   toTex ( content.appendix                           or null );

      originalityDeclaration
      =   if thesis.originalityDeclaration or null != null
          then
            "resources/${path.getBaseName thesis.originalityDeclaration}"
          else
            null;
      backMatter
      =   ( toTex ( content.backMatter  or content.backmatter  or null ) )
      ++  (
            if configuration.concise or false
            then
              [ ]
            else
              [ "\\cleardoublepage" ]
          )
      ++  (
            if originalityDeclaration == null
            then
              [
                "\\chapter*{Selbstständigkeitserklärung}{" indentation.more
                "\\addcontentsline{toc}{chapter}{Selbstständigkeitserklärung}"
                "\\markboth{Selbstständigkeitserklärung}{}"
              ]
              ++  ( style.originalityDeclaration document )
              ++  [ "\\par\\mbox{}\\\\${place}, den ${time.formatDate date "deu"}\\\\\\\\\\\\" ]
              ++  (
                    list.concatMap
                    (
                      { forename, surname, ... } @ author:
                      [
                        "\\parbox[][][t]{0.5\\hsize}"
                        "{"
                        "  \\begin{tabularx}{\\hsize}{@{}p{0.8\\hsize}@{}}"
                        "    ~~\\,\\dotfill\\\\"
                        "    ~~~${formatAuthor author} \\\\"
                        "  \\end{tabularx}"
                        "}"
                      ]
                    )
                    authors
                  )
              ++  [ indentation.less "}" ]
            else
              [
                "\\addcontentsline{toc}{chapter}{Selbstständigkeitserklärung}"
                "\\includepdf[pages={1}]{\\source/${originalityDeclaration}}"
              ]
          );

      content'
      =   indentation { initial = ""; tab = "  "; }
          (
            []
            ++  ( renderPrelude       document' prelude     )
            ++  [ "\\begin{document}" indentation.more ]
            ++  ( renderBeginDocument document' []          )
            ++  ( renderTitleMatter   document' titleMatter )
            ++  ( renderFrontMatter   document' frontMatter )
            ++  ( renderMainMatter    document' mainMatter  )
            ++  ( renderAppendix      document' appendix    )
            ++  ( renderBackMatter    document' backMatter  )
            ++  [ "\\directlua{commonFinal()}" ] # ToDo: Remove!
            ++  [ indentation.less "\\end{document}" ]
          );

      optimiser
      =   if configuration.optimise or false
          then
            ''
              # Optimise and linearise
              # This removes tooltips, sorry
              mv "${name}.pdf" "${name}-raw.pdf"
              gs                              \
              -dBATCH                         \
              -dColorImageResolution=288      \
              -dCompatibilityLevel=1.7        \
              -dDEBUG                         \
              -dDetectDuplicateImages         \
              -dDownsampleColorImages=true    \
              -dDownsampleGrayImages=true     \
              -dDownsampleMonoImages=true     \
              -dFastWebView                   \
              -dGrayImageResolution=288       \
              -dMonoImageResolution=288       \
              -dNOPAUSE                       \
              -dPDFSETTINGS=/ebook            \
              -dPrinted=false                 \
              -sDEVICE=pdfwrite               \
              -sOutputFile="${name}.pdf"      \
              "${name}-raw.pdf"               \
              > "${name}.gslog" 2>&1
            ''
          else
            "";

      compile
      =   path.toFile "compile-${name}.sh"
          ''
            #!/usr/bin/env bash
            newHash="false"
            oldHash="true"
            out="$1"

            counter=""
            while [[ "$newHash" != "$oldHash" && "$counter" != "${configuration.foo or "+++++"}" ]]
            do
              if  lualatex                  \
                  --interaction=nonstopmode \
                  --halt-on-error           \
                  --output-format=pdf       \
                  "\def\source{$out}\def\build{.}\input{$out/${name}.tex}" #2> /dev/null > /dev/null
              then
                oldHash="$newHash"
                newHash="$(md5sum "${name}.pdf")"
                echo "$newHash"
                mv "${name}.log" "$out/${name}.log"
                mv "${name}.llg" "$out/${name}.llg"
                biber "${name}"
                counter="+$counter"
              else
                exit 1
              fi
            done

            ${optimiser}
            # move the generated and processed document to the final-directory
            mv "${name}.pdf" "$out/${name}.pdf"
          '';
      texFile                           =   path.toFile "${name}.tex" content';
    in
      document'
      //  {
            content                     =   content';
            dependencies
            =   dependencies
            ++  [
                  acronyms
                  references
                  substances
                  {
                    src                 =   texFile;
                    dst                 =   "${name}.tex";
                  }
                  {
                    src                 =   { store = compile; executable = true; };
                    dst                 =   "compile-${name}.sh";
                  }
                ]
            ++  (
                  if originalityDeclaration != null
                  then
                    [ { src = thesis.originalityDeclaration; dst = originalityDeclaration; } ]
                  else
                    []
                );
          }
