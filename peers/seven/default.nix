{
  binary-cache = Peer "Binary Cache by seven" {
    configuration.nix.settings = {
      substituters = [
        "http://cache.factory.secunet.com/factory-1"
      ];
      trusted-public-keys = [
        "factory-1:Ai12PqfDkRmLzju4eE5/ucuDGXw4J31d3aTrz4TZKrk="
      ];
    };
  };

  remote-builder = Peer "Remote Builder by seven" {
    configuration.nix = {
      buildMachines = [
        {
          hostName = "nixbuilder-arm-01.factory.secunet.com";
          protocol = "ssh-ng";
          systems = [ "aarch64-linux" ];
          maxJobs = 40;
          speedFactor = 2;
          supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        }
        {
          hostName = "nixbuilder-amd-01.factory.secunet.com";
          protocol = "ssh-ng";
          systems = [ "x86_64-linux" ];
          maxJobs = 40;
          speedFactor = 2;
          supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        }
      ];
      distributedBuilds = true;
    };
  };

  wireguard = Peer "Wireguard-Tunnel to seven@helsinki-systems" {
    configuration =
      { secret, ... }:
      {
        networking.wg-quick.interfaces."seven" = {
          address = [
            "198.18.1.203/15"
            "fd00:5ec::1cb/48"
          ];
          autostart = false;
          mtu = 1380;
          peers = [
            {
              allowedIPs = [
                "198.18.0.0/15"
                "fd00:5ec::/48"
              ];
              endpoint = "gateway.seven.secunet.com:51821";
              publicKey = "ZVayNyJeOn848aus5bqYU2ujNxvnYtV3ACoerLtDpg8=";
            }
          ];
          privateKeyFile = secret.decrypt' ./wgToken-2.asc;
        };
      };
  };
}
