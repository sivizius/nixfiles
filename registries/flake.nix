{
  description = "Packages";
  inputs = {
    fork-awesome = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=packages/fork-awesome";
      inputs = {
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        nixpkgs.follows = "nixpkgs";
      };
    };
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
    nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config2";
    wofi-unpatched = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=packages/wofi-unpatched";
      inputs = {
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs =
    {
      self,
      fork-awesome,
      libconfig,
      libcore,
      nixpkgs,
      wofi-unpatched,
      ...
    }:
    let
      inherit (libconfig.lib { inherit self; }) packages;
      inherit
        (libcore.lib {
          inherit self;
          debug.logLevel = "info";
        })
        path
        set
        target
        ;

      config = {
        allowedNonSourcePackages = [
          "adoptopenjdk-hotspot-bin"
          "ant"
          "cargo-bootstrap"
          "ghidra"
          "go-1.21.0-linux-amd64-bootstrap"
          "go"
          "gradle"
          "i2p"
          "iscan"
          "iscan-data"
          "iscan-gt-f720-bundle"
          "iscan-gt-s80-bundle"
          "iscan-gt-x770-bundle"
          "iscan-gt-x820-bundle"
          "iscan-nt-bundle"
          "iscan-perfection-v550-bundle"
          "pdftk"
          "rustc"
          "rustc-bootstrap"
          "sof"
          "sof-firmware"
          "temurin-bin"
          "tor-browser"
          "vscodium"
          "wine"
        ];
        allowedUnfreePackages = [
          "hplip"
          "iscan"
          "iscan-data"
          "iscan-gt-f720-bundle"
          "iscan-gt-s80-bundle"
          "iscan-gt-x770-bundle"
          "iscan-gt-x820-bundle"
          "iscan-nt-bundle"
          "iscan-perfection-v550-bundle"
        ];
      };

      custom = target.System.mapStdenv (system: {
        fork-awesome = fork-awesome.packages."${system}";
        wofi-unpatched = wofi-unpatched.packages."${system}";
      });

      registries = {
        inherit custom;
      } // (set.mapValues (packages.fromNixpkgs { inherit config nixpkgs; }) (path.import ./.));
    in
    #builtins.trace self._type
    #debug.debug "registries" { text = "Hello World"; when = true; }
    {
      registries =
        (target.System.mapStdenv (system: set.mapValues (registry: registry."${system}") registries))
        // {
          __functor = registries: { targetSystem, ... }: registries."${targetSystem}" // { inherit nixpkgs; };
        };
    };
}
