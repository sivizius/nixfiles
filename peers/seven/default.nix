{
  wireguard = Peer "Wireguard-Tunnel to seven@helsinki-systems"
    {
      configuration = { secret, ... }:
        {
          networking.wg-quick.interfaces."seven" = {
            address = [ "198.18.1.203/15" "fd00:5ec::1cb/48" ];
            autostart = false;
            mtu = 1380;
            peers = [
              {
                allowedIPs = [ "198.18.0.0/15" "fd00:5ec::/48" ];
                endpoint = "gateway.seven.secunet.com:51821";
                publicKey = "ZVayNyJeOn848aus5bqYU2ujNxvnYtV3ACoerLtDpg8=";
              }
            ];
            privateKeyFile = secret.decrypt' ./wgToken-2.asc;
          };
        };
    };
  binary-cache = Peer "Binary Cache by seven"
    {
      configuration.nix.settings = {
        substituters = [
          "http://seven-cache01.syseleven.seven.secunet.com"
          "http://seven-cache02.syseleven.seven.secunet.com"
        ];
        trusted-public-keys = [
          "seven-1:M1znlh60ChXxeuOXaxFVLTrmeJS+UpYVfmI5fmX2Itc="
        ];
      };
    };
}
