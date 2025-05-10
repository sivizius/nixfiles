{ nixpkgs, ... }:
let
  mapHosts = builtins.mapAttrs (name: nixpkgs.lib.nixosSystem);
  hosts
  =   {
        foo
        =   {
              system = "x86_64-linux";
              modules
              =   [
                    ./common  # Just put common stuff in common/default.nix
                    ./foo     # and foo-specific in foo/default.nix
                  ];
            };
        bar
        =   {
              system = "x86_64-linux";
              modules
              =     [
                      ./common
                      ./bar
                    ];
            };
      };
in
{
  nixosConfigurations = mapHosts hosts;
}