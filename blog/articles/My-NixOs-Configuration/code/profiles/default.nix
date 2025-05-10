{ services, ... }:
let
  profiles
  =   {
        common
        =   Profile "Common Configurations."
            {
              config = ./common;
            };
        desktop
        =   Profile "Desktop Host."
            {
              config    = ./desktop;
              isDesktop = true;
              parents   = with profiles; [ common ];
              services  = with services; [ gnupg ];
            };
        hetznerCloudServer
        =   Profile "Hetzner Cloud-Server."
            {
              config    = ./hetznerCloudServer;
              isDesktop = false;
              parents   = with profiles; [ common qemu-guest ];
              services  = with services; [ bind gnupg monitoring nginx ];
            };
        physicalServer
        =   null;
        qemu-guest
        =   null;
        # …
      };
in
  profiles