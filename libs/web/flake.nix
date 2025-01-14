{
  description = "Build Websites.";
  inputs = {
    libcore = {
      url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/core";
      inputs.libintrinsics.follows = "libintrinsics";
    };
    libintrinsics.url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/intrinsics";
    nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config2";
  };
  outputs = { self, libcore, nixpkgs, ... }:
    let
      core = libcore.lib { inherit self; debug.logLevel = "info"; };
    in
    core.path.import ./.
      {
        inherit core;
        inherit (nixpkgs) lib;
      };
}
