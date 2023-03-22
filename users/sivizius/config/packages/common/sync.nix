{ nix, ... }:
  with nix;
  [
    git
    restic
    rsync
    sshfs
  ]
