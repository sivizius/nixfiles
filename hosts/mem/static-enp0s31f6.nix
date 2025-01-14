{ ... }:
{
  specialisation = {
    static-enp0s31f6 = {
      configuration = {
        boot.loader.grub.configurationName = {
          _type = "override";
          content = "Static enp0s31f6";
          priority = 50;
        };
        networking.interfaces.enp0s31f6.useDHCP = {
          _type = "override";
          content = false;
          priority = 50;
        };
      };
    };
  };
}
