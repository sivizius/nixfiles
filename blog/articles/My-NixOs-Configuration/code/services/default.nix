{ ... }:
let
  services
  =   {
        # …
        gitea
        =   Service "Gitea: Hosting git-repositories."
            {
              config    = ./gitea.nix;
              requires  = with services; [ nginx ];
            };
        nginx
        =   Service "Nginx: HTTP-Server."
            {
              config    = ./nginx.nix;
            };
        # …
      };
in
  services