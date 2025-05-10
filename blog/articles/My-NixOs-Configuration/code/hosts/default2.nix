{ profiles, services, users, ... }:
{
  pc
  =   Host "My Personal Computer."
      {
        config    = ./pc;
        profile   = profiles.desktop;
        system    = "x86_64-linux";
        users     = { inherit sivizius; };
      };
  laptop
  =   Host "My Laptop Computer."
      {
        config    = ./laptop;
        profile   = profiles.desktop;
        system    = "x86_64-linux";
        users     = { inherit sivizius; };
      };
  cloud1
  =   Host "My First Cloud-Server at Hetzner."
      {
        config    = ./cloud1;
        profile   = profiles.hetznerCloudServer;
        services  = with services; [ gitea ];
        system    = "x86_64-linux";
        users     = { inherit sivizius; };
      };
  cloud2
  =   Host "My Second Cloud-Server at Hetzner."
      {
        config    = ./cloud2;
        profile   = profiles.hetznerCloudServer;
        system    = "x86_64-linux";
        users     = { inherit foobar sivizius; };
      };
  physical
  =   Host "My Physical Server in a Co-Location."
      {
        config    = ./physical;
        profile   = profiles.physicalServer;
        services  = with services; [ gitea ];
        system    = "x86_64-linux";
        users     = { inherit sivizius; };
      };
}