{
  description = "Sivizius’ profiles.";
  inputs = {
    libconfig = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=libs/config";
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
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config2";
    services = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=services";
      inputs = {
        libconfig.follows = "libconfig";
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        libsecrets.follows = "libsecrets";
        libstore.follows = "libstore";
        libweb.follows = "libweb";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs =
    {
      self,
      nixos-hardware,
      libcore,
      libconfig,
      nixpkgs,
      services,
      ...
    }:
    let
      core = libcore.lib {
        inherit self;
        debug.logLevel = "info";
      };
      config = libconfig.lib { inherit self; };

      inherit (core) context set;
      inherit (config.profiles) load importLegacy mapLegacy;

      legacyProfiles = importLegacy { inherit nixpkgs; } [
        "all-hardware"
        "base"
        "clone-config"
        "demo"
        "docker-container"
        "graphical"
        "hardened"
        "headless"
        "installation-device"
        "minimal"
        "qemu-guest"
      ];

      mapLegacy' =
        source: profiles:
        mapLegacy (
          set.map (name: configuration: {
            inherit configuration;
            source = source name;
          }) profiles
        );

      profiles =
        legacyProfiles
        // mapLegacy' (context "github:NixOS/nixos-hardware" [
          { fileName = "flake.nix"; }
          "outputs"
          "nixosModules"
        ]) nixos-hardware
        // load ./. {
          inherit core profiles;
          inherit (services) services;
        };
    in
    {
      profiles = core.debug.debug "profiles" {
        nice = true;
        show = true;
        when = false;
      } profiles;
    };
}
