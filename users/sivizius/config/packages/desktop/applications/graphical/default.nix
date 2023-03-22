{ nix, custom, ... }:
  with nix;
  [
    deluge
    #custom.redshift-wayland
    spotify
    system-config-printer
    vscodium
    xournal
    ./browser.nix
    ./chemistry.nix
    ./darkweb.nix
    ./data.nix
    ./emulation.nix
    ./games.nix
    ./gnome.nix
    ./media.nix
    ./messenger.nix
    ./notifications.nix
    ./pentesting.nix
    xsane
  ]
