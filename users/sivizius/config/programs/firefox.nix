{ profile, registries, ... }:
let
  pkgs = registries.nix;
in
{
  enable = profile.isDesktop;
  package = pkgs.wrapFirefox
    pkgs.firefox-unwrapped
    {
      extraPolicies = {
        ExtensionSettings = {
          # …
        };
      };
    };
}
