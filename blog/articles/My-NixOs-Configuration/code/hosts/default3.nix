{ profiles, services, users, ... }:
let
  network
  =   {
        pc
        =   Host "My Personal Computer."
            {
              config    = ./pc;
              profile   = profiles.desktop;
              system    = "x86_64-linux";
              users     = { inherit sivizius; };
            };
        laptop
        =   Host "My Laptop Computer."
            {
              config    = ./laptop;
              profile   = profiles.desktop;
              system    = "x86_64-linux";
              users     = { inherit sivizius; };
            };
        cloud1
        =   Host "My First Cloud-Server at Hetzner."
            {
              config    = ./cloud1;
              network
              =   {
                    domain = "one.sivizius.eu";
                    ip
                    =   [
                          "198.51.100.23"
                          "2001:db8::23"
                        ];
                    peers
                    =   with hosts;
                        [
                          dns
                        ];
                  };
              profile   = profiles.hetznerCloudServer;
              services  = with services; [ gitea ];
              system    = "x86_64-linux";
              users     = { inherit sivizius; };
            };
        cloud2
        =   Host "My Second Cloud-Server at Hetzner."
            {
              config    = ./cloud2;
              network
              =   {
                    domain = "two.sivizius.eu";
                    ip
                    =   [
                          "198.51.100.42"
                          "2001:db8::42"
                        ];
                    peers
                    =   with hosts;
                        [
                          dns
                        ];
                  };
              profile   = profiles.hetznerCloudServer;
              system    = "x86_64-linux";
              users     = { inherit foobar sivizius; };
            };
        dns
        =   Peer "Secondary Domain Name Server"
            {
              network
              =   {
                    domain = "dns.example.com";
                    ips
                    =   [
                          "198.51.100.1"
                          "2001:db8::1"
                        ];
                  };
              type.dns-secondary  = true;
            };
        physical
        =   Host "My Physical Server in a Co-Location."
            {
              config    = ./physical;
              profile   = profiles.physicalServer;
              services  = with services; [ gitea ];
              system    = "x86_64-linux";
              users     = { inherit sivizius; };
            };
      };
in
  network