
{ registries, ... }:
{
  environment.systemPackages
  =   with registries.nix;
      [
        sane-backends
        xsane
      ];
  hardware.sane
  =   {
        enable                          =   true;
        extraBackends                   =   with registries.nix; [ epkowa hplipWithPlugin sane-airscan ];
      };
  services.ipp-usb.enable               =   true;
}
