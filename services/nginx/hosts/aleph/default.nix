{ core, web, ... } @ libs:
{ domain, ... } @ env:
  let
    inherit(core) path;

    wwwEnv
    =   {
          head
          =   {
                # Metadata
                author                  =   "_sivizius";
                description             =   "Personal Homepage of sivizius";
                keywords                =   "Organometallic Chemistry, Rust, Nix/NixOS";
                title                   =   "Sivi’s Homepage";

                _blank                  =   "https://sivizius.eu/";
                stylesheets
                =   {
                      "common.css"      =   { crossorigin = "anonymous"; referrerpolicy = "no-referrer"; };
                    };
                viewport                =   "width=device-width, initial-scale=1.0";
              };
        };

    well-known
    =   {
          "canary.txt"                  =   path.import ./canary.txt.nix    libs  env;
          "security.txt"                =   path.import ./security.txt.nix  libs  env;
        };

    www
    =   {
          "/"
          =   {
                inherit well-known;
                root
                =   {
                      "common.css"      =   path.import ./common.css.nix  libs  wwwEnv;
                      "index.html"      =   path.import ./index.html.nix  libs  wwwEnv;
                      "resume.html"     =   path.import ./resume.html.nix libs  wwwEnv;
                      "pgp.asc"         =   ./pgp.asc;
                      "secunet.asc"     =   ./secunet.asc;
                      "secunet.ssh"     =   ./secunet.ssh;
                    };
              };
          "/fasm".redirect              =   "https://github.com/sivizius/dirtycow.fasm";
          "/js".redirect                =   "https://github.com/sivizius/scihubify";
          "/latex".redirect             =   "https://github.com/sivizius/nixfiles/tree/development/NixTeX";
          "/nixfiles".redirect          =   "https://github.com/sivizius/nixfiles";
          "/python".redirect            =   "https://github.com/sivizius/ameisenRennen";
          "/rust".redirect              =   "https://github.com/sivizius?tab=repositories&q=&type=source&language=rust&sort=";
          "/ti-konnektor".redirect      =   "https://github.com/sivizius/secunet_ti_konnektor_pin_calculator";
        };
  in
  {
    inherit www;
    ""                                  =   www;
  }
