{
  boot
  =   {
        extraModulePackages             =   [ ];
        initrd
        =   {
              availableKernelModules
              =   [
                    "ata_piix"
                    "sd_mod"
                    "sr_mod"
                    "virtio_pci"
                    "xhci_pci"
                  ];
              kernelModules             =   [ ];
              luks.devices."encrypted"
              =   {
                    #device              =   "/dev/disk/by-label/encrypted";
                    #device              =   "/dev/disk/by-uuid/09675dae-475b-47ff-8969-c5dee915b943";
                    device              =   "/dev/sda2";
                  };
              network.ssh.enable        =   true;
            };
        kernelModules                   =   [ ];
        loader.grub
        =   {
              devices                   =   [ "/dev/sda"  ];
              enable                    =   true;
            };
      };
}
