{ peers, profiles, users, ... }:
  Host "bet (from hebrew בית: house) is usually installed on localhost."
  {
    devices
    =   {
          "/"                           =   XFS   "system"  { uuid = "6ec7d726-6ef6-4e86-b382-2b4b6933f3e9";  };
          "/boot"                       =   VFAT  "boot"    { uuid = "C7DE-E0D7";                             };
          "swap"                        =   Swap            { uuid = "d7553993-772b-4979-abae-9127c65bdb05";  };
        };
    network
    =   {
          interfaces
          =   {
                enp0s25.useDHCP         =   true;
                wlp3s0.useDHCP          =   true;
              # wwp0s20u4i6.useDHCP     =   true;
              };
          peers
          =   with peers;
              [
                chaos
                deutsche-bahn
                eduroam
                fluepke
                mum
                sivizius
                tuc
              ];
          tcp.ports
          =   {
                http                    =   8080;
              };
          wireless
          =   {
                enable                  =   true;
                interfaces              =   [ "wlp3s0"  ];
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
