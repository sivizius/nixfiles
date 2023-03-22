{ core, ... } @ env:
let
  inherit(core) error library list string type;

  english                               =   library.import ./english.nix  env {};
  german                                =   library.import ./german.nix   env english;
in
{
  inherit english german;
  translate
  =   locale:
        let
          parts                         =   string.match "([a-z]+)(_[A-Z]+)?([.][0-9A-Za-z-]+)?(@.+)?" locale;
          getPart                       =   list.get parts;
          locale'
          =   if string.isInstanceOf locale
              then
                if parts != null
                then
                  {
                    language            =   getPart 0;
                    territory           =   getPart 1;
                    codeset             =   getPart 2;
                    modifier            =   getPart 3;
                  }
                else
                  error.panic ""
              else
                locale;
          translate
          =   {
                "de"                    =   german.translate;
                "en"                    =   english.translate;
              }.${locale'.language}
          or  ( error.panic "Unknown language »${locale'.language}«" );
        in
          translate locale';
}