{ commonHttpConfig, enableACME, extraConfig, forceSSL, ... }:
  Service "Nginx: HTTP-Server"
  {
    configuration
    =   { config, core, network, store, web, ... }:
          let
            inherit(core)       debug list path set string type;
            inherit(network)    allowLegacyTLS domain hostName ips tcp;
            inherit(store)      write;
            inherit(tcp.ports)  exporters;

            websites
            =   let
                  importWebsite
                  =   value:
                        type.matchPrimitiveOrPanic value
                        {
                          lambda        =   value { inherit core store web; } { inherit domain hostName; };
                          null          =   {};
                          path          =   importWebsite (path.import value);
                          set           =   value;
                        };
                in
                  importWebsite (path.import ./hosts).${hostName};

            allowedIPs
            =   string.concatMappedLines
                  (ip: "allow ${ip};")
                  ips;

            locations
            =   let
                  extraConfig
                  =   ''
                        ${allowedIPs}
                        deny all;
                      '';
                in
                {
                  "/metrics/nginx"
                  =   {
                        inherit extraConfig;
                        proxyPass       =   "http://localhost:${string exporters.nginx}/metrics";
                      };
                  "/metrics/node"
                  =   {
                        inherit extraConfig;
                        proxyPass       =   "http://localhost:${string exporters.node}/metrics";
                      };
                };

            comments
            =   {
                  Acknowledgments       =   "Our security acknowledgments page";
                  Canonical             =   "Canonical URI for this file";
                  Contact               =   "Our security address";
                  Encryption            =   "Our OpenPGP key";
                  Expires               =   "DO NOT USE this security.txt after this date";
                  Hiring                =   "Open job-positions";
                  Policy                =   "Our security policy";
                  Preferred-Languages   =   "Preferred Languages for security reports";
                };

            sign
            =   message:
                signature:
                  let
                    text                =   string.concatLines (message ++ [ "" ]);
                    result
                    =   string.concatLines
                        (
                          [ "-----BEGIN PGP SIGNED MESSAGE-----" "Hash: SHA256\n" ]
                          ++  message
                          ++  [ "-----BEGIN PGP SIGNATURE-----\n" ]
                          ++  [ (string.trim signature) ]
                          ++  [ "-----END PGP SIGNATURE-----\n" ]
                        );
                  in
                    debug.panic "sign"
                    {
                      text
                      =   ''
                            Missing signature for message, run:
                            cat ${path.toFile "message" text} | gpg --clearsign | tail -n 14 | head -n -1
                          '';
                      when              =   signature == null;
                      nice              =   true;
                    }
                    debug.info "sign"
                    {
                      text
                      =   ''
                            Please verify this signed message:
                            cat ${path.toFile "message" result} | gpg --verify
                          '';
                    }
                    result;

            mapLocation
            =   domain:
                location:
                {
                  index       ? "index.html",
                  redirect    ? null,
                  root        ? null,
                  tryFiles    ? "$uri $uri.html $uri.txt $uri.asc /index.html",
                  well-known  ? {},
                  ...
                }:
                  let
                    foo
                    =   string.replace'
                        {
                          "\t"          =   "_";
                          "\n"          =   "_";
                          "\r"          =   "_";
                          " "           =   "_";
                          "@"           =   "-at-";
                          "/"           =   "-";
                        };
                    directory
                    =   write.directory (foo (if location == "/" then domain else "${domain}${location}"))
                        (
                          set.map
                            (
                              fileName:
                              page:
                                if path.isInstanceOf page
                                then
                                  "${page}"
                                else
                                  path.toFile (foo fileName) "${page}"
                            )
                            root
                            //  canary-txt
                            //  security-txt
                        );

                    canary-txt
                    =   let
                          inherit(well-known."canary.txt") body signature;
                        in
                          set.ifOrEmpty (well-known."canary.txt" or {} != {})
                          {
                            ".well-known/canary.txt"
                            =   path.toFile "canary.txt" (sign body signature);
                          };

                    security-txt
                    =   let
                          inherit(well-known."security.txt") body signature;
                          format
                          =   name:
                              value:
                                [ "" "# ${comments.${name}}" ]
                                ++  (
                                      if list.isInstanceOf value
                                      then
                                        list.map
                                          ( "${name}: ${value}" )
                                          value
                                      else
                                        [ "${name}: ${value}" ]
                                    );
                        in
                          set.ifOrEmpty (well-known."security.txt" or {} != {})
                          {
                            ".well-known/security.txt"
                            =   path.toFile "security.txt"
                                (
                                  sign
                                    (list.tail (list.concat (set.mapToList format body)))
                                    signature
                                );
                          };
                  in
                    if root != null
                    then
                    {
                      inherit index tryFiles;
                      root                =   "${directory}";
                    }
                    else if redirect != null
                    then
                    {
                      return            =   "301 ${redirect}";
                    }
                    else
                      debug.panic
                        "mapLocation"
                        "Either root or redirect must be set!";

            sslProtocols
            =   if allowLegacyTLS
                then
                  "TLSv1.2 TLSv1.3"
                else
                  "TLSv1.3";
          in
          {
            nginx
            =   {
                  inherit commonHttpConfig sslProtocols;
                  enable                    =   true;
                  recommendedGzipSettings   =   true;
                  recommendedOptimisation   =   true;
                  recommendedProxySettings  =   true;
                  recommendedTlsSettings    =   true;
                  statusPage                =   true;
                  virtualHosts
                  =   set.mapNamesAndValues
                      (
                        subdomain:
                        locations':
                          let
                            fqdn
                            =   if subdomain != ""
                                then
                                  "${subdomain}.${domain}"
                                else
                                  domain;
                          in
                          {
                            name        =   fqdn;
                            value
                            =   {
                                  inherit enableACME extraConfig forceSSL;
                                  locations
                                  =   locations
                                  //  (set.map (mapLocation fqdn) locations');
                                };
                          }
                      )
                      websites;
                };
          };
  }
