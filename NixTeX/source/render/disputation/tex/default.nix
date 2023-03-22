{ bibliography, chemistry, core, document, glossaries,... } @ libs:
  let
    inherit(core) debug indentation library list path string;

    libs'
    =   libs
    //  {
          formatAuthor
          =   author:
                "${author.forename} ${author.surname}";
        };

    renderExtra                         =   library.import ./extra.nix    libs';
    renderPrelude                       =   library.import ./prelude.nix  libs';
    renderSlides                        =   library.import ./slides.nix   libs';
    renderTitle                         =   library.import ./title.nix    libs';
  in
    { authors, configuration, content, date, dependencies, name, place, resources, disputation, ... } @ document:
      let
        style                           =   (library.import ./styles libs').${disputation.style};
        document'                       =   document // { inherit style; };
        toTex                           =   libs.document.toTex { inherit configuration resources; };

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

        acronyms                        =   glossaries.acronyms.toLua   { inherit configuration resources; };
        references                      =   bibliography.toBibTeX       { inherit configuration resources; }  resources.references;
        substances                      =   chemistry.substances.toLua  { inherit configuration resources; }  resources.substances;

        prelude
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

        content'
        =   indentation { initial = ""; tab = "  "; }
            (
              []
              ++  ( renderPrelude       document' prelude                             )
              ++  [ "\\begin{document}" indentation.more ]
              ++  ( renderTitle         document'                                     )
              ++  ( renderSlides        document' ( toTex content.slides  or  null  ) )
              ++  ( renderExtra         document' ( toTex content.extra   or  null  ) )
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
              exit 0
            '';
        texFile                         =   path.toFile "${name}.tex" content';
      in
        document'
        //  {
              content                   =   content';
              dependencies
              =   dependencies
              ++  [
                    acronyms
                    references
                    substances
                    {
                      src               =   texFile;
                      dst               =   "${name}.tex";
                    }
                    {
                      src               =   { store = compile; executable = true; };
                      dst               =   "compile-${name}.sh";
                    }
                  ];
            }
