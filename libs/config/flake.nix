{
  description = "Configure and Deploy NixOS";
  inputs = {
    libcore = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=libs/core";
      inputs.libintrinsics.follows = "libintrinsics";
    };
    libintrinsics.url = "github:sivizius/nixfiles?ref=secunet&dir=libs/intrinsics";
    libsecrets = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=libs/secrets";
      inputs = {
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        libstore.follows = "libstore";
      };
    };
    libstore = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=libs/store";
      inputs = {
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
      };
    };
    libweb = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=libs/web";
      inputs = {
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config2";
  };
  outputs =
    {
      self,
      libcore,
      libsecrets,
      libstore,
      libweb,
      nixpkgs,
      ...
    }:
    let
      core = libcore.lib {
        inherit self;
        debug.logLevel = "info";
      };
    in
    core.path.import ./. {
      inherit core nixpkgs;
      secrets = libsecrets.lib { inherit self; };
      store = libstore.lib;
      inherit (libsecrets.nixosModules) vault;
      web = libweb.lib { inherit self; } // {
        module = libweb.nixosModules.default;
      };
    };
}
