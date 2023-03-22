{ core, document, physical, ... }:
let
  inherit(core)     debug string type;
  inherit(physical) formatValue;

  report
  =   { acronyms, ... }:
      {
        melting       ? null,
        boiling       ? null,
        sublimation   ? null,
        decomposition ? null,
        density       ? null,
        ...
      }:
        let
          formatValue'
          =   value:
                type.matchPrimitiveOrPanic value
                {
                  int                   =   formatValue { value = 1.0 * value; precision = 1; };
                  float                 =   formatValue { inherit value; precision = 1; };
                  set                   =   formatValue { inherit value; };
                };

          formatTemperature
          =   temperature:
                formatValue' temperature "celsius";

          optional
          =   value:
              text:
                if value != null
                then
                  [ text ]
                else
                  [];

          result
          =   ( optional melting        "${acronyms.meltingTemperature.short} ${formatTemperature melting}"             )
          ++  ( optional boiling        "${acronyms.boilingTemperature.short} ${formatTemperature boiling}"             )
          ++  ( optional sublimation    "${acronyms.sublimationTemperature.short} ${formatTemperature sublimation}"     )
          ++  ( optional decomposition  "${acronyms.decompositionTemperature.short} ${formatTemperature decomposition}" )
          ++  ( optional density        "$\\rho$ ${formatValue' density [ "gram" "millilitre" (-1) ] }"                 );
        in
          [ "${string.concatCSV result}." ];
in
{
  report
  =   resources:
      value:
        if value != null
        then
          report value
        else
          [ ];
}