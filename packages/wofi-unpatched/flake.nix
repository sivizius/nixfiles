{
  description = "Unpatched wofi";
  inputs = {
    libcore = {
      url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/core";
      inputs.libintrinsics.follows = "libintrinsics";
    };
    libintrinsics.url = "git+ssh://git@git.seven.secucloud.secunet.com/sebastian.walz/nixfiles?ref=secunet&dir=libs/intrinsics";
    nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config2";
  };
  outputs = { self, libcore, nixpkgs, ... }:
    {
      packages = (libcore.lib { inherit self; debug.logLevel = "info"; }).target.System.mapStdenv
        (
          system:
          nixpkgs.legacyPackages."${system}".wofi.overrideAttrs
            (
              oldAttrs:
              {
                # Remove the do_not_follow_symlinks-patch
                patches = [ ];
              }
            )
        );
    };
}
