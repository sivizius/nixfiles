{
  wireguard
  =   Peer "Wireguard-Tunnel to …?"
      {
        configuration
        =   { secret, ... }:
            {
              networking.wg-quick.interfaces."fluepke"
              =   {
                    address
                    =   [
                          "45.158.43.132/32"
                        ];
                    autostart           =   false;
                    peers
                    =   [
                          {
                            allowedIPs  =   [ "0.0.0.0/0" ];
                            endpoint    =   "45.158.43.1:51213";
                            publicKey   =   "PZlXawIBMsmOkesNbwSsiufvicbNgKaeyQ560novDHY=";
                          }
                        ];
                    privateKeyFile      =   secret.decrypt' ./wgToken.asc;
                  };
            };
      };
  wireless
  =   Peer "Wireless Lan fluepke"
      {
        configuration
        =   { secret, ... }:
            {
              networking.wireless.networks
              =   {
                    Paketschleuder.psk  =   secret.decryptVariable' "wireless" ./Paketschleuder.asc;
                    Vodafone-F88C.psk   =   secret.decryptVariable' "wireless" ./Vodafone-F88C.asc;
                    "wifi.fluep.ke".psk =   secret.decryptVariable' "wireless" ./wifi.fluep.ke.asc;
                  };
            };
      };
}
