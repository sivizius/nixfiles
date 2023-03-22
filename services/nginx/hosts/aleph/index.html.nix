{ web, ... }:
{ head, ... }:
  let
    inherit(web.html) HTML;
  in
    HTML { language = "eng"; }
    {
      inherit head;
      body
      =   with web.html;
          [
            (
              main
              [
                (h1 "sivizius’ website")
                (h2 "Who am I?")
                (
                  p
                    ''
                      I am sivizius, a chemist (M.Sc.) with a focus on synthetic organometallic chemistry,
                        in particularly ferrocene chemistry as well as an
                      software developer and linux system engineer.
                    ''
                )
                (h2 "My skills")
                (
                  p
                    ''
                      I have practical experience with
                        the usual development tools like git,
                        (flat)assembler,
                        reverse engineering of software and
                        I am familiar with
                          theoretical computer science,
                          cryptography,
                          Linux and
                          especially the Nix/NixOS ecosystem.
                      By operating my own server infrastructure with e-mail, monitoring, DNS, etc.
                        I was able to gain valuable experience in network and system administration.
                    ''
                )
              ]
            )
          ];
    }
