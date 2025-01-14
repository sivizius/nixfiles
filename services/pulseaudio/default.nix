Service "PulseAudio: a general purpose sound server"
{
  configuration =
    { registries, ... }:
    {
      pulseaudio = {
        enable = true;
        extraModules = [ ];
        extraConfig = ''
          load-module module-switch-on-connect
        '';
        package = registries.nix.pulseaudioFull;
      };
    };
}
