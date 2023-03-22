{ config, modulesPath, registries, ... }:
{
  imports                               =
  [
    ( modulesPath + "/profiles/qemu-guest.nix" )
    ./network
  ];

  boot                                  =
  {
    extraModulePackages                 =   [ ];
    initrd                              =
    {
      availableKernelModules            =
      [
        "ahci"
        "sr_mod"
        "virtio_blk"
        "virtio_pci"
        "xhci_pci"
      ];
      kernelModules                     =   [ ];
      luks.devices                      =
      {
        "encrypted".device              =   "/dev/disk/by-label/gimel";
        #"encrypted".device              =   "/dev/disk/by-uuid/50ef0747-99fb-49c1-ae72-ccb8522aa494";
        "encryptedData".device          =   "/dev/disk/by-label/data";
        #"encryptedData".device          =   "/dev/disk/by-uuid/e027df47-8c13-4900-a73d-a7f8847e9bd8";
      };
    };
    kernelModules                       =   [ ];
    loader                              =
    {
      grub                              =
      {
        devices                         =   [ "/dev/vda2" ];
        enable                          =   true;
      };
    };
  };

  nix.maxJobs                           =   1;
  swapDevices                           =   [ ];

  fileSystems                           =
  {
    "/"                                 =
    {
      device                            =   "/dev/disk/by-uuid/fc7db70b-bf85-4a57-9f60-49cfbbfd569c";
      fsType                            =   "xfs";
    };
    "/boot"                             =
    {
      device                            =   "/dev/disk/by-uuid/D93A-CC07";
      fsType                            =   "vfat";
    };
    "/data"                             =
    {
      device                            =   "/dev/disk/by-uuid/3c2e33c0-3dc0-46e7-bb90-c2b1f974144b";
      fsType                            =   "xfs";
    };
  };
}
