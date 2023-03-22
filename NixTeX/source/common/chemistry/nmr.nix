{ core, document, physical, ... } @ libs:
  let
    inherit(core)     debug indentation lambda list number path set string type;
    inherit(document) ClearPage Heading' LaTeX LaTeX' PhantomHeading;

    # T: ToString -> string
    extensionOf
    =   path:
          let
            name                        =   string.split "[.]" ( string path );
          in
            if name != null
            then
              list.get name ( ( list.length name ) - 1 )
            else
              null;

    adjustSignals#: [ string ] -> [ string ]
    =   signals:
          let
            len-1                       =   ( list.length signals ) - 1;
          in
            debug.info "adjustSignals" { text = "called with"; data = signals; }
            (
              if signals != [ ]
              then
                ( list.generate (x: "${list.get signals x},") len-1 ) ++ [ "${list.get signals len-1}." ]
              else
                [ ]
            );

    # LaTeX
    formatNMRnucleus#: string -> string
    =   nucleus:
          let
            tex
            =   {
                  "1H"                  =   "\\textsuperscript{1}H";
                  "13C"                 =   "\\textsuperscript{13}C";
                  "13C{1H}"             =   "\\textsuperscript{13}C\\{\\textsuperscript{1}H\\}";
                  "15N"                 =   "\\textsuperscript{15}N";
                  "15N{1H}"             =   "\\textsuperscript{15}N\\{\\textsuperscript{1}H\\}";
                  "19F"                 =   "\\textsuperscript{19}F";
                  "19F{1H}"             =   "\\textsuperscript{19}F\\{\\textsuperscript{1}H\\}";
                  "31P"                 =   "\\textsuperscript{31}P";
                  "31P{1H}"             =   "\\textsuperscript{31}P\\{\\textsuperscript{1}H\\}";
                };
            pdf
            =   {
                  "1H"                  =   "¹H";
                  "13C"                 =   "¹³C";
                  "13C{1H}"             =   "¹³C\\{¹H\\}";
                  "15N"                 =   "¹⁵N";
                  "15N{1H}"             =   "¹⁵N\\{¹H\\}";
                  "19F"                 =   "¹⁹F";
                  "19F{1H}"             =   "¹⁹F\\{¹H\\}";
                  "31P"                 =   "³¹P";
                  "31P{1H}"             =   "³¹P\\{¹H\\}";
                };
          in
            "\\texorpdfstring{${tex.${nucleus} or nucleus}}{${pdf.${nucleus} or nucleus}}";

    # LaTeX
    formatSpectrum#: Spectrum -> Chunk
    =   { acronyms, ... }:
        { file, label, method, sample, solvent, substance, title, name, ... }:
          let
            solvent'
            =   if solvent != null
                then
                  solvent
                else
                  "${acronyms.CDCl3.short}";
            title'
            =   if title != null
                then
                  "${method}-${acronyms.nuclearMagneticResonance.short}~${title} in ${solvent'}"
                else
                  "${method}-${acronyms.nuclearMagneticResonance.short}~${substance.NameID}${sample} in ${solvent'}";
            fileName                    =   "\\source/resources/appendix/nmr/${substance.name or name}/${path.getBaseName file}";
            label'                      =   "nmr:${label}";
          in
            if ( extensionOf file == "pdf" )
            then
              Heading' "${title'}"
              [
                (
                  LaTeX
                  (
                    (
                      if label != null
                      then
                        [ "\\labelAppendix{nmr:${label}}%" ]
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
                            "\\includegraphics{${fileName}}%"
                            indentation.less "\\end{adjustbox}%"
                            indentation.less "\\end{figure}%" null
                          ]
                          else
                          [
                            "\\begin{figure}[H]%" indentation.more
                            "\\centering%"
                            "\\begin{adjustbox}%" indentation.more
                            "{angle=90,min width=\\textwidth,min totalheight=\\textheightleft,max width=\\textwidth,max totalheight=\\textheightleft-2em}%"
                            "\\includegraphics{${fileName}}%"
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
              }
            else
              debug.panic
                [ "formatSpectrum" ]
                "File in the Portable Document Format (pdf) expected, got »${string file}«!";

    # LaTeX
    formatSpectrumName# Spectrum -> string
    =   { acronyms, ... }:
        { nucleus, kind, ... }:
          let
            nucleus'
            =   if nucleus == "1Hx13C"
                then
                  "${formatNMRnucleus "1H"}-${formatNMRnucleus "13C"}"
                else
                  formatNMRnucleus nucleus;
            dept#: integer -> string
            =   degree:
                  "${formatNMRnucleus nucleus}-${acronyms.dept.short}-${string degree}";
          in
            {
              "self"                    =   formatNMRnucleus nucleus;
              "dc"                      =   formatNMRnucleus "${nucleus}{1H}";
              "dept"                    =   "${formatNMRnucleus nucleus}-${acronyms.dept.short}";
              "dept45"                  =   dept 45;
              "dept90"                  =   dept 90;
              "dept135"                 =   dept 135;
            }.${kind} or "${nucleus'}-${acronyms.${kind}.short}";

    genAppendix#: Product -> [ string ]
    =   resources:
        { failure ? false, substance ? {}, name ? null, nmr ? null, title ? null, identifier ? null, ... }:
        let
          nmr'                          =   substance.nmr or  nmr;
          spectra
          =   list.concatMap
              (
                { nucleus, data }:
                  if data != null
                  then
                    let
                      inherit(data) files;
                    in
                      list.map
                      (
                        spectrum:
                          spectrum
                          //  {
                                inherit substance nucleus title name;
                                inherit(data) comment solvent;
                              }
                      )
                      (
                        {
                          "1H"
                          =   [
                                { kind = "self";  files = files.self  or files."1H"       or null; }
                                { kind = "cosy";  files = files.cosy                      or null; }
                                { kind = "tocsy"; files = files.tocsy                     or null; }
                                { kind = "noesy"; files = files.noesy                     or null; }
                                { kind = "roesy"; files = files.roesy                     or null; }
                              ];
                          "13C"
                          =   [
                                { kind = "dc";      files = files.dc    or  files."13C{1H}" or null; }
                                { kind = "self";    files = files.self  or  files."13C"     or null; }
                                { kind = "apt";     files = files.apt                       or null; }
                                { kind = "dept";    files = files.dept                      or null; }
                                { kind = "dept90";  files = files.dept90                    or null; }
                                { kind = "dept135"; files = files.dept135                   or null; }
                              ];
                          "15N"
                          =   [
                                { kind = "dc";    files = files.dc    or  files."15N{1H}" or null; }
                                { kind = "self";  files = files.self  or  files."15N"     or null; }
                              ];
                          "19F"
                          =   [
                                { kind = "dc";    files = files.dc    or  files."19F{1H}" or null; }
                                { kind = "self";  files = files.self  or  files."19F"     or null; }
                              ];
                          "31P"
                          =   [
                                { kind = "dc";    files = files.dc    or  files."31P{1H}" or null; }
                                { kind = "self";  files = files.self  or  files."31P"     or null; }
                              ];
                          "1Hx13C"
                          =   [
                                { kind = "hsqc";  files = files.hsqc                      or null; }
                                { kind = "hmbc";  files = files.hmbc                      or null; }
                              ];
                        }.${nucleus}
                      )
                  else
                    []
              )
              [
                { nucleus = "1H";     data = nmr'."1H"     or null; }
                { nucleus = "13C";    data = nmr'."13C"    or null; }
                { nucleus = "15N";    data = nmr'."15N"    or null; }
                { nucleus = "19F";    data = nmr'."19F"    or null; }
                { nucleus = "31P";    data = nmr'."31P"    or null; }
                { nucleus = "1Hx13C"; data = nmr'."1Hx13C" or null; }
              ];
        in
          if nmr' != null
          &&  !failure
          then
            list.concatMap (genAppendixForSpectrum resources) spectra
          else
            [ ];

    # LaTeX
    genAppendixForSpectrum#: Spectrum -> [ Chunk ] | !
    =   resources:
        { nucleus, kind, files, comment, solvent, substance, title, name, ... } @ spectrum:
        let
          # string | null -> path -> string -> [ string ] | !
          formatSpectrum'
          =   sample:
              file:
              label:
                formatSpectrum resources
                {
                  inherit file label substance solvent title name;
                  method                =   formatSpectrumName resources spectrum;
                  sample
                  =   if sample != null
                      then
                        " (${string sample})"
                      else
                        "";
                };
        in
          type.matchPrimitiveOrPanic files
          {
            lambda                      =   debug.panic "genAppendixForSpectrum" "???";
            list
            =   (
                  list.fold
                  (
                    state:
                    file:
                      state
                      //  {
                            counter     =   state.counter + 1;
                            list
                            =   state.list
                            ++  [
                                  (
                                    type.matchPrimitiveOrPanic file
                                    {
                                      lambda
                                      =   debug.panic "genAppendix" "2???";
                                      path
                                      =   formatSpectrum'
                                            null
                                            file
                                            ( spectrum.label or "${substance.name or name}_${nucleus}_${string state.counter}" );
                                      set
                                      =   formatSpectrum'
                                            ( file.identifier or null )
                                            file.file
                                            ( spectrum.label or "${substance.name or name}_${nucleus}_${string file.identifier}" );
                                    }
                                  )
                                ];
                      }
                  )
                  {
                    counter             =   1;
                    list                =   [ ];
                  }
                  files
                ).list;
            null                        =   [ ];
            path
            =   let
                  kind'
                  =   if kind == "self"
                      then
                        nucleus
                      else
                        "${nucleus}${kind}";
                  spectrum'
                  =   formatSpectrum'
                        null
                        files
                        ( spectrum.label or "${substance.name or name}_${kind'}" );
                in
                  [ spectrum' ];
            set
            =   let
                  identifier
                  =   if files.identifier or null != null
                      then
                        "_${string files.identifier}"
                      else
                        "";
                in
                [
                  (
                    formatSpectrum'
                      ( files.identifier or null )
                      files.file
                      ( spectrum.label or "${substance.name or name}_${nucleus}${identifier}" )
                  )
                ];
          };

    genDependencies#: Product -> Dependencies
    =   { substance ? {}, identifier ? null, nmr ? null, name ? null, ... }:
          let
            nmr'                        =   substance.nmr or nmr;
            files
            =   list.concatMap
                (
                  spectrum:
                    if spectrum != null
                    then
                      set.values spectrum.files
                    else
                      []
                )
                [
                  ( nmr'."1H"     or null )
                  ( nmr'."13C"    or null )
                  ( nmr'."15N"    or null )
                  ( nmr'."19F"    or null )
                  ( nmr'."31P"    or null )
                  ( nmr'."1Hx13C" or null )
                ];
            files'                      =   list.flat files;
            getFileName                 =   fileName: "resources/appendix/nmr/${substance.name or name}/${path.getBaseName fileName}";
          in
            if nmr' != null
            then
              list.concatMap
              (
                file:
                  type.matchPrimitiveOrDefault file
                  {
                    null                =   [];
                    path                =   [ { src = file; dst = getFileName file; } ];
                    set                 =   [ { src = file.file; dst = getFileName file.file; } ];
                  }
              )
              files'
            else
              [ ];

    # LaTeX
    mapSignals#: string -> [ Signal ] -> [ string ]
    =   { acronyms, ... }:
        nucleus:
          list.map
          (
            { assignment, charge, couplings, integral, multiplicity, other, protons, range } @ signal:
              let
                other'
                =   if other != null
                    then
                      if list.isInstanceOf other
                      then
                        string.concat (list.map (range: "×${prepareRange 1 range}") other)
                      else
                        "×${prepareRange 1 other}"
                    else
                      "";
                precision               =   if nucleus == "1H" then 2 else 1;
                prepareRange
                =   precision:
                    range:
                      if list.isInstanceOf range
                      then
                        let
                          from          =   list.get range 0;
                          till          =   list.get range 1;
                        in
                          "${number.toStringWithPrecision from precision}–${number.toStringWithPrecision till precision}"
                      else if string.isInstanceOf range
                      then
                        range
                      else if range < 0
                      then
                        "\\minus${number.toStringWithPrecision (0 - range) precision}"
                      else
                        "${number.toStringWithPrecision range precision}";

                mapCouplings
                =   set.mapToList
                    (
                      coupling:
                      list:
                        let
                          result        =   string.match "([0-9]+)([A-Za-z]+)" coupling;
                          bonds
                          =   if result != null
                              then
                                "\\textsuperscript{${list.get result 0}}"
                              else
                                "";
                          nuclei
                          =   if result != null
                              then
                                list.get result 1
                              else
                                coupling;
                          values        =   physical.formatValue { value = list; precision = 1; } "hertz";
                        in
                          "${bonds}${acronyms.couplingConstant.short}\\textsubscript{${nuclei}}~=~${values}"
                    );

                element
                =   let
                      nucleus'          =   string.match "[0-9]*([A-Za-z]+).*" nucleus;
                    in
                      if nucleus' != null
                      then
                        list.head nucleus'
                      else
                        nucleus;

                protons'
                =   let
                      charge'
                      =   if      charge == 0   then  ""
                          else if charge == 1   then  "\\textsuperscript{+}"
                          else if charge == -1  then  "\\textsuperscript{\\minus}"
                          else if charge < 0    then  "\\textsuperscript{\\minus${string (0 - charge)}}"
                          else                        "\\textsuperscript{+${string charge}}";
                    in
                      if      protons == 0
                      then
                        let
                          saturated
                          =   {
                                "C"     =   "quaternary";
                                "N"     =   "tertiary";
                              }.${element};
                        in
                          "${acronyms.${saturated}.short} \\textit{${element}}${charge'}"
                      else if protons == 1
                      then
                        "\\textit{${element}}H${charge'}"
                      else
                        "\\textit{${element}}H\\textsubscript{${string protons}}${charge'}";

                details
                =   ( if false                  then  [ protons'                        ] else  [ ] )
                ++  ( if multiplicity !=  null  then  [ "${string multiplicity}"        ] else  [ ] )
                ++  ( mapCouplings couplings                                                        )
                ++  ( if integral     !=  null  then  [ "${string integral}${element}"  ] else  [ ] )
                ++  ( if assignment   !=  null  then  [ "\\ch{${string assignment}}"    ] else  [ ] );
              in
                if details == [ ]
                then
                  "${prepareRange precision range}"
                else
                  "${prepareRange precision range} (${string.concatCSV details})"
          );

    # LaTeX
    reportSpectra#: NMRdata -> [ LaTeX ] | !
    =   { acronyms, ... } @ resources:
        { kind, nmrData }:
        let
          inherit(nmrData) method files signals;
          solvent
          =   if nmrData.solvent != null
              then
                nmrData.solvent
              else
                "${acronyms.CDCl3.short}";

          hyperlink
          =   if nmrData.label or null != null
              then
                "\\hyperlink{appendix:${nmrData.label}}"
              else
                "";
          suffix
          =   let
                methods
                =   list.filter
                      ({ method, from }: from)
                      [
                        { method = "apt";     from = method.apt     or false; }
                        { method = "dept";    from = method.dept    or false; }
                        { method = "dept45";  from = method.dept45  or false; }
                        { method = "dept90";  from = method.dept90  or false; }
                        { method = "dept135"; from = method.dept135 or false; }
                      # { method = "cosy";    from = method.cosy    or false; }
                      # { method = "hmbc";    from = method.hmbc    or false; }
                        { method = "hsqc";    from = method.hsqc    or false; }
                      # { method = "noesy";   from = method.noesy   or false; }
                      # { method = "roesy";   from = method.roesy   or false; }
                      # { method = "tocsy";   from = method.tocsy   or false; }
                      ];
                dept                    =   degree: "${acronyms.dept.short}-${string degree}";
                formatMethod
                =   method:
                    {
                      "dept45"          =   dept 45;
                      "dept90"          =   dept 90;
                      "dept135"         =   dept 135;
                    }.${method} or "${acronyms.${method}.short}";
              in
                if methods != []
                then
                  ", aus ${string.concatMappedWith ({ method, ... }: formatMethod method) "/" methods}"
                else
                  "";
          nucleus
          =   {
                "1H"
                =   if files ? self       then  "1H"
                    else                        null;
                "13C"
                =   if      files ? self  then  "13C"
                    else if files ? dc    then  "13C{1H}"
                    else                        null;
                "15N"
                =   if      files ? self  then  "15N"
                    else if files ? dc    then  "15N{1H}"
                    else                        null;
                "19F"
                =   if      files ? self  then  "19F"
                    else if files ? dc    then  "19F{1H}"
                    else                        null;
                "31P"
                =   if      files ? self  then  "31P"
                    else if files ? dc    then  "31P{1H}"
                    else                        null;
                "1Hx13C"                =       null;
              }.${kind};
            sortSignals
            =   list.sort
                (
                  first:
                  second:
                    let
                      first'
                      =   if list.isInstanceOf first.range
                          then
                            list.head first.range
                          else
                            first.range;
                      second'
                      =   if list.isInstanceOf second.range
                          then
                            list.head second.range
                          else
                            second.range;
                    in
                      first' > second'
                );
          in
            if  nucleus !=  null
            &&  signals !=  []
            then
              [
                (
                  LaTeX
                  (
                    [
                      "\\mbox{}${hyperlink}{\\textbf{${formatNMRnucleus nucleus}-${acronyms.nuclearMagneticResonance.short}}}"
                      "  (${solvent}, ${acronyms.chemShift.short}~/~${acronyms.ppm.short}${suffix}):"
                      indentation.more
                    ]
                    ++  ( adjustSignals ( mapSignals resources nucleus (sortSignals signals) ) )
                    ++  [ indentation.less ]
                  )
                )
              ]
            else
              [ ];

    Signal
    =   range:
        { charge ? 0, couplings ? {}, integral ? null, multiplicity ? null, other ? null, protons ? null }:
        assignment:
          {
            inherit assignment charge couplings integral multiplicity other protons range;
          };

    Spectrum
    =   { ... } @ files:
        { method ? {}, ... } @ config:
        signals:
          {
            comment                     =   null;
            files                       =   {};
            solvent                     =   null;
          }
          //  config
          //  {
                inherit files method signals;
              };
  in
  {
    inherit formatNMRnucleus;

    inherit Spectrum;
    Spectrum'                           =   files: Spectrum files {};

    inherit Signal;
    Signal'                             =   range: multiplicity:  integral:             Signal range { inherit           integral multiplicity; };
    SignalAP                            =   range:                protons:    integral: Signal range { inherit protons   integral;              };
    SignalDC                            =   range:                            integral: Signal range { inherit           integral;              };
    SignalJ                             =   range: multiplicity:  couplings:  integral: Signal range { inherit couplings integral multiplicity; };
    SignalX                             =   range:                other:                Signal range { inherit other;                           };

    # [ Synthsis ] -> arguments -> Document::Chunk.LaTeX
    generateAppendix
    =   syntheses:
        { resources, ... } @ document:
          let
            syntheses'
            =   if path.isInstanceOf syntheses
                then
                  import
                    syntheses
                    (libs // { chemistry = libs.chemistry; })
                    document
                else
                  syntheses;
            syntheses''
            =   if list.isInstanceOf syntheses'
                then
                  syntheses'
                else
                  syntheses'.list;
            products
            =   list.concatMap
                (
                  # Synthesis -> [ string ]
                  synthesis:
                    if  synthesis ? product
                    then
                      let
                        product
                        =   if lambda.isInstanceOf synthesis.product
                            then
                              synthesis.product { }
                            else
                              synthesis.product;
                        product'
                        =   product
                        //  {
                              name      =   product.name or null;
                              substance =   product.substance or synthesis.substance or {};
                            };
                      in
                        if list.isInstanceOf product
                        then
                          product
                        else
                          [ product' ]
                    else
                      [ ]
                )
                syntheses'';
          in
            LaTeX'
            (
              [
                "\\newgeometry"
                "{" indentation.more
                "top                           =   (\\paperheight-\\textheight+\\headheight+\\headsep+\\footskip)/2 - 73.04765pt,"
                "textheight                    =   \\textheight+\\footskip,"
                "footskip                      =   0cm,"
                indentation.less "}%"
                ( ClearPage )
              ]
              ++  [
                    (
                      PhantomHeading
                      (
                        PhantomHeading
                        (
                          list.concatMap
                            (genAppendix resources)
                            products
                        )
                      )
                    )
                    "\\restoregeometry%" null
                  ]
            )
            {
              dependencies              =   list.concatMap genDependencies products;
            };

    # { string -> NMRdata } -> [ LaTeX ]
    report
    =   resources:
        { ... } @ nmrData:
          list.concatMap
          (
            { nmrData, ... } @ spectra:
              if nmrData != null
              then
                reportSpectra resources spectra
              else
                []
          )
          [
            { kind = "1H";  nmrData = nmrData."1H"  or null; }
            { kind = "13C"; nmrData = nmrData."13C" or null; }
            { kind = "15N"; nmrData = nmrData."15N" or null; }
            { kind = "19F"; nmrData = nmrData."19F" or null; }
            { kind = "31P"; nmrData = nmrData."31P" or null; }
          ];
  }