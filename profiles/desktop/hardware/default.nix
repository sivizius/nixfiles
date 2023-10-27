[
  ./bluetooth.nix
  ./boot.nix
  ./pulseaudio.nix
  ./scanner.nix
  ./trackpoint.nix
  {
    hardware.cpu.intel.updateMicrocode = true;
    hardware.enableRedistributableFirmware = true;

    hardware.gpgSmartcards.enable = true;
    services.pcscd.enable = true;

    hardware.opengl.enable = true;
    nix.settings.max-jobs = 8;
    powerManagement.cpuFreqGovernor = "powersave";
  }
]
