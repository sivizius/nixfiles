{ core, document, ... } @ libs:
let
  inherit(core)     debug indentation lambda list number path set string type;
  inherit(document) ClearPage Heading' LaTeX PhantomHeading;

  getDetails
  =   minimum:
      peak:
        string.concatCSV
        (
          list.filter (x: x != null)
          [
            (
              let
                strength                =   ( 100.0 - peak.y ) / ( 100.0 - minimum ) * 1.2;
              in
                if      strength >= 0.7 then  "s"
                else if strength <= 0.3 then  "w"
                else                          "m"
            )
            (
              let
                assignment              =   "\\ch{${peak.assignment}}";
                type
                =   {
                      stretching        =   "\\nu";
                      bending           =   "\\delta";
                      scissoring        =   "\\delta";
                      rocking           =   "\\gamma";
                      twisting          =   "\\tau";
                      wagging           =   "\\kappa";
                    }.${peak.type} or "???";
                symmetric
                =   if      peak.sym == null  then  ""
                    else if peak.sym          then  "\\textsubscript{s}"
                    else                            "\\textsubscript{as}";
              in
                if peak.assignment == null  then  null
                else if peak.type == null   then  "${assignment}"
                else                              "${symmetric}${type}(${assignment})"
            )
          ]
        );

  getXpos
  =   peak:
        if set.isInstanceOf peak.x then  "${string (number.round peak.x.from)}–${string (number.round peak.x.till)}"
        else                  (string (number.round peak.x));

  reportSpectrum
  =   { acronyms, ... }:
      spectrum:
        let
          signals
          =   list.filter
              (
                { y, ... }:
                  let
                    strength            =   ( 100.0 - y ) / ( 100.0 - spectrum.min ) * 1.2;
                  in
                    strength >= 0.3
              )
              spectrum.signals;
          signals'
          =   list.sort
              (
                first:
                second:
                  let
                    first'
                    =   if list.isInstanceOf first.x
                        then
                          list.head first.x
                        else if set.isInstanceOf first.x
                        then
                          first.x.from
                        else
                          first.x;
                    second'
                    =   if list.isInstanceOf second.x
                        then
                          list.head second.x
                        else if set.isInstanceOf second.x
                        then
                          second.x.from
                        else
                          second.x;
                  in
                    debug.info "compare ir-signals" { data = { first = first.x; second = second.x; }; }
                    first' > second'
              )
              signals;
          spectrum'
          =   list.map
                ( peak: "${getXpos peak} (${getDetails spectrum.min peak})" )
                signals';
          note
          =   if spectrum.note or null != null
              then
                "${spectrum.note}, "
              else
                "";
        in
          if spectrum' != [ ]
          then
            LaTeX
            (
              [
                "\\mbox{}\\textbf{${acronyms.infrared.short}} (${note}${acronyms.waveNumber.short}/${acronyms.cm-1.short}):"
                indentation.more
              ]
              ++  ( list.generate (x: "${list.get spectrum' x},") (( list.length spectrum' ) - 1) )
              ++  [
                    "${list.foot spectrum'}."
                    indentation.less
                  ]
            )
          else
            null;

  genPeaks
  =   list.map
      (
        peak:
          let
            x'
            =   if set.isInstanceOf peak.x
                then
                  ( peak.x.from + peak.x.till ) / 2
                else
                  peak.x;
            x                           =   string (number.round x');
            y                           =   string peak.y;
            z                           =   string (number.round ( x' + peak.z or 0 ));
            colour                      =   "0x00aaaaaa";
          in
            ''
              set arrow from first ${x}, graph 0.2 to first ${x}, first ${y} nohead lc rgb "${colour}"
              set arrow from first ${x}, graph 0.2 to first ${z}, graph 0.13 nohead lc rgb "${colour}"
              set label "\\tiny ${x}" right rotate by 90 at first ${z}, graph 0.12
            ''
      );
  genAppendix
  =   { acronyms, ... }:
      { journal ? "", substance, ... } @ product:
      { label ? null, plot, min, max, note ? null, range, signals ? [], ... } @ spectrum:
        if plot != null
        then
          let
            fileName
            =   let
                  plot'                 =   path.getBaseName plot;
                  matching              =   string.match "(.+)[.]plot$" plot';
                in
                  if matching != null
                  then
                    list.head matching
                  else
                    plot';

            body
            =   ''
                  ${string.concat ( genPeaks signals )}
                  set xlabel "{\\small ''${\${acronyms.waveNumber.short} / \${acronyms.cm-1.short}}$}"
                  set ylabel "{\\small ''${\\text{Transmission} / \${acronyms.percent.short}}$}"
                  set xrange [${string range.max}:${string range.min}]
                  set yrange [${string min}:${string max}]
                  plot "${plot}" notitle with lines lt rgb "0x00777777"
                  set output
                '';

            hash                        =   string.hash "sha1" body;
            dst                         =   "generated/appendix/ir/${hash}-plot";
            epsFile                     =   "${dst}.eps";
            texFile                     =   "${dst}.tex";
            gnuplotSourceFile
            =   path.toFile "${hash}.gnuplot"
                ''
                  set terminal epslatex
                  set output "${epsFile}"
                  ${body}
                '';
            gnuplotDestinationFile      =   "${dst}.gnuplot";

            src
            =   output:
                  string.concatWith " && "
                  [
                    "(mkdir -p \"generated/appendix/ir/${substance.name}/\""
                    "gnuplot \"${gnuplotSourceFile}\""
                    "mv \"${texFile}\" \"${output}.tex\""
                    "epstopdf \"${epsFile}\" \"${output}.pdf\")"
                  ];
            note'
            =   if note != null
                then
                  " (${note})"
                else
                  "";
          in
            Heading' "${acronyms.infrared.short}-Spektrum~${substance.NameID}${note'}"
            [
              (
                LaTeX
                (
                  (
                    if label != null
                    then
                      [ "\\labelAppendix{ir:${label}}%" ]
                    else
                      [ ]
                  )
                  ++  (
                        if true
                        then
                        [
                          "\\vspace{-1\\normalbaselineskip}"
                          "\\begin{figure}[H]%" indentation.more
                          "\\centering%"
                          "\\begin{adjustbox}%" indentation.more
                          "{max width=\\textwidth,max height=.4\\textheight,keepaspectratio}%"
                          "{\\input{\\source/${texFile}}}%"
                          indentation.less "\\end{adjustbox}%"
                          indentation.less "\\end{figure}%" null
                        ]
                        else
                        [
                          "\\begin{figure}[H]%" indentation.more
                          "\\centering%"
                          "\\begin{adjustbox}%" indentation.more
                          "{angle=90,min width=\\textwidth,min totalheight=\\textheightleft,max width=\\textwidth,max totalheight=\\textheightleft-2em}%"
                          "{\\input{\\source/${texFile}}}%"
                          indentation.less "\\end{adjustbox}%"
                          indentation.less "\\end{figure}%" null
                        ]
                      )
                )
              )
            ]
            {
              clearPage                 =   false;
#              rotate                    =   false;
              before                    =   "\\refstepcounter{ctrAppendix}%";
              dependencies
              =   [
                    { src = gnuplotSourceFile; dst = gnuplotDestinationFile; }
                    { inherit dst src; }
                  ];
            }
        else
          [ ];
  genAppendix'
  =   resources:
      { failure ? false, ... } @ product:
        let
          ir
          =   product.ir
          or  product.substance.ir
          or  null;
          genAppendix'                  =   genAppendix resources product;
        in
          if  ir != null
          &&  !failure
          then
            if list.isInstanceOf ir
            then
              list.map genAppendix' ir
            else
              [ ( genAppendix' ir ) ]
          else
            [ ];
  generateAppendix
  =   syntheses:
      { configuration, resources, ... } @ document:
      let
        syntheses'
        =   if path.isInstanceOf syntheses
              then
                import
                  syntheses
                  (libs // { chemistry = libs.chemistry // { ir = null; }; })
                  document
              else
                syntheses;
      in
        LaTeX
        [
          ( ClearPage )
          (
            PhantomHeading
            (
              PhantomHeading
              (
                list.concatMap
                (
                  synthesis:
                    if  synthesis ? product
                    then
                      let
                        product
                        =   if lambda.isInstanceOf synthesis.product then  synthesis.product { }
                            else                                synthesis.product;
                      in
                        if list.isInstanceOf product then  list.map (genAppendix' resources)  product
                        else                    [ ( genAppendix' resources product ) ]
                    else
                      [ ]
                )
                (
                  if list.isInstanceOf syntheses'
                  then
                    syntheses'
                  else
                    syntheses'.list
                )
              )
            )
          )
        ];

  report
  =   { ... } @ resources:
      spectra:
        let
          reportSpectrum'               =   reportSpectrum resources;
        in
          if list.isInstanceOf spectra
          then
            list.filter
              (x: x != null)
              (list.map reportSpectrum' spectra)
          else
            [ ( reportSpectrum' spectra ) ];

  Spectrum
  =   plot:
      config:
      signals:
        {
          inherit plot signals;
          min                           =   config.min or (-10);
          max                           =   config.max or 101;
          range
          =   {
                min                     =   ( config.range or {} ).min or 500;
                max                     =   ( config.range or {} ).max or 4000;
              };
          note                          =   config.note or null;
        };
  Signal
  =   x: y: z:
      type:
      sym:
      assignment:
        {
          x
          =   type.matchPrimitiveOrDefault x
              {
                set
                =   {
                      from              =   x.from;
                      till              =   x.till;
                    };
                list
                =   {
                      from              =   list.get x 0;
                      till              =   list.get x 1;
                    };
              }
              x;
          inherit y z type sym assignment;
        };
in
  {
    inherit generateAppendix report;
    inherit Spectrum Signal;
    Signal'                             =   x: y: z: Signal x y z null null null;
  }