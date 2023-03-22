Service "Docker"
{
  configuration
  =   { core, registries, ... }:
      {
        virtualisation.docker
        =   {
              autoPrune
              =   {
                    dates               =   "weekly";
                    enable              =   false;
                    flags               =   [];
                  };
              daemon.settings           =   {};
              enable                    =   true;
              enableNvidia              =   false;
              enableOnBoot              =   false;
              extraOptions              =   "";
              listenOptions             =   [];
              liveRestore               =   true;
              logDriver                 =   "journald";
            };
      };
  legacy                                =   true;
}
