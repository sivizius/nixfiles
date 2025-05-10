{ profile, registries, ... }@env:
let
  pkgs = registries.nix;
in
{
  #enable = profile.isDesktop;
  enableGnomeExtensions = profile.isDesktop;

  languagePacks = [
    "en-GB"
    "de"
  ];

  package = pkgs.wrapFirefox pkgs.librewolf-unwrapped {
    extraPolicies = pkgs.callPackage ./policies.nix env;
    nixExtensions = pkgs.callPackage ./extensions.nix env;

    extraPrefs = ''
      // Show more ssl cert infos
      lockPref("security.identityblock.show_extended_validation", true);
    '';
  };
}
