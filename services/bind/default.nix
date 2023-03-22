Service "BIND: DNS-Server"
{
  configuration
  =   { core, network, ... }:
        let
          inherit(core)     list string;
          inherit(network)  domain hostName ips peers tcp;
          inherit(tcp)      ports;

          hostDomain                    =   "${hostName}.${domain}";
          master                        =   true;
          masters                       =   [ ];
          /*domainList
          =   [
                domain
                hostDomain
                "blog.${domain}"
                "git.${domain}"
                "grafana.${domain}"
                "prometheus.${domain}"
                "static.${domain}"
              ];
          systemdAfterList
          =   list.mapValuesToSet
              (
                domain:
                {
                  name                  =   "$acme-{domain}";
                  value                 =   { after = [ "bind.service"  ]; };
                }
              )
              domainList;*/
          ipsFromPeer
          =   list.concatMap
                ({ network, ... }: network.ips);
          allowedIPs
          =   string.concatMappedLines
                (ip: "allow ${ip};")
                ips;
          extraConfig
          =   ''
                ${allowedIPs}
                deny all;
              '';
        in
        {
          bind
          =   {
                enable                  =   true;
                forwarders
                =   ipsFromPeer
                    (
                      list.filter
                        ({ type ? {}, ... }: type.dns-forwarder or false)
                        peers
                    );
                cacheNetworks
                =   [
                      "127.0.0.0/8"
                      "::/64"
                    ];
                zones
                =   [
                      {
                        name            =   domain;
                        # TODO: Generate Zone-File
                        file            =   "${./zones}/${domain}";
                        inherit master masters;
                        slaves
                        =   ipsFromPeer
                            (
                              list.filter
                                ({ type, ... }: type.dns-secondary or false)
                                peers
                            );
                      }
                    ];
              };

          nginx.virtualHosts.${hostDomain}.locations."/metrics/bind"
          =   {
                inherit extraConfig;
                proxyPass               =   "http://localhost:${string ports.exporters.bind}/metrics";
              };

          prometheus
          =   {
                exporters.bind
                =   {
                      enable            =   true;
                      port              =   ports.exporters.bind;
                    };
                scrapeConfigs
                =   [
                      {
                        job_name        =   "bind";
                        metrics_path    =   "/metrics/bind";
                        scheme          =   "https";
                        scrape_interval =   "30s";
                        static_configs
                        =   [
                              {
                                targets =   [ hostDomain ];
                              }
                            ];
                      }
                    ];
              };
        };
}
