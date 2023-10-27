{ peers, profiles, users, ... }:
Host "mem (from hebrew מודיעין: intelligence) is installed on a mysterious laptop."
{
  config = [
    ./config.nix
    ./proxy.nix
    ./static-enp0s31f6.nix
  ];
  devices = {
    "/" = XFS "nixos" { uuid = "0eca973c-2680-4378-bd8e-9036a4fb03ab"; };
    "/boot" = VFAT "boot" { uuid = "5D65-C763"; };
  };
  network = {
    interfaces = {
      enp0s31f6.useDHCP = {
        _type = "override";
        content = true;
        priority = 1000;
      };
      wlp0s20f3.useDHCP = true;
      # wwp0s20u4i6.useDHCP = true;
    };
    peers = with peers;
      [
        deutsche-bahn
        sivizius
      ];
    wireless = {
      enable = true;
      interfaces = [ "wlp0s20f3" ];
      userControlled.enable = true;
    };
  };
  profile = profiles.desktop;
  system = "x86_64-linux";
  users = {
    sivizius = users.sivizius // { trusted = true; };
  };
  version = "23.05";
}
