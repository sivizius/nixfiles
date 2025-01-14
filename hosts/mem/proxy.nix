{ ... }:
{
  specialisation = {
    office = {
      configuration = {
        boot.loader.grub.configurationName = {
          _type = "override";
          content = "Office";
          priority = 50;
        };
        networking.proxy.default = {
          _type = "override";
          content = "http://10.209.201.8:3128";
          priority = 50;
        };
      };
    };
  };
}
