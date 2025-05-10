{
  description = "My NixOS-Configuration";
  inputs
  =   {
        nixpkgs.url = "github:NixOS/nixpkgs/master";
        # Some other flakes
      };
  outputs
  =   { nixpkgs, ... }:
      {
        nixosConfigurations.foo
        =   nixpkgs.lib.nixosSystem
            {
              system  = "x86_64-linux";
              modules = [./configuration.nix];
            };
      };
}