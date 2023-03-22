{ nix, ... }:
  with nix;
  [
    ./development
    ./hardware.nix
    ./network.nix
    ./spelling.nix
    nix-index
    nix-prefetch-git
    nix-prefetch-github
    xdg_utils
  ]
