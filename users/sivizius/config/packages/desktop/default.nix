{ nix, ... }:
  with nix;
  [
    pass-wayland
    swaybg
    wdisplays
    wev
    wl-clipboard
    ./applications
    ./tools
  ]
