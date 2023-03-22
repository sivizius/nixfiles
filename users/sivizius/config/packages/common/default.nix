{ nix, ... }:
  with nix;
  [
    mailcap
    ./crypto.nix
    ./files.nix
    ./network.nix
    ./processes.nix
    ./ranger.nix
    ./sync.nix
    ./terminal.nix
  ]
