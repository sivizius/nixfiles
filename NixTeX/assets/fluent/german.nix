{ core, ... }:
{ ... } @ default:
let
  inherit(core) error list string;

  months
  =   [
        "Januar"    "Februar" "März"      "April"
        "Mai"       "Juni"    "Juli"      "August"
        "September" "Oktober" "November"  "Dezember"
      ];
  monthsAT
  =   [
        "Jänner"    "Februar" "März"      "April"
        "Mai"       "Juni"    "Juli"      "August"
        "September" "Oktober" "November"  "Dezember"
      ];

  standard
  =   default
  //  {
        "formatDate"
        =   { day, month, year, ... }:
            "${string day}. ${list.get months month} ${string year}";
        "colour"                        =   "Farbe";
        "today"                         =   "heute";
      };
in
{
  translate
  =   locale:
      snippet:
        let
          translations
          =   {
                "DE"                    =   standard;
              }.${locale.territory}
          or ( error.panic "Unknown Territory »${locale.territory}«!" );
        in
          translations.${snippet} or ( error.panic "Unknown Snippet »${snippet}«!" );
}