{ configurations, core, networks, ... }:
  let
    inherit(core)           debug set type;
    inherit(configurations) Configuration;

    Peer
    =   type "Peer"
        {
          from
          =   about:
              {
                configuration ? {},
                network       ? {},
                type          ? {},
              }:
                Peer.instanciate
                {
                  inherit about configuration network type;
                };
        };

    PeerConfiguration
    =   Configuration "Peer"
        {
          call
          =   { environment, host, ... }:
              { configuration, wrap, ... }:
                let
                  environment'
                  =   environment
                  //  { inherit(host) network profile system version; };
                in
                  wrap
                  {
                    configuration       =   configuration environment';
                  };
        };

    constructors
    =   {
          inherit Peer;
        };

    load
    =   source:
        environment:
          let
            config
            =   configurations.load
                  source
                  environment
                  constructors
                  Peer;
            configure'
            =   networkName:
                  set.map
                  (
                    peerName:
                    { ... } @ node:
                      let
                        domain
                        =   networks.extendName
                              networkName
                              peerName;
                        nodes           =   configure' domain node;
                      in
                        if Peer.isInstanceOf node
                        then
                          debug.debug "configure'"
                          {
                            text        =   "peer ${domain} from ${node.source}";
                            data        =   node;
                          }
                          { inherit domain; } // node
                        else
                          debug.debug "configure'"
                          {
                            text        =   "network ${domain}";
                            show        =   true;
                          }
                          nodes
                  );
          in
            if Peer.isInstanceOf config
            then
              config
            else
              debug.debug "configure"
              {
                text                    =   "result";
                show                    =   true;
                nice                    =   true;
              }
              (
                configure'
                  null
                  config
              );

  in
    constructors
    //  {
          inherit PeerConfiguration;
          inherit constructors load;
        }
