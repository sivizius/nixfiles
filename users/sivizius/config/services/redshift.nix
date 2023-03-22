{ profile, registries, ... }:
{
  enable                                =   profile.isDesktop;
  package                               =   registries.custom.redshift-wayland;
  tray                                  =   true;
  latitude                              =   "50.85";
  longitude                             =   "12.95";
}
