{ core, foreign, ... }@libs:
let
  inherit (core) path;
  inherit (foreign) home-manager nixpkgs simple-nixos-mailserver;
in
{
  nixos = {
    inherit (nixpkgs.nixosModules) notDetected;
    inherit (home-manager.nixosModules) home-manager;
    default = {
      _file = "${nixpkgs}/nixos/modules/module-list.nix";
      imports = path.import "${nixpkgs}/nixos/modules/module-list.nix";
    };
    #nano = import ./nano.nix;
    simple-nixos-mailserver = simple-nixos-mailserver.nixosModules.mailserver;
  };
}
