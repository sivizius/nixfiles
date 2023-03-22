
{ commonHeaders, enableACME, forceSSL, ... }:
  Service "Gitea: Hosting git-repositories"
  {
    configuration
    =   let
          attachment
          =   {
                ALLOWED_TYPES           =   "*/*";
              };
          log
          =   {
                LEVEL                   =   "Warn";
              };
          metrics
          =   {
                ENABLED                 =   true;
              # TOKEN                   =   "INTERNAL_TOKEN_URI";
              };
          picture
          =   {
                DISABLE_GRAVATAR        =   true;
              };
          repository
          =   {
                PREFERRED_LICENSES      =   "AGPL-3.0,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1";
              };
          server
          =   {
                START_SSH_SERVER        =   true;
                BUILTIN_SSH_SERVER_USER =   "gitea";
                SSH_PORT                =   2222;
                SSH_LISTEN_PORT         =   2222;
              };
          service
          =   {
                DISABLE_REGISTRATION    =   false;
              };
          sessions
          =   {
                COOKIE_SECURE           =   true;
              };
          ui
          =   {
                DEFAULT_THEME           =   "arc-green";
                THEMES                  =   "gitea,arc-green";
                THEME_COLOR_META_TAG    =   "#222222";
              };
          settings
          =   {
                inherit attachment repository log metrics picture server service sessions ui;
              };
        in
          { core, network, secret, ... }:
            let
              inherit(core) string;
              domain                    =   "git.${network.domain}";
              port                      =   string network.tcp.ports.gitea.http;
            in
            {
              gitea
              =   {
                    inherit domain settings;
                    appName             =   "_sivizius’ Gitea";
                    database
                    =   {
                          type          =   "postgres";
                          name          =   "gitea";
                          passwordFile  =   secret.generateToken "gitea-dbpass" { owner = "gitea"; };
                          user          =   "gitea";
                        };
                    enable              =   true;
                    httpAddress         =   "localhost";
                    rootUrl             =   "https://${domain}/";
                    #stateDir?
                    #mailerPasswordFile?
                  };

              nginx.virtualHosts.${domain}
              =   {
                    inherit enableACME forceSSL;
                    extraConfig         =   commonHeaders;
                    locations
                    =   {
                          "/"
                          =   {
                                proxyPass =   "http://localhost:${port}/";
                              };
                          "/metrics"
                          =   {
                                proxyPass =   "http://localhost:${port}/metrics";
                              };
                        };
                  };

              postgresql
              =   {
                    enable              =   true;
                    authentication
                    =   ''
                          local gitea all ident map=gitea-users
                        '';
                    identMap
                    =   ''
                          gitea-users gitea gitea
                        '';
                  };

              prometheus.scrapeConfigs
              =   [
                    {
                      bearer_token_file =   secret.generateToken' "prometheus/scrapeConfigs";
                      job_name          =   "gitea";
                      metrics_path      =   "/metrics";
                      scheme            =   "https";
                      scrape_interval   =   "30s";
                      static_configs
                      =   [
                            {
                              targets   =   [ domain ];
                            }
                          ];
                    }
                  ];
            };
    }
