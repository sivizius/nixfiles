# TODO: Refactor things

# gimel (third hebrew character) is usually installed on sivizius@gimel.sivizius.eu
{ config, ... }:
{
  imports                             =
  [
    ./hardware

    # Services
    #../../services/blog.nix
    ../../services/gitea.nix
    ../../services/home-manager.nix
    ../../services/monitoring.nix
    ../../services/nginx.nix
  ];

  documentation.enable                  =   false;

  self                                  =
  {
    domain                              =   "sivizius.eu";
    hostName                            =   "gimel";
    ipv4addr                            =   "45.158.41.100";
    ipv6addr                            =   "2a0f:5381::4";
    ipv6range                           =   "2a0f:5381::/64";
    legacyTLS                           =   true;
    ports                               =
    {
      exporters                         =
      {
        bind                            =   9119;
        nginx                           =   9113;
        node                            =   9100;
      };
      gitea                             =   3000;
      grafana                           =   3001;
      prometheus                        =   9090;
    };
    secrets                             =   ./secrets;
  };
}
