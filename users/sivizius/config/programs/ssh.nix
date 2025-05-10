# user,
{ ... }:
/*
  let
  /*default
   = { user, hostname, identityFile }:
        {
          checkHostIP = true;
          compression = true;
          forwardAgent = false;
          forwardX11 = false;
          identitiesOnly = false;
          sendEnv = [  ];
          user = username;
          inherit hostname identityFile;
        };
  in
*/
{
  enable = true;
  addKeysToAgent = "confirm";
  compression = true;
  controlMaster = "auto";
  controlPath = "~/.cache/ssh/control/%r@%n:%p";
  controlPersist = "10m";
  forwardAgent = false;
  hashKnownHosts = true;
  includes = [ "~/.config/ssh/extra.config" ];
  matchBlocks = {
    "nixbuilder-*.factory.secunet.com" = {
      user = "nixbuild";
      identitiesOnly = true;
    };
    #          "aleph" = default { identityFile = ""; user = user.name; hostname = "aleph.sivizius.eu"; };
    #          "*.sivizius.eu" = default { identityFile = ""; user = user.name; hostname = "%h"; };
  };
  serverAliveCountMax = 4;
  serverAliveInterval = 60;
  userKnownHostsFile = "~/.local/share/ssh/known_hosts";
}
