{
  wireless
  =   Peer "Wireless Lan chaos"
      {
        configuration
        =   { secret, ... }:
            {
              networking.wireless.networks
              =   {
                    "c3loc-guest"       =   {};
                    "Chaosnetz".psk     =   secret.decryptVariable' "wireless" ./Chaosnetz.asc;
                    "Geekz.Karibik".psk =   secret.decryptVariable' "wireless" ./Geekz.Karibik.asc;
                  };
            };
      };
}
