# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug error indentation list number path set string type;
    inherit(evaluator)  evaluate;
    inherit(renderer)   putCaption toCaption toDescription render;

    evaluateFigure
    =   { ... } @ document:
        { ... } @ state:
        { dependencies, ... } @ figure:
          let
            state'                      =   state;
          in
            state'
            //  {
                  dependencies          =   state'.dependencies ++ dependencies;
                  figures
                  =   state'.figures
                  //  {
                        counter         =   state'.figures.counter + 1;
                      };
                };

    getOptions
    =   config:
              ( if config ? width                   then [ "width=${string config.width}"             ] else [ ] )
          ++  ( if config ? height                  then [ "height=${string config.height}"           ] else [ ] )
          ++  ( getOptions' config );

    getOptions'
    =   config:
              ( if config ? totalheight             then [ "totalheight=${string config.totalheight}" ] else [ ] )
          ++  ( if config.keepaspectratio or false  then [ "keepaspectratio"                          ] else [ ] )
          ++  ( if config ? scale                   then [ "scale=${string config.scale}"             ] else [ ] )
          ++  ( if config ? angle                   then [ "angle=${string config.angle}"             ] else [ ] )
          ++  ( if config ? origin                  then [ "origin=${string config.origin}"           ] else [ ] )
          ++  ( if config ? viewport                then [ "viewport=${string config.viewport}"       ] else [ ] )
          ++  ( if config ? trim                    then [ "trim=${string config.trim}"               ] else [ ] )
          ++  ( if config.clip or false             then [ "clip"                                     ] else [ ] )
          ++  ( if config ? page                    then [ "page=${string config.page}"               ] else [ ] )
          ++  ( if config ? pagebox                 then [ "pagebox=${string config.pagebox}"         ] else [ ] )
          ++  ( if config.interpolate or false      then [ "interpolate"                              ] else [ ] )
          ++  ( if config.quiet or false            then [ "quiet"                                    ] else [ ] )
          ++  ( if config.draft or false            then [ "draft"                                    ] else [ ] )
          ++  ( if config ? type                    then [ "type=${string config.type}"               ] else [ ] )
          ++  ( if config ? ext                     then [ "ext=${string config.ext}"                 ] else [ ] )
          ++  ( if config ? read                    then [ "read=${string config.read}"               ] else [ ] )
          ++  ( if config ? command                 then [ "command=${string config.command}"         ] else [ ] )
          ++  ( config.extraOptions or [] );

    orDefault
    =   first:
        second:
          if first != null
          then
            first
          else
            second;

    mapSubfigure
    =   {
          align       ? "b",
          body        ? null,
          caption     ? null,
          cite        ? null,
          description ? null,
          file        ? null,
          height      ? null,
          label       ? null,
          plot        ? null,
          uncover     ? null,
          only        ? null,
          width       ? null,
          ...
        } @ config:
          {
            caption                     =   null;
            description                 =   toDescription ( orDefault description caption);
            inherit align cite label height width uncover only;
          }
          //  (
                if file != null
                then
                {
                  body                  =   null;
                  file
                  =   type.matchPrimitiveOrPanic file
                      {
                        path            =   file;
                        string          =   file;
                      };
                  options               =   getOptions' config;
                  plot                  =   null;
                }
                else if plot != null
                then
                {
                  body                  =   null;
                  file                  =   null;
                  options               =   null;
                  inherit plot;
                }
                else if body != null
                then
                {
                  file                  =   null;
                  options               =   null;
                  plot                  =   null;
                  inherit body;
                }
                else
                  error.unimplemented
              );

    mapSubfigures
    =   list.map
        (
          config:
            if config != null
            then
              mapSubfigure config
            else
              config
        );

    # { ... } -> Document::Chunk::Figure -> [ string | Indentation ]
    renderFigure
    =   _:
        { label ? null, subfigures ? null, environment, ... } @ figure:
        output:
          let
            render
            =   { body, file, options, uncover, only, ... }:
                  let
                    uncover'
                    =   text:
                          if uncover != null
                          then
                            [
                              "\\uncover<${uncover}>{%" indentation.more
                                "\\alt<${uncover}>{%" indentation.more
                                  "${text}%"
                                indentation.less "}{%" indentation.more
                                  "\\begin{tikzpicture}%" indentation.more
                                    "\\node[anchor=south west,inner sep=0] (B) at (4,0) {${text}};%"
                                    "\\fill [draw=none, fill=white, fill opacity=0.9] (B.north west) -- (B.north east) -- (B.south east) -- (B.south west) -- (B.north west) -- cycle;%"
                                  indentation.less "\\end{tikzpicture}%"
                                indentation.less "}%"
                              indentation.less "}%"
                            ]
                          else if only != null
                          then
                            [
                              "\\only<${only}>{%" indentation.more
                              "${text}%"
                              indentation.less "}%"
                            ]
                          else
                            [ text ];
                  in
                    if file != null
                    then
                      if options != [ ]
                      then
                        uncover' "\\includegraphics[${string.concatWith "," options}]{\\source/${file}}"
                      else
                        uncover' "\\includegraphics[width=\\linewidth]{\\source/${file}}"
                    else
                      body;
          in
            if output == "LaTeX"
            then
              [
                "\\begin{${environment}}[H]%" indentation.more
                "\\centering%"
              ]
              ++  (
                    if subfigures != null
                    then
                      let
                        convert
                        =   { align, label ? null, width, ... } @ figure:
                            [
                              "\\begin{subfigure}[${align}]{${width}}" indentation.more
                              "\\centering"
                            ]
                            ++  ( render figure )
                            ++  ( putCaption figure )
                            ++  ( if label != null then [ "\\label{${label}}" ] else [] )
                            ++  [ indentation.less "\\end{subfigure}" ];
                      in
                        list.concatMap
                        (
                          figure:
                          (
                            if figure != null
                            then
                              convert figure
                            else
                              [ "\\hfill" ]
                          )
                        )
                        subfigures
                    else
                      render figure
                  )
              ++  ( putCaption figure )
              ++  (
                    if label != null
                    then
                      [ "\\labelFigure{${label}}%" ]
                    else
                      [ ]
                  )
              ++  [ indentation.less "\\end{${environment}}%" ]
          else if output == "Markdown"
          then
            []
          else
            debug.panic "render" "Unknown output ${output}";

    choose
    =   list.fold
        (
          result:
          item:
            if result == null
            then
              item
            else
              result
        )
        null;
  in
  {
    # set | string -> list -> list -> Document::Chunk::Figure
    Figure
    =   {
          body          ? null,
          caption       ? null,
          cite          ? null,
          dependencies  ? [],
          description   ? null,
          file          ? null,
          height        ? null,
          label         ? null,
          plot          ? null,
          uncover       ? null,
          subfigures    ? null,
          width         ? null,
          only          ? null,
          environment   ? "figure",
        } @ config:
          chunks.Chunk "Figure"
          {
            render                      =   renderFigure;
            evaluate                    =   evaluateFigure;
          }
          (
            {
              caption                   =   toCaption     ( choose [ caption description "" ] );
              description               =   toDescription ( choose [ description caption "" ] );
              inherit cite label height width uncover only environment;
            }
            //  (
                  if file != null
                  then
                    let
                      file'
                      =   type.matchPrimitiveOrPanic file
                          {
                            path        =   "resources/figures/${path.getBaseName file}";
                            string      =   file;
                          };
                    in
                    {
                      body              =   null;
                      file              =   file';
                      options           =   getOptions config;
                      subfigures        =   null;
                      dependencies
                      =   dependencies
                      ++  (
                            type.matchPrimitiveOrPanic file
                            {
                              path      =   [ { src = "${file}"; dst = "resources/figures/${path.getBaseName file}"; } ];
                              string    =   [];
                            }
                          );
                    }
                  else if plot != null
                  then
                    let
                      toPlot
                      =   data:
                            type.matchPrimitiveOrPanic data
                            {
                              bool      =   error.throw "Bool in renderFigure?";
                              path      =   "\"${data}\" notitle with lines lt rgb \"0x00777777\"";
                              string    =   "${data} notitle with lines lt rgb \"0x00777777\"";
                              set
                              =   (
                                    let
                                      plot
                                      =   if data.file or null != null
                                          then
                                            "\"${data.file}\""
                                          else if data.eq or null != null
                                          then
                                            data.eq
                                          else
                                            error.unimplemented;
                                      title
                                      =   if data.title or null != null
                                          then
                                            "title \"${data.title}\""
                                          else
                                            "notitle";
                                      lines
                                      =   if data.lines or true
                                          then
                                            "with lines lt"
                                          else
                                            "";
                                      colour
                                      =   if data.colour or null != null
                                          then
                                            data.colour
                                          else
                                            "0x00777777";
                                    in
                                      "${plot} ${title} ${lines} rgb \"${colour}\""
                                  );
                            };
                      plots
                      =   if list.isInstanceOf plot.data
                          then
                            string.concatCSV ( list.map toPlot plot.data )
                          else
                            toPlot plot.data;

                      genPeaks
                      =   list.map
                          (
                            {
                              x, y,
                              z       ?   0,
                              colour  ?   "0x00aaaaaa",
                              text    ?   null,
                            }:
                              let
                                x'
                                =   if set.isInstanceOf x
                                    then
                                      ( x.from + x.till ) / 2
                                    else
                                      x;
                                x''     =   string (number.round x');
                                y'      =   string y;
                                z'      =   string (number.round ( x' + z ));
                                z''     =   string (number.round ( x' + z - 60 ));
                              in
                                if plot.peaksTop or true
                                then
                                  ''
                                    set arrow from first ${x''}, graph 0.8 to first ${x''}, first ${y'} nohead lc rgb "${colour}"
                                    set arrow from first ${x''}, graph 0.8 to first ${z'}, graph 0.87 nohead lc rgb "${colour}"
                                    set label "\\tiny ${x''}" right rotate by 90 at first ${z'}, graph 0.88
                                    ${if text != null then ''set label "\\tiny (${text})" right rotate by 90 at first ${z''}, graph 0.88'' else ""}
                                  ''
                                else
                                  ''
                                    set arrow from first ${x''}, graph 0.2 to first ${x''}, first ${y'} nohead lc rgb "${colour}"
                                    set arrow from first ${x''}, graph 0.2 to first ${z'}, graph 0.13 nohead lc rgb "${colour}"
                                    set label "\\tiny ${x''}" right rotate by 90 at first ${z'}, graph 0.12
                                    ${if text != null then ''set label "\\tiny (${text})" right rotate by 90 at first ${z''}, graph 0.12'' else ""}
                                  ''
                          );

                      formatRange       =   { min, max }: "[${string min}:${string max}]";
                      body
                      =   string.concatLines
                          (
                            []
                            ++  ( if plot.title   or null != null then  [ "set title \"{\\\\footnotesize{${plot.title}}}\"" ] else  [ "unset title" ] )
                            ++  ( if plot.xLabel  or null != null then  [ "set xlabel \"{\\\\small{${plot.xLabel}}}\""      ] else  [ "unset xlabel" ] )
                            ++  ( if plot.yLabel  or null != null then  [ "set ylabel \"{\\\\small{${plot.yLabel}}}\""      ] else  [ "unset ylabel" ] )
                            ++  ( if plot.xRange  or null != null then  [ "set xrange ${formatRange plot.xRange}"           ] else  [] )
                            ++  ( if plot.yRange  or null != null then  [ "set yrange ${formatRange plot.yRange}"           ] else  [] )
                            ++  ( if plot.xTics   or true         then  [ "set xtics in"                                    ] else  [ "unset xtics" ] )
                            ++  ( if plot.yTics   or true         then  [ "set ytics in"                                    ] else  [ "unset ytics" ] )
                            ++  ( if plot.keyPos  or null != null then  [ "set key ${plot.keyPos}"                          ] else  [] )
                            ++  ( if plot.peaks   or null != null then  genPeaks plot.peaks else [] )
                            ++  [
                                  "plot ${plots}"
                                  "set output"
                                ]
                          );
                      hash              =   string.hash "sha1" body;
                      dst               =   "generated/gnuplot/${hash}-plot";
                      epsFile           =   "${dst}.eps";
                      texFile           =   "${dst}.tex";
                      gnuplotSrcFile
                      =   path.toFile "${hash}.gnuplot"
                          ''
                            set terminal epslatex size ${string width},${string ( if height != null then height else width )}
                            set output "${epsFile}"
                            ${body}
                          '';
                      gnuplotDstFile    =   "${dst}.gnuplot";

                      src
                      =   output:
                            string.concatWith " && "
                            [
                              "(mkdir -p \"generated/gnuplot/\""
                              "gnuplot \"${gnuplotSrcFile}\""
                              "mv \"${texFile}\" \"${output}.tex\""
                              "epstopdf \"${epsFile}\" \"${output}.pdf\")"
                            ];

                    in
                    {
                      body              =   [ "{\\input{\\source/${texFile}}}%" ];
                      file              =   null;
                      options           =   null;
                      subfigures        =   null;
                      dependencies
                      =   dependencies
                      ++  [
                            { src = gnuplotSrcFile; dst = gnuplotDstFile; }
                            { inherit dst src; }
                          ];
                    }
                  else if body != null
                  then
                  {
                    body                =   list.expect body;
                    file                =   null;
                    options             =   null;
                    subfigures          =   null;
                    inherit dependencies;
                  }
                  else if subfigures != null
                  then
                  {
                    body                =   null;
                    file                =   null;
                    options             =   null;
                    subfigures          =   mapSubfigures ( list.expect subfigures );
                    inherit dependencies;
                  }
                  else
                    error.unimplemented
                )
          );
  }