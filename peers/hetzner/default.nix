{ core, ... }:
  let
    inherit(core) set;
  in
    set.map
    (
      name:
      ips:
        let
          domain                        =   "${name}.hetzner.de";
        in
          Peer "${domain}."
          {
            type.dns-forwarder          =   true;
            network
            =   {
                  inherit domain ips;
                };
          }
    )
    {
      ns1-coloc                         =   [ "2a01:4f8:0:1::add:9898"  "213.133.98.98"   ];
      ns2-coloc                         =   [ "2a01:4f8:0:1::add:9999"  "213.133.99.99"   ];
      ns3-coloc                         =   [ "2a01:4f8:0:1::add:1010"  "213.133.100.100" ];
    }
