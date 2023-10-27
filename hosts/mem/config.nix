{
  boot.initrd.luks = {
    fido2Support = true;
    devices."nixos".fido2 = {
      credentials = [ "f343eb4b94005661bb777d9e5b1ded2c" ];
      gracePeriod = 10;
      passwordLess = true;
    };
  };
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    swaylock.u2fAuth = true;
  };
}
