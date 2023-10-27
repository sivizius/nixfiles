{ ... }:
{
  specialisation = {
    static-enp0s31f6 = {
      configuration = {
        networking.interfaces.enp0s31f6.useDHCP = {
          _type = "override";
          content = false;
          priority = 50;
        };
      };
    };
  };
}
