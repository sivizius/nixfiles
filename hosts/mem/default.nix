{ peers, profiles, users, ... }:
  Host "mem (from hebrew מודיעין: intelligence) is installed on a mysterious laptop."
  {
    devices
    =   {
          "/"                           =   XFS   "nixos"  { uuid = "";  };
          "/boot"                       =   VFAT  "boot"    { uuid = "";  };
        };
    network
    =   {
          interfaces
          =   {
                enp0s31f6.useDHCP       =   true;
                wlp0s20f3.useDHCP       =   true;
              # wwp0s20u4i6.useDHCP     =   true;
              };
          peers
          =   with peers;
              [
                sivizius
              ];
          wireless
          =   {
                enable                  =   true;
                interfaces              =   [ "wlp0s20f3"  ];
                userControlled.enable   =   true;
              };
        };
    profile                             =   profiles.desktop;
    system                              =   "x86_64-linux";
    users
    =   {
          sivizius                      =   users.sivizius // { trusted = true; };
        };
    version                             =   "23.05";
  }
