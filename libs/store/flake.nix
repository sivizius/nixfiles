{
  description = "Store";
  inputs = {
    libcore = {
      url = "github:sivizius/nixfiles?ref=secunet&dir=libs/core";
      inputs.libintrinsics.follows = "libintrinsics";
    };
    libintrinsics.url = "github:sivizius/nixfiles?ref=secunet&dir=libs/intrinsics";
  };
  outputs =
    { self, libcore, ... }:
    let
      core = libcore.lib {
        inherit self;
        debug.logLevel = "info";
      };
    in
    core.path.import ./. { inherit core; };
}
