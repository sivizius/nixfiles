{ core, ... }:
  let
    inherit(core) string;

    Peer'
    =   number:
        domain:
        ips:
          Peer "Domain Name Server ${string number}"
          {
            network                     =   { inherit domain ips; };
            type.dns-secondary          =   true;
          };
  in
  {
    dns1                                =   Peer' 1 "ns1.pbb.lc"  [ "2a01:4f8:c0c:473f::1" ];
    dns2                                =   Peer' 2 "ns2.pbb.lc"  [ "2a0f:4ac0:0:1::1" ];
    dns3                                =   Peer' 3 "ns3.pbb.lc"  [ "2a0f:4ac0::3" ];
  }
