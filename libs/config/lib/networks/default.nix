{ configurations, core, peers, ... } @ lib:
  let
    inherit(configurations) Configuration';
    inherit(core)           debug list path set string type;
    inherit(peers)          Peer PeerConfiguration;

    NetworkConfiguration                =   Configuration' "Network";

    collect
    =   { allowedTCPPorts, allowedUDPPorts, hostName, interfaces, peers, source, wireless, ... }:
          debug.debug "collect"
          {
            text                        =   "peers";
            data                        =   peers;
          }
          [
            (
              NetworkConfiguration
              {
                configuration
                =   { secret, ... }:
                    {
                      networking
                      =   {
                            inherit hostName interfaces;
                            firewall
                            =   {
                                  enable      =   true;
                                  inherit allowedTCPPorts allowedUDPPorts;
                                };
                            wireless
                            =   wireless
                            //  {
                                  environmentFile
                                  =   secret.generateEnvFile' "wireless";
                                };
                          };
                    };
                inherit source;
              }
            )
          ]
          ++  (
                list.map
                  PeerConfiguration
                  peers
              );

    extendName
    =   networkName:
        peerName:
          if networkName != null
          then
            "${peerName}.${networkName}"
          else
            peerName;

    prepare
    =   environment:
        host:
        network:
          if set.isInstanceOf network
          then
            prepareNetwork environment host network
          else
            debug.panic
              "prepare"
              {
                text                    =   "The option `network` must be a set.";
                data                    =   network;
              };

    prepareNetwork
    =   { ... } @ environment:
        host:
          let
            checkIP
            =   {
                  addresses ? [ ],
                  routes    ? [ ],
                }:
                {
                  inherit addresses routes;
                };

            checkPort
            =   port:
                  if port >= 0 && port < 65356
                  then
                    port
                  else
                    debug.panic
                      [ "prepareNetwork" "checkPort" ]
                      "Invalid Port ${string port}. must be between including 0 and 65355";
            collectPorts
            =   ports:
                  list.concat
                  (
                    set.mapToList
                    (
                      name:
                      port:
                        type.matchPrimitiveOrPanic port
                        {
                          int           =   [ (checkPort port) ];
                          list          =   list.map checkPort port;
                          set           =   collectPorts port;
                        }
                    )
                    ports
                  );
            loadPeer
            =   peer:
                  peers.load
                    peer
                    environment;
            mapPeers
            =   networkName:
                peers:
                  list.concat
                  (
                    set.mapToList
                    (
                      peerName:
                      peer:
                        let
                          loadedPeer    =   loadPeer peer;

                          name
                          =   extendName
                                networkName
                                peerName;
                          namedPeer     =   { inherit name; } // loadedPeer;

                          source        =   host.source "network" "peers" namedPeer.name;
                        in
                          if Peer.isInstanceOf loadedPeer
                          then
                            [ ({ inherit source; } // namedPeer) ]
                          else
                            mapPeers name loadedPeer
                    )
                    peers
                  );
            mapPeers'                   =   mapPeers null;
          in
            {
              allowLegacyTLS  ? true,
              domain          ? null,
              interfaces      ? { },
              ips             ? [ ],
              peers           ? [ ],
              tcp             ? { },
              udp             ? { },
              wireless        ? { },
            }:
            {
              inherit allowLegacyTLS domain ips tcp udp wireless;
              allowedTCPPorts           =   collectPorts (tcp.ports or {});
              allowedUDPPorts           =   collectPorts (udp.ports or {});
              hostName                  =   host.name;
              interfaces
              =   set.map
                  (
                    name:
                    {
                      ipv4              ? {},
                      ipv6              ? {},
                      macAddress        ? null,
                      mtu               ? null,
                      proxyARP          ? false,
                      # tempAddress
                      useDHCP           ? true,
                      virtual           ? false,
                      virtualOwner      ? "root",
                      # virtualType
                      wakeOnLan         ? { enable = false; },
                      ...
                    } @ config:
                      config
                      //  {
                            inherit macAddress mtu name proxyARP useDHCP virtual virtualOwner wakeOnLan;
                            ipv4        =   checkIP ipv4;
                            ipv6        =   checkIP ipv6;
                          }
                  )
                  interfaces;
              peers
              =   type.matchPrimitiveOrPanic peers
                  {
                    list
                    =   mapPeers'
                        (
                          list.imapValuesToSet
                            (
                              index:
                              peer:
                              {
                                name    =   string index;
                                value   =   peer;
                              }
                            )
                            peers
                        );
                    set                 =   mapPeers' peers;
                  };
              source                    =   host.source "network";
            };
  in
  {
    inherit collect extendName prepare;
  }
