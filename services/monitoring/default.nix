{ enableACME, forceSSL, ... }:
  Service "Monitoring with grafana and prometheus"
  {
    configuration
    =   { core, network, secret, ... }:
          let
            inherit(core)     string;
            inherit(network)  domain hostName ips tcp;
            inherit(tcp)      ports;
            hostDomain                  =   "${hostName}.${domain}";

            allowedIPs
            =   string.concatMappedLines
                  (ip: "allow ${ip};")
                  ips;

            extraConfig
            =   ''
                  ${allowedIPs}
                  deny all;
                '';

            nginxConfigHost
            =   {
                  inherit enableACME extraConfig forceSSL;
                  locations
                  =   {
                        "/metrics/nginx"
                        =   {
                              inherit extraConfig;
                              proxyPass =   "http://localhost:${string ports.exporters.nginx}/metrics";
                            };
                        "/metrics/node"
                        =   {
                              inherit extraConfig;
                              proxyPass =   "http://localhost:${string ports.exporters.node}/metrics";
                            };
                      };
                };

            nginxConfigGrafana
            =   {
                  inherit enableACME forceSSL;
                  locations."/"
                  =   {
                        proxyPass       =   "http://localhost:${string ports.grafana}/";
                      };
                };

            nginxConfigPrometheus
            =   {
                  inherit enableACME extraConfig forceSSL;
                  locations."/"
                  =   {
                        inherit extraConfig;
                        proxyPass       =   "http://localhost:${string ports.prometheus}/";
                        proxyWebsockets =   true;
                      };
                };
            settings
            =   {
                  "auth.anonymous"
                  =   {
                        enabled         =   true;
                      };
                  security
                  =   {
                        admin_user      =   "admin";
                        admin_password  =   secret.decryptGrafanaSecret' ./admin.asc;
                      };
                  server
                  =   {
                        domain          =   "grafana.${domain}";
                        http_port       =   ports.grafana;
                        root_url        =   "https://grafana.${domain}/";
                      };
                };
          in
          {
            grafana
            =   {
                  enable                =   true;
                  provision
                  =   {
                        enable          =   true;
                        dashboards
                        =   {
                              path      =   ./dashboards;
                            };
                        datasources.settings.datasources
                        =   [
                              {
                                isDefault
                                =   true;
                                name    =   "Prometheus";
                                type    =   "prometheus";
                                url     =   "https://prometheus.${domain}/";
                              }
                            ];
                      };
                  inherit settings;
                };

            journald.extraConfig
            =   ''
                  MaxFileSec="6h"
                  MaxRetentionSec="3day"
                '';

            nginx.virtualHosts
            =   {
                  ${hostDomain}         =   nginxConfigHost;
                  "grafana.${domain}"   =   nginxConfigGrafana;
                  "prometheus.${domain}"=   nginxConfigPrometheus;
                };

            prometheus
            =   {
                  checkConfig           =   "syntax-only";
                  enable                =   true;
                  exporters
                  =   {
                        nginx
                        =   {
                              enable    =   true;
                              port      =   ports.exporters.nginx;
                            };
                        node
                        =   {
                              enable    =   true;
                              port      =   ports.exporters.node;
                            };
                      };
                  scrapeConfigs
                  =   [
                        {
                          job_name      =   "nginx";
                          metrics_path  =   "/metrics/nginx";
                          scheme        =   "https";
                          scrape_interval
                          =   "30s";
                          static_configs
                          =   [
                                {
                                  targets
                                  =   [ hostDomain ];
                                }
                              ];
                        }
                        {
                          job_name      =   "node";
                          metrics_path  =   "/metrics/node";
                          scheme        =   "https";
                          scrape_interval
                          =   "30s";
                          static_configs
                          =   [
                                {
                                  targets
                                  =   [ hostDomain ];
                                }
                              ];
                        }
                      ];
                };

            vnstat.enable               =   true;
          };
  }
