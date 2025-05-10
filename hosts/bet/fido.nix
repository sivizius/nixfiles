{
  boot.initrd.luks = {
    #reusePassphrases = false;
    fido2Support = true;
    devices."nixos".fido2 = {
      credentials = [
        "f343eb4b94005661bb777d9e5b1ded2c"
        "e01c8d16064d29e2447ac67c8cfbec14d56ff8cd607f615a2d209b9ee159a718730d3bac60b045c7d16e250a1e6d4cf7"
      ];
      gracePeriod = 10;
      passwordLess = true;
      #salt = "";
      maxRetries = 2;
      requiresPIN = true;
    };
  };
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    swaylock.u2fAuth = true;
  };
}
