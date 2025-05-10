{
  description = "…";
  inputs = {
    libcore = {
      url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/core";
      inputs.libintrinsics.follows = "libintrinsics";
    };
    libintrinsics.url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/intrinsics";
  };
  outputs =
    { self, libcore, ... }:
    let
      core = libcore.lib {
        inherit self;
        debug.logLevel = "warn";
      };
    in
    core.path.import ./. { inherit core; };
}
