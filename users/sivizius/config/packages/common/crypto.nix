{ nix, ... }:
  with nix;
  [
    cryptsetup
    ecdsautils
    keyutils
    openssl
    pwgen-secure
    gnupg
  ]
