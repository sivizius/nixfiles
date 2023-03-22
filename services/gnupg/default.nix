Service "GNU Privacy Guard"
{
  configuration
  =   { registries, ... }:
      {
        programs.gnupg
        =   {
              agent
              =   {
                    enable              =   true;
                    enableBrowserSocket =   false;
                    enableExtraSocket   =   false;
                    enableSSHSupport    =   true;
                    pinentryFlavor      =   "qt";
                  };
              dirmngr.enable            =   false;
              package                   =   registries.nix.gnupg;
            };
      };
  legacy                                =   true;
}
