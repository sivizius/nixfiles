{ profiles, services, ... }:
Profile "Desktop."
{
  configuration = [
    ./fonts
    ./hardware
    (
      { registries, ... }:
      {
        documentation = {
          enable = true;
          dev.enable = true;
          doc.enable = true;
          info.enable = true;
          man.enable = true;
          nixos.enable = false;
        };
        security.pam.services = {
          # To make Swaylock unlockable.
          swaylock = { /* empty */ };
        };

        # For Screen Sharing
        services.pipewire.enable = true;
        xdg = {
          portal = {
            enable = true;
            extraPortals = with registries.nix; [
              xdg-desktop-portal-wlr
              xdg-desktop-portal-gtk
            ];
          };
        };

      }
    )
  ];
  isDesktop = true;
  parents = with profiles; [ common ];
  services = with services; [ printing gnome-keyring yubikey-touch-detector ];
}
