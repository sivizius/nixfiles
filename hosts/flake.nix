{
  description = "Sivizius’ hosts.";
  inputs = {
    flake-compat.url = "github:edolstra/flake-compat";
    fork-awesome = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=packages/fork-awesome";
      inputs = {
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        nixpkgs.follows = "nixpkgs";
      };
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        #gitignore.inputs.nixpkgs.follows = "nixpkgs";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-wrapper = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=home-manager";
      inputs = {
        home-manager.follows = "home-manager";
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
    modules = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=modules";
      inputs = {
        flake-compat.follows = "flake-compat";
        home-manager.follows = "home-manager";
        libconfig.follows = "libconfig";
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        libsecrets.follows = "libsecrets";
        libstore.follows = "libstore";
        libweb.follows = "libweb";
        nixpkgs.follows = "nixpkgs";
        simple-nixos-mailserver.follows = "simple-nixos-mailserver";
      };
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config2";
    peers = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=peers";
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
    profiles = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=profiles";
      inputs = {
        libconfig.follows = "libconfig";
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        libsecrets.follows = "libsecrets";
        libstore.follows = "libstore";
        libweb.follows = "libweb";
        nixos-hardware.follows = "nixos-hardware";
        nixpkgs.follows = "nixpkgs";
        services.follows = "services";
      };
    };
    registries = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=registries";
      inputs = {
        fork-awesome.follows = "fork-awesome";
        libconfig.follows = "libconfig";
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
        libsecrets.follows = "libsecrets";
        libstore.follows = "libstore";
        libweb.follows = "libweb";
        nixpkgs.follows = "nixpkgs";
        wofi-unpatched.follows = "wofi-unpatched";
      };
    };
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
    simple-nixos-mailserver = {
      url = "git+https://gitlab.com/simple-nixos-mailserver/nixos-mailserver.git";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-24_11.follows = "nixpkgs";
      };
    };
    sivizius = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=users/sivizius";
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
      home-manager-wrapper,
      libconfig,
      libcore,
      libsecrets,
      libstore,
      libweb,
      modules,
      git-hooks,
      peers,
      profiles,
      registries,
      sivizius,
      ...
    }:
    let
      config = libconfig.lib { inherit self; };
      core = libcore.lib {
        inherit self;
        debug.logLevel = "info";
      };
      secrets = libsecrets.lib { inherit self; };

      inherit (core) set target time;
      inherit (config.hosts) Host PrepareArgument load;

      registries' = PrepareArgument registries.registries;

      hosts =
        load ./.
          {
            modules = modules.legacyModules.nixos;
          }
          {
            inherit core self;
            inherit (peers) peers;
            inherit (profiles) profiles;
            inherit (secrets) secret;

            web = libweb.lib { inherit self; };

            dateTime = time.parseDateTime self.lastModifiedDate;
            home-manager = home-manager-wrapper.lib;
            registries = registries';
            store = libstore.lib;
            users = {
              sivizius = sivizius.user;
            };
          };

      filteredHosts = set.filterValue Host.isInstanceOf hosts;

      packages = target.System.mapStdenv (
        buildSystem:
        set.mapValues (
          { nixosConfiguration, ... }: nixosConfiguration."${buildSystem}".config.system.build.toplevel
        ) filteredHosts
      );
    in
    {
      inherit hosts packages;

      apps = target.System.mapStdenv (
        buildSystem:
        set.mapValues (program: {
          type = "app";
          inherit program;
        }) packages
      );

      nixosConfigurations = set.mapValues (
        { nixosConfiguration, system, ... }: nixosConfiguration."${system}"
      ) filteredHosts;

      devShells = target.System.mapStdenv (buildSystem: {
        default = registries'.inner."${buildSystem}".nix.mkShell {
          name = "hosts";

          shellHook = core.string.concatLines [
            # Enable Pre-Commit-Hooks:
            "${(import ../pre-commit.nix {
              git-hooks = git-hooks.lib."${buildSystem}";
            }).pre-commit-check.shellHook
            }"
          ];
        };
      });
    };
}
