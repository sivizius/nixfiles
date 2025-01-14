{
  wireless = Peer "Wireless Lan chaos"
    {
      configuration = { secret, ... }:
        {
          networking.wireless.networks = {
            "c3loc-guest" = { };
            "Chaosnetz".pskRaw = secret.decryptVariable' "wireless" ./Chaosnetz.asc;
            "Geekz.Karibik".pskRaw = secret.decryptVariable' "wireless" ./Geekz.Karibik.asc;
          };
        };
    };
}
