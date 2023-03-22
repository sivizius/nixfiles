{ mod, ... }:
{ ... } @ default:
let
  inherit (mod) error;

  american
  =   british
  //  {
        "colour"                        =   "color";
      };
  british
  =   default
  //  {
        "colour"                        =   "colour";
        "today"                         =   "today";
      };
in
{
  translate
  =   locale:
      snippet:
        let
          translations
          =   {
                "UK"                    =   british;
              }.${locale.territory}
          or ( error.panic "Unknown Territory »${locale.territory}«!" );
        in
          translations.${snippet} or ( error.panic "Unknown Snippet »${snippet}«!" );
}