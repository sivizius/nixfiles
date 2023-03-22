{
  webbot
  =   Peer "Webbot Wireless LAN"
      {
        configuration
        =   { secret, ... }:
            {
              networking.wireless.networks
              =   {
                    "Webbot".psk        =   secret.decryptVariable' "wireless" ./Webbot.asc;
                  };
            };
      };
}
