{ core, fork-awesome, nixpkgs, stdenv, ... } @ libs:
  let
    inherit(core) debug lambda library list path set string target type;
    nixtex                              =   library.import ./source libs;

    collectDependencies#: Dependencies -> Dependencies | !
    =   list.fold
        (
          { ... } @ state:
          { dst, src ? null }:
            if      src == null || dst == null        then  state
            else if state.${dst} or null == null      then  state // { ${dst} = src; }
            else if state.${dst} == src               then  state
            else if lambda.isInstanceOf state.${dst}
            &&      lambda.isInstanceOf src           then  state # Cannot compae tasks :c
            else
              debug.panic "collectDependencies"
                "Cannot set ${dst}, because it is already set!"
        )
        {};

    collectDirectories#: { string -> { ... } } -> { string -> null }
    =   set.fold
        (
          { ... } @ directories:
          dst:
          src:
            let
              directory                 =   path.getDirectory dst;
            in
              if directory != "."
              then
                directories
                //  {
                      ${directory}      =   null;
                    }
              else
                directories
        )
        {};

    collectFileSet
    =   { local ? null, store ? null, ... }:
          if local != null
          then
            path.toStore local
          else if store != null
          then
            store
          else
            null;

    collectFiles#: { string -> { path: string | path ? null ... } | string } -> [ string ]
    =   set.fold
        (
          files:
          dst:
          src:
            type.matchPrimitiveOrPanic src
            {
              lambda                    =   files; # Ignore Tasks
              path                      =   files ++ [ { src = path.toStore src; inherit dst; } ];
              set
              =   let
                    src'                =   collectFileSet src;
                  in
                    if src' != null
                    then
                      files ++ [ { src = src'; inherit dst; } ]
                    else
                      files;
              string
              =   debug.warn
                    "collectFiles"
                    {
                      text              =   "I assume, that »${src}« is in the nix-store.";
                      when              =   string.getContext src == {};
                    }
                    ( files ++ [ { inherit dst src; } ] );
            }
        )
        [];

    collectTasks#: { string -> { cmd: string -> string ? null, ... } | string } -> [ string ]
    =   set.fold
        (
          tasks:
          dst:
          src:
            if  set.isInstanceOf src
            &&  src.cmd or null != null
            then
              tasks ++ [ (src.cmd "$out/${dst}") ]
            else if lambda.isInstanceOf src
            then
              tasks ++ [ (src "$out/${dst}") ]
            else
              tasks
        )
        [];

    toDerivation#: System -> Document -> derivation
    =   system:
        { name, dependencies, ... }:
          let
            system'                     =   string system;
            pkgs                        =   nixpkgs.legacyPackages.${system'};

            dependencies'               =   collectDependencies dependencies;
            directories
            =   list.map
                  (dictionary: "mkdir -p \"$out/${dictionary}\"")
                  (set.names (collectDirectories dependencies'));
            links
            =   list.map
                  ({ dst, src }: "ln -s \"${src}\" \"$out/${dst}\"")
                  (collectFiles dependencies');
            tasks                       =   collectTasks dependencies';

            builder
            =   path.toFile "builder.sh"
                ''
                  #!/usr/bin/env bash
                  source $stdenv/setup
                  export HOME=$(mktemp -d)

                  # ensure that all output directories exist
                  mkdir -p "$out"
                  ln -s "$out" ./
                  ${string.concatLines directories}

                  # link already generated files
                  ${string.concatLines links}

                  # generate some more files
                  ${string.concatLines tasks}

                  mkdir -p "$out/fonts/"
                  fc-list -f "%{file}\n" | while read fileName
                  do
                    base="$(basename "$fileName")"
                    link="$(echo "$base" | sed "s/ /-/g")"
                    ln -s "$fileName" "$out/fonts/$link"
                  done

                  # compile document
                  bash $out/compile-${name}.sh "$out"
                '';

            FONTCONFIG_FILE
            =   pkgs.makeFontsConf
                {
                  fontDirectories
                  =   with pkgs;#in
                      [
                        #dejavu_fonts
                        font-awesome
                        fork-awesome.packages.${system'}.default
                        #"${ghostscript}/share/ghostscript/fonts"
                        liberation_ttf
                        #lmodern
                        noto-fonts
                        #noto-fonts-emoji
                        #noto-fonts-extra
                        roboto
                        roboto-mono
                        roboto-slab
                        unifont
                      ];
                };
          in
            debug.info "toDerivation"
            {
              text                      =   "builder";
              data                      =   builder;
            }
            stdenv.${system'}.mkDerivation
            {
              inherit name builder;
              system                    =   system';
              buildInputs
              =   with pkgs;#in
                  [
                    exa
                    fontconfig
                    ghostscript                     # for gs
                    gnuplot
                    ncurses                         # for tput
                    texlive.combined.scheme-full    # for lualatex
                  ];
              inherit FONTCONFIG_FILE;
            };

    mapToDerivations#: System -> [ Document ] -> { string -> derivation }
    =   system:
        documents:
          let
            toDerivation'               =   toDerivation system;
          in
            (
              list.fold
                (
                  { ... } @ documents':
                  { name, ... } @ document:
                    documents'
                    //  {
                          ${name}       =   toDerivation' document;
                        }
                )
                {}
                documents
            );

    mapToPackages#: [ Document ] -> { ... } -> { string -> derivation }
    =   documents:
        { ... } @ environment:
          target.System.mapStdenv
          (
            system:
              mapToDerivations system
              (
                list.map
                  (
                    documentPath:
                      library.import documentPath ( { inherit core nixtex; } // environment ) "tex"
                  )
                  documents
              )
          );
  in
    nixtex
    //  {
          inherit mapToDerivations mapToPackages toDerivation;
        }
