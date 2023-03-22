{ profiles, services, ... }:
  Profile "Hetzner Cloud-Server."
  {
    configuration
    =   [
          ./hardware
          {
            documentation.enable        =   false;
          }
        ];
    isDesktop                           =   false;
    parents                             =   with profiles; [ common qemu-guest ];
    services                            =   with services; [ bind gitea monitoring nginx simple-nix-mail static ];
  }
