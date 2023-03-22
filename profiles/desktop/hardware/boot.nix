{ registries, ... }:
{
  boot
  =   {
        extraModulePackages             =   with registries.linux; [ acpi_call ];
        initrd
        =   {
              availableKernelModules
              =   [
                    "ahci"
                    "ehci_pci"
                    "firewire_ohci"
                    "rtsx_pci_sdmmc"
                    "nvme"
                    "sd_mod"
                    "sdhci_pci"
                    "sr_mod"
                    "usb_storage"
                    "xhci_pci"
                  ];
              kernelModules             =   [ "acpi_call" ];
              luks.devices."nixos"
              =   {
                    device              =   "/dev/disk/by-label/encrypted";
                  };
            };
        kernelModules                   =   [ "kvm-intel" ];
        loader.grub
        =   {
              device                    =   "nodev";
              efiSupport                =   true;
              efiInstallAsRemovable     =   true;
              enable                    =   true;
              memtest86.enable          =   true;
            };
      };
}
