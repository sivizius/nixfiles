{ profile, registries, ... }:
let
  pkgs = registries.nix;
in
{
  enable = profile.isDesktop;
  #package = pkgs.wrapFirefox
  #  pkgs.firefox-unwrapped
  #  {
  #    extraPolicies = {
  #      ExtensionSettings = {
  #        # …
  #      };
  #    };
  #    nativeMessagingHosts.packages = with registries.nix; [ gnome-browser-connector ];
  #  };
  #profiles.default = {
  #  bookmarks = [];
  #  #extensions = with {}; [];
  #
  #};
}
