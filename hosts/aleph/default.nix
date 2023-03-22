#![in_scope(Host, XFS, VFAT)]
{ peers, profiles, users, ... }:
  Host  "aleph (a silent letter in hebrew) is usually installed as sivizius on sivizius.eu"
  {
    config
    =   [
          ./homepage
          ./mail.nix
        ];
    devices
    =   {
          "/"                           =   XFS   "system"  { uuid = "2c26bb06-d932-486d-b48b-365d6cfc076e"; };
          "/boot"                       =   VFAT  "boot"    { uuid = "F276-B461";                            };
        };
    network
    =   let
          IP                            =   "2a01:4f9:c010:6bf5::23";
          legacyIP                      =   "95.217.131.201";
        in
        {
          domain                        =   "sivizius.eu";
          allowLegacyTLS                =   true;
          interfaces.ens3
          =   {
                ipv6.addresses
                =   [
                      {
                        address         =   IP;
                        prefixLength    =   64;
                      }
                    ];
                useDHCP                 =   true;
              };
          ips
          =   [
                legacyIP
                "${IP}/64"
              ];
          peers
          =   with peers;
              [
                fluepke.wireguard
                google
                hetzner
                petabytedev
              ];
          tcp.ports
          =   {
                dns                     =   53;
                exporters
                =   {
                      bind              =   9119;
                      nginx             =   9113;
                      node              =   9100;
                    };
                gitea
                =   {
                      http              =   3000;
                      ssh               =   2222;
                    };
                grafana                 =   3001;
                http                    =   80;
                https                   =   443;
                initrd.ssh              =   2222;
                prometheus              =   9090;
              };
          udp.ports
          =   {
                dns                     =   53;
              };
        };
    profile                             =   profiles.hetznerCloudServer;
    system                              =   "x86_64-linux";
    users
    =   {
          sivizius                      =   users.sivizius // { trusted = true; };
        };
    version                             =   "23.05";
  }

