{ core, network, users, ... }:
  let
    inherit(core) set;
  in
  {
    boot.initrd.network
    =   {
          enable                          =   true;
          postCommands
          =   ''
                echo 'cryptsetup-askpass' >> /root/.profile
              '';
          ssh
          =   {
                # TODO: We might not trust every user.
                authorizedKeys
                =   set.foldValues
                    (
                      authorizedKeys:
                      { trusted, user, ... }:
                        if trusted
                        then
                          authorizedKeys ++ (user.keys.${network.hostName} or [])
                        else
                          authorizedKeys
                    )
                    []
                    users;
                enable                  =   true;
                # List of Paths to Private Keys as Strings.
                hostKeys                =   [ "/etc/initrdSecret.ssh"  ];
                port                    =   network.tcp.ports.initrd.ssh;
              };
        };

    networking
    =   {
          defaultGateway6
          =   {
                address                 =   "fe80::1";
                interface               =   "ens3";
              };
        };

    security.acme
    =   {
          acceptTerms                   =   true;
          defaults
          =   {
                email                   =   "cert@${network.domain}";
              };
        };
  }
