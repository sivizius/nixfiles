{ registries, ... }:
{
  hardware.pulseaudio
  =   {
        enable                          =   true;
        extraModules                    =   [ ];
        extraConfig
        =   ''
              load-module module-switch-on-connect
            '';
        package                         =   registries.nix.pulseaudioFull;
      };
  nixpkgs.config.pulseaudio             =   true;
  sound.enable                          =   true;
}
