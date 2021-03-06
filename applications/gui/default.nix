{ pkgs, ... }:
{
  imports
  = [
      ./atom.nix
      ./browser.nix
      ./chemistry.nix
      ./darkweb.nix
      ./data.nix
      ./emulation.nix
      ./games.nix
      ./gnome.nix
      ./media.nix
      ./messenger.nix
      ./network.nix
      ./notifications.nix
      ./pentesting.nix
    ];

  environment.systemPackages
  = with pkgs;
    [
      alacritty
      deluge
      spotify
      xournal
    ];
}
