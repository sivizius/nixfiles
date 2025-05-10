{
  description = "Fork Awesome Icons";
  inputs = {
    libcore = {
      url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/core";
      inputs.libintrinsics.follows = "libintrinsics";
    };
    libintrinsics.url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/intrinsics";
    nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config2";
  };
  outputs =
    {
      self,
      libcore,
      nixpkgs,
      ...
    }:
    let
      core = libcore.lib {
        inherit self;
        debug.logLevel = "info";
      };
      inherit (core) path target;
    in
    {
      packages = target.System.mapStdenv (
        system:
        let
          fork-awesome = path.import ./. {
            inherit (nixpkgs) lib;
            inherit (nixpkgs.legacyPackages."${system}") fetchFromGitHub stdenv;
          };
        in
        {
          inherit fork-awesome;
          default = fork-awesome;
        }
      );
    };
}
