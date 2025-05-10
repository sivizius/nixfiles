{ profiles, services, ... }:
Profile "Desktop." {
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
          swaylock = {
            # empty
          };
        };

        # GNOME crypto services (daemon and tools)
        programs.dconf.enable = true;
        services.dbus.packages = [ registries.nix.gcr ];

        # For Screen Sharing
        services.pipewire.enable = true;
        xdg = {
          portal = {
            enable = true;
            configPackages = with registries.nix; [
              xdg-desktop-portal-wlr
              xdg-desktop-portal-gtk
            ];
          };
        };

        # Compress Volatile Memory With zram
        zramSwap = {
          enable = true;
          algorithm = "zstd";
          memoryMax = null;
          #memoryPercent = 50;
          #priority = 5;
          swapDevices = 1;
          #memoryPercent = null;
        };
      }
    )
  ];
  isDesktop = true;
  parents = with profiles; [ common ];
  services = with services; [
    printing
    gnome-keyring
    pulseaudio
    yubikey-touch-detector
  ];
}
