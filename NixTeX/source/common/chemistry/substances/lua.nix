{ chemistry, core, ... } @ libs:
let
  inherit(core)               debug number path string;
  inherit(chemistry.elements) calculateMassOfFormula normaliseMolecularFormula;
  inherit(string)             concatWith replace;

  toLua
  =   name:
      { formula ? [], structure ? {}, ... } @ substance:
        let
          escape                        =   replace [ "\\" "\"" ] [ "\\\\" "\\\"" ];
          orNil
          =   attr:
                if substance.${attr} or null != null
                then
                  "\"${escape substance.${attr}}\""
                else
                  "nil";
          formula'                      =   normaliseMolecularFormula ( formula );
          movPart                       =   escape ( concatWith "" structure.movPart or [] );
        in
        ''
          substances.declare
          (
            "${name}",
            {
              name = ${orNil "title"},
              code = ${orNil "code"},
              mass = ${number.toStringWithPrecision ( calculateMassOfFormula formula' ) 2},
              simple = ${orNil "simple"},
              structure = {
                figPart = "${escape ( concatWith "" structure.figPart or [] )}",
                movPart = "${movPart}"
              },
            }
          )
        '';
in
  { configuration, ... }:
  { ... } @ substances:
    if ( configuration.substances or {}).enable or false
    then
    {
      dst                               =   "generated/substances.lua";
      src                               =   path.fromSet "substances.lua" toLua  substances;
    }
    else
    {
      dst                               =   null;
      src                               =   null;
    }
