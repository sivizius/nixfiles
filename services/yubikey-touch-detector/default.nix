Service "YubiKey Touch Detector"
{
  configuration = { registries, ... }:
    {
      programs.yubikey-touch-detector = {
        enable = true;
      };
    };
  legacy = true;
}
