{ profiles, services, ... }:
{
  pc
  =   Host "My Personal Computer."
      {
        config    = ./pc;
        profile   = profiles.desktop;
        system    = "x86_64-linux";
      };
  laptop
  =   Host "My Laptop Computer."
      {
        config    = ./laptop;
        profile   = profiles.desktop;
        system    = "x86_64-linux";
      };
  cloud1
  =   Host "My First Cloud-Server at Hetzner."
      {
        config    = ./cloud1;
        profile   = profiles.hetznerCloudServer;
        services  = with services; [ gitea ];
        system    = "x86_64-linux";
      };
  cloud2
  =   Host "My Second Cloud-Server at Hetzner."
      {
        config  = ./cloud2;
        profile = profiles.hetznerCloudServer;
        system  = "x86_64-linux";
      };
  physical
  =   Host "My Physical Server in a Co-Location."
      {
        config  = ./physical;
        profile = profiles.physicalServer;
        services  = with services; [ gitea ];
        system  = "x86_64-linux";
      };
}