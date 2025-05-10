{
  webbot = Peer "Webbot Wireless LAN" {
    configuration =
      { secret, ... }:
      {
        networking.wireless.networks = {
          "Webbot".pskRaw = secret.decryptVariable' "wireless" ./Webbot.asc;
        };
      };
  };
}
