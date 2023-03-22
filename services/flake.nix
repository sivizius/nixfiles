{
  description                           =   "Sivizius’ services.";
  inputs
  =   {
        libconfig.url                   =   "github:sivizius/nixfiles/development?dir=libs/config";
        libweb.url                      =   "github:sivizius/nixfiles/development?dir=libs/web";
      };
  outputs
  =   { self, libconfig, libweb, ... }:
      {
        services
        =   let
              commonHeaders
              =   ''
                    add_header Cache-Control              $cacheable_types;
                    add_header Feature-Policy             "accelerometer none; camera none; geolocation none; gyroscope none; magnetometer none; microphone none; payment none; usb none;";
                    add_header Referrer-Policy            "no-referrer-when-downgrade"                                    always;
                    add_header Strict-Transport-Security  $hsts_header                                                    always;
                    add_header X-Content-Type-Options     "nosniff";
                    add_header X-Frame-Options            "SAMEORIGIN";
                    add_header X-Xss-Protection           "1; mode=block";
                  '';

              commonHttpConfig
              =   ''
                    charset utf-8;
                    map $scheme $hsts_header
                    {
                      https "max-age=31536000; includeSubdomains; preload";
                    }
                    map $sent_http_content_type $cacheable_types
                    {
                      "text/html"                 "public; max-age=3600;      must-revalidate"; # 1.0 h
                      "text/plain"                "public; max-age=3600;      must-revalidate"; # 1.0 h
                      "text/css"                  "public; max-age=15778800;  immutable";       # 0.5 a
                      "application/javascript"    "public; max-age=15778800;  immutable";       # 0.5 a
                      "font/woff2"                "public; max-age=15778800;  immutable";       # 0.5 a
                      "application/xml"           "public; max-age=3600;      must-revalidate"; # 1.0 h
                      "image/jpeg"                "public; max-age=15778800;  immutable";       # 0.5 a
                      "image/png"                 "public; max-age=15778800;  immutable";       # 0.5 a
                      "image/webp"                "public; max-age=15778800;  immutable";       # 0.5 a
                      default                     "public; max-age=1209600";                    # 2.0 w
                    }
                  '';

              extraConfig
              =   ''
                    ${commonHeaders}
                    add_header Content-Security-Policy    "default-src 'self'; frame-ancestors 'none'; object-src 'none'" always;
                  '';
            in
              (libconfig.lib { inherit self; }).services.load ./.
              {
                inherit commonHeaders commonHttpConfig extraConfig;
                enableACME              =   true;
                forceSSL                =   true;
                web                     =   libweb.lib { inherit self; };
              };
      };
}
