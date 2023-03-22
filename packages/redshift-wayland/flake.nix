{
  description                           =   "Redshift for wayland";
  inputs
  =   {
        libcore.url                     =   "github:sivizius/nixfiles/development?dir=libs/core";
        nixpkgs.url                     =   "github:sivizius/nixpkgs/master";
        redshift-wayland
        =   {
              type                      =   "github";
              owner                     =   "minus7";
              repo                      =   "redshift";
              rev                       =   "7da875d34854a6a34612d5ce4bd8718c32bec804";
            # sha256                    =   "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
              flake                     =   false;
            };
      };
  outputs
  =   { self, libcore, nixpkgs, redshift-wayland, ... }:
      {
        packages
        =   (libcore.lib { inherit self; debug.logLevel = "info"; }).target.System.mapStdenv
            (
              system:
                nixpkgs.legacyPackages."${system}".redshift.overrideAttrs
                (
                  oldAttrs:
                  {
                    src                 =   redshift-wayland;
                  }
                )
            );
      };
}
