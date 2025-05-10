Service "GNU Privacy Guard" {
  configuration =
    { registries, ... }:
    {
      programs.gnupg = {
        agent = {
          enable = true;
          enableBrowserSocket = false;
          enableExtraSocket = false;
          enableSSHSupport = true;
          pinentryPackage = registries.nix.pinentry-gnome3;
        };
        dirmngr.enable = false;
        package = registries.nix.gnupg;
      };
    };
  legacy = true;
}
