{
  description                           =   "Unpatched wofi";
  inputs
  =   {
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
        nixpkgs.url                     =   "github:sivizius/nixpkgs/master";
      };
  outputs
  =   { self, libcore, nixpkgs, ... }:
      {
        packages
        =   (libcore.lib { inherit self; debug.logLevel = "info"; }).target.System.mapStdenv
            (
              system:
                nixpkgs.legacyPackages."${system}".wofi.overrideAttrs
                (
                  oldAttrs:
                  {
                    # Remove the do_not_follow_symlinks-patch
                    patches             =   [];
                  }
                )
            );
      };
}
