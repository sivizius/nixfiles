{ nix, ... }:
  with nix;
  [
    iftop
    inetutils
    iperf
    mtr
    nload
    tcpdump
    wget
    zmap
  ]
