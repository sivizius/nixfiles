{ /*user,*/ ... }:
  /*let
    /*default
    =   { user, hostname, identityFile }:
        {
          checkHostIP                   =   true;
          compression                   =   true;
          forwardAgent                  =   false;
          forwardX11                    =   false;
          identitiesOnly                =   false;
          sendEnv                       =   [  ];
          user                          =   username;
          inherit hostname identityFile;
        };
  in*/
  {
    enable                              =   true;
    controlMaster                       =   "auto";
    controlPersist                      =   "10m";
    hashKnownHosts                      =   true;
    matchBlocks
    =   {
#          "aleph"                       =   default { identityFile = ""; user = user.name; hostname = "aleph.sivizius.eu"; };
#          "*.sivizius.eu"               =   default { identityFile = ""; user = user.name; hostname = "%h"; };
        };
    userKnownHostsFile                  =    "~/.local/share/ssh/known_hosts";
  }
