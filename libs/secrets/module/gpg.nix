{ ... }:
{ pkgs, ... }:
{
  decrypt
  =   { homedir, ... }:
      encryptedFile:
      decryptedFile:
      [
        ''${pkgs.gnupg}/bin/gpg --homedir ${homedir} --decrypt "${encryptedFile}" > "${decryptedFile}"''
      ];

  enableSmartCard
  =   { homedir, ... }:
      [ ''${pkgs.gnupg}/bin/gpg --homedir ${homedir} --card-status > /dev/null 2> /dev/null'' ];

  importKey
  =   { homedir, ... }:
      key:
        [ ''${pkgs.gnupg}/bin/gpg --homedir ${homedir} --batch --passphrase "" --import "${key}"'' ];

  startAgent
  =   { daemon, homedir, ... }:
        "${pkgs.gnupg}/bin/gpg-agent --homedir ${homedir} --daemon ${daemon}";
}
