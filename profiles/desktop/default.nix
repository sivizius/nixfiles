{ profiles, services, ... }:
  Profile "Desktop."
  {
    configuration
    =   [
          ./fonts
          ./hardware
          {
            documentation
            =   {
                  enable                =   true;
                  dev.enable            =   true;
                  doc.enable            =   true;
                  info.enable           =   true;
                  man.enable            =   true;
                  nixos.enable          =   false;
                };
            security.pam.services
            =   {
                  # To make Swaylock unlockable.
                  swaylock              =   { /* empty */ };
                };
          }
        ];
    isDesktop                           =   true;
    parents                             =   with profiles; [ common ];
    services                            =   with services; [ printing ];
  }
