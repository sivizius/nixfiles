{ chemistry, core, document, physical, ... } @ libs:
let
  inherit(core)               debug indentation list number string type;
  inherit(document)           ClearPage Heading' LaTeX PhantomHeading;
  inherit(physical)           formatUnit;
  inherit(number)             toStringWithPrecision;
  inherit(chemistry.elements) calculateMassOfFormula formatMolecularFormula normaliseMolecularFormula;

  adjustIons#: [ string ] -> [ string ]
  =   ions:
        let
          len-1                         =   ( list.length ions ) - 1;
        in
          if ions != [ ]
          then
            ( list.generate (x: "${list.get ions x};") len-1 ) ++ [ "${list.get ions len-1}." ]
          else
            [ ];

  genAppendix#: Product -> [ string ]
  =   resources:
      { substance, ... }:
      { full, ions, ... }:
        let
          files
          =   (
                if full != null
                then
                  [
                    {
                      file              =   full;
                      title             =   "Übersichts\\-spektrum von ${substance.NameID}";
                    }
                  ]
                else
                  []
              )
          ++  (
                list.concatMap
                (
                  { file, formattedFormula, ... }:
                    if file != null
                    then
                      [
                        {
                          inherit file;
                          title         =   "Isotopen\\-muster für ${formattedFormula} von ${substance.NameID}";
                        }
                      ]
                    else
                      debug.warn "genAppendix" "File missing for ${formattedFormula}!" []
                )
                ions
              );
        in
          list.map
          (
            { file, title }:
              Heading' title
              (
                LaTeX
                [
                  "\\vspace{-1\\normalbaselineskip}"
                  "\\begin{figure}[H]%" indentation.more
                  "\\centering%"
                  "\\begin{adjustbox}%" indentation.more
                  "{max width=\\textwidth,max height=.4\\textheight,keepaspectratio}%"
                  "\\includegraphics{${file}}%"
                  indentation.less "\\end{adjustbox}%"
                  indentation.less "\\end{figure}%" null
                ]
              )
              {
                before                  =   "\\refstepcounter{ctrAppendix}%";
              }
          )
          files;

  genAppendix'
  =   resources:
      { failure ? false, ... } @ product:
        let
          ms
          =   product.ms
          or  product.substance.ms
          or  null;
        in
          if ms != null
          &&  !failure
          then
            genAppendix resources product ms
          else
            [ ];

  generateAppendix
  =   syntheses:
      { configuration, resources, ... } @ document:
      let
        syntheses'
        =   if type.isPath syntheses
              then
                import
                  syntheses
                  (libs // { chemistry = libs.chemistry // { ms = null; }; })
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
                        =   if type.isLambda synthesis.product then  synthesis.product { }
                            else                                synthesis.product;
                      in
                        if type.isList product then  list.map (genAppendix' resources)  product
                        else                    [ ( genAppendix' resources product ) ]
                    else
                      [ ]
                )
                (
                  if type.isList syntheses'
                  then
                    syntheses'
                  else
                    syntheses'.list
                )
              )
            )
          )
        ];

  mapIons
  =   list.map
      (
        { calculated ? null, charge, formula, found, mrm ? null, ... } @ ion:
          let
            charge'
            =   if charge == 0
                then
                  ""
                else if charge == 1
                then
                  "+"
                else if charge == -1
                then
                  "\\minus"
                else if charge > 0
                then
                  "+${string charge}"
                else
                  "\\minus${string (0 - charge)}";
            found'                      =   toStringWithPrecision     found 4;
            formula'                    =   normaliseMolecularFormula formula;
            formula''                   =   formatMolecularFormula    formula';
            mass
            =   if calculated != null
                then
                  calculated
                else
                  calculateMassOfFormula    formula';
            mass'                       =   toStringWithPrecision     mass  4;
            delta                       =   ((found - mass) / mass) * 1000 * 1000;
            delta'
            =   if delta < 0
                then
                  "-\\text{${toStringWithPrecision     (-delta) 2}}"
                else
                  "\\text{${toStringWithPrecision     delta 2}}";

            formattedCalc               =   "berechnet für ${formattedFormula}: ${mass'}, ";
            formattedDelta              =   "\${\\Delta m = ${delta'}}$";
            formattedFound              =   "gefunden: ${found'}, ";
            formattedFormula            =   "[\\ch{${formula''}}]\\textsuperscript{${charge'}}";
          in
            ion
            //  {
                  inherit mrm formattedFormula;
                  formattedLine         =   "${formattedCalc}${formattedFound}${formattedDelta}";
                }
      );

  report# { ... } -> { method: string; ions: [ Ion ] }
  =   { acronyms, ... } @ resources:
      { highRes, ions, method, ... }:
      [
        (
          LaTeX
          (
            let
              method'
              =   {
                    "ESI-TOF"           =   "${acronyms.electroSprayIonisation.short}-${acronyms.timeOfFlightMS.as "TOF"}";
                  }.${method}
                  or  (
                        (
                          acronyms.${method}
                          or  {
                                short   =   debug.panic "report" "Unknown method »${method}«";
                              }
                        ).short
                      );
              ions'                     =   list.map ({ formattedLine, ... }: formattedLine) ions;
              unit                      =   formatUnit [ "dalton" "elementaryCharge-1" ];
              highRes'
              =   if highRes
                  then
                    acronyms.highResolutionMassSpectrometry.short
                  else
                    acronyms.massSpectrometry.short;
            in
            #debug.panic "report" { text = "unit"; data = unit; }
            [
              "\\mbox{}\\textbf{${highRes'}}"
              "  (${method'}, ${acronyms.massToChargeRatio.short}~/~${unit}, $\\Delta$~/~${acronyms.ppm.short}):"
              indentation.more
            ]
            ++  ( adjustIons ions' )
            ++  [ indentation.less ]
          )
        )
      ];
in
{
  inherit generateAppendix;
  Spectrum
  =   { full ? null, highRes ? false, ions, method, files ? {} }:
      {
        inherit files full highRes method;
        ions                            =   mapIons ions;
      };
  report
  =   { ... } @ resources:
      data:
        if  type.isSet data
        &&  data != {}
        then
          report resources data
        else
          [];
}