{ bibliography, chemistry, core, document, glossaries, ... } @ libs:
{ configuration, content, date, dependencies, language ? "eng", name, place, resources, ... } @ document:
  let
    inherit(core) debug indentation library list path string time;

    renderBeginDocument                 =   library.import ./beginDocument.nix  libs';
    renderEnclosures                    =   library.import ./enclosures.nix     libs';
    renderLetter                        =   library.import ./letter.nix         libs';
    renderPrelude                       =   library.import ./prelude.nix        libs';
    renderResume                        =   library.import ./resume             libs';

    libs'
    =   libs
    //  {
          toTex                         =   libs.document.toTex { inherit configuration language resources; };
        };

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
          "symbols"
          "text/text"
          "utils"
        ];

    acronyms                            =   glossaries.acronyms.toLua   { inherit configuration resources; };
    references                          =   bibliography.toBibTeX       { inherit configuration resources; }  resources.references;
    substances                          =   chemistry.substances.toLua  { inherit configuration resources; }  resources.substances;

    prelude
    =   {
          acronyms                      =   acronyms.dst;
          assets                        =   "assets/";
          packages                      =   list.map (name: "\\input{\\source/source/${name}.tex}") packages;
          references                    =   references.dst;
          source
          =   {
                lua                     =   "source/lua/";
                tex                     =   "source/";
              };
          substances                    =   substances.dst;
          inherit(resume) publications;
        };

    letter
    =   {
          inherit(document) configuration date language place;
          sender
          =   {
                inherit(resume) name social;
              };
          subject                       =   document.title;
        }
    //  (path.import content.letter libs' document);
    resume
    =   {
          inherit(document) date language place;
        }
    //  (path.import content.resume libs' document);

    pdfMeta
    =   {
          author                        =   "${resume.name.given} ${resume.name.family}";
          title
          =   "${document.title} ${{ deu = "am"; eng = "on"; }.${language}} ${time.formatDate document.date language}";
          subject
          =   {
                deu                     =   "Bewerbung";
                eng                     =   "Application";
              }.${language};
        };

    enclosures
    =   {
          inherit(document) language;
          inherit(letter) enclosures;
        };

    content'
    =   indentation { initial = ""; tab = "  "; }
        (
          []
          ++  ( renderPrelude       prelude           )
          ++  [ "\\begin{document}" indentation.more  ]
          ++  ( renderBeginDocument pdfMeta           )
          ++  list.ifOrEmpty'
                ((configuration.application or {}).letter or true)
                ( renderLetter        letter            )
          ++  list.ifOrEmpty'
                ((configuration.application or {}).resume or true)
                ( renderResume        resume            )
          ++  list.ifOrEmpty'
                ((configuration.application or {}).enclosures or true)
                ( renderEnclosures    enclosures        )
          ++  [ "\\directlua{commonFinal()}"          ] # ToDo: Remove!
          ++  [ indentation.less "\\end{document}"    ]
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
          echo "$out/${name}.tex"
          #exit 0

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
    texFile                             =   path.toFile "${name}.tex" content';
  in
    document
    //  {
          content                       =   content';
          dependencies
          =   dependencies
          ++  [
                acronyms
                references
                substances
                {
                  src                   =   texFile;
                  dst                   =   "${name}.tex";
                }
                {
                  src                   =   { store = compile; executable = true; };
                  dst                   =   "compile-${name}.sh";
                }
              ];
        }
