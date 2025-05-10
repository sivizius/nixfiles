{
  description = "Home-Manager";
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    libcore = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=libs/core";
      inputs.libintrinsics.follows = "libintrinsics";
    };
    libintrinsics.url = "github:sivizius/nixfiles?ref=secunet&dir=libs/intrinsics";
    nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config2";
  };
  outputs =
    {
      self,
      home-manager,
      libcore,
      ...
    }:
    let
      core = libcore.lib {
        inherit self;
        debug.logLevel = "info";
      };
      inherit (core) path;
    in
    {
      lib = home-manager.lib // (path.import ./lib { inherit core; });
      nixosModules = home-manager.nixosModules.default;
    };
}
