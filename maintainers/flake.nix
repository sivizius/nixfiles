{
  description = "Maintainers and Teams";
  inputs = {
    libconfig = {
      url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/config";
      inputs = {
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        libsecrets.follows = "libsecrets";
        libstore.follows = "libstore";
        libweb.follows = "libweb";
        nixpkgs.follows = "nixpkgs";
      };
    };
    libcore = {
      url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/core";
      inputs.libintrinsics.follows = "libintrinsics";
    };
    libintrinsics.url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/intrinsics";
    libsecrets = {
      url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/secrets";
      inputs = {
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        libstore.follows = "libstore";
      };
    };
    libstore = {
      url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/store";
      inputs = {
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
      };
    };
    libweb = {
      url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/web";
      inputs = {
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config2";
  };
  outputs = { libconfig, libcore, ... }:
    let
      context = [ "maintainers" ];
      inherit (libcore.lib) path;
      inherit (libconfig.lib) maintainers;

      import' = directory:
        path.import
          directory
          { inherit (maintainers) GitHub Fingerprint Maintainer Team; }
          { inherit people teams; };

      people = maintainers.checkPeople (import' ./people);
      teams = maintainers.checkTeams (import' ./teams);
    in
    { inherit people teams; };
}
