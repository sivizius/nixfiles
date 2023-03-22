{ services, ... }:
  Profile "Common."
  {
    configuration
    =   [
          ./boot.nix
          ./environment.nix
          ./system.nix
        ];
    services                            =   with services; [ gnupg openssh ];
  }
