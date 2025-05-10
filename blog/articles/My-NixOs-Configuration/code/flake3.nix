{
  pc
  =   {
        system = "x86_64-linux";
        modules
        =   [
              ./profiles/desktop
              ./hosts/pc
            ];
      };
  laptop
  =   {
        system = "x86_64-linux";
        modules
        =   [
              ./profiles/desktop
              ./hosts/laptop
            ];
      };
  cloud1
  =   {
        system = "x86_64-linux";
        modules
        =   [
              ./profiles/hetznerCloudServer
              ./hosts/cloud1
            ];
      };
  cloud2
  =   {
        system = "x86_64-linux";
        modules
        =   [
              ./profiles/hetznerCloudServer
              ./hosts/cloud2
            ];
      };
  physical
  =   {
        system = "x86_64-linux";
        modules
        =   [
              ./profiles/physicalServer
              ./hosts/physical
            ];
      };
}