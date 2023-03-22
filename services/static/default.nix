{ enableACME, extraConfig, forceSSL, ... }:
  Service "Static Files"
  {
    configuration
    =   { network, ... }:
        {
          nginx
          =   {
                enable                  =   true;
                virtualHosts."static.${network.domain}"
                =   {
                      inherit enableACME extraConfig forceSSL;
                      locations."/".root=   "/var/static/";
                    };
              };
        };
  }
