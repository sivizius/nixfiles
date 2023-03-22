{ core, ... }:
  let
    inherit(core) set;
  in
    set.map
    (
      name:
      ips:
        let
          domain                        =   "dns.google";
        in
          Peer "${domain} (${name})."
          {
            type.dns-forwarder          =   true;
            network
            =   {
                  inherit domain ips;
                };
          }
    )
    {
      ns1                               =   [ "2001:4860:4860::8888"  "8.8.8.8" ];
      ns2                               =   [ "2001:4860:4860::8844"  "8.8.4.4" ];
    }
