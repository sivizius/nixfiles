{ ... }:
{
  specialisation = {
    dhcp-enp0s31f6 = {
      configuration = {
        boot.loader.grub.configurationName = {
          _type = "override";
          content = "DHCP enp0s31f6";
          priority = 50;
        };
        networking.interfaces.enp0s31f6.useDHCP = {
          _type = "override";
          content = false;
          priority = 50;
        };
        services.kea.dhcp4 = {
          enable = true;
          settings = {
            lease-database = {
              name = "/run/kea/leases";
              persist = false;
              type = "memfile";
            };
            rebind-timer = 2000;
            renew-timer = 1000;
            valid-lifetime = 4000;

            interfaces-config.interfaces = [ "enp0s31f6" ];
            subnet4 = [
              {
                next-server = "10.100.0.1";
                boot-file-name = "/tmp/netboot.ipxe";
                pools = [ { pool = "10.100.0.2 - 10.100.0.255"; } ];
                subnet = "10.100.0.0/24";
              }
            ];
          };
        };
      };
    };
  };
}
