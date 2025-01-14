{
  description = "Secrets";
  inputs = {
    libcore = {
      url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/core";
      inputs.libintrinsics.follows = "libintrinsics";
    };
    libintrinsics.url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/intrinsics";
    libstore = {
      url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/store";
      inputs = {
        libcore.follows = "libcore";
        libintrinsics.follows = "libintrinsics";
      };
    };
    #nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config2";
    #registries = {
    #  url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=registries";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };
  outputs = { self, libcore, libstore, ... }:
    let
      core = libcore.lib { inherit self; debug.logLevel = "info"; };
      store = libstore.lib;
    in
    core.path.import ./. { inherit core self store; };
}
