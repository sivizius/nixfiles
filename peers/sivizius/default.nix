{
  phone
  =   Peer "Siviphone"
      {
        configuration
        =   { secret, ... }:
            {
              networking.wireless.networks
              =   {
                    "SiviPhone"
                    =   {
                          psk           =   secret.decryptVariable' "wireless" ./SiviPhone.asc;
                          authProtocols =   [ "WPA-PSK" "WPA-EAP" "FT-PSK" "FT-EAP" ];
                        };
                  };
            };
      };
}
