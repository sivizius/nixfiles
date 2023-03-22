{ host, secret, ... }:
{
  mailserver.loginAccounts
  =   let
        inherit(host.network) domain;
      in
      {
        "root@${domain}"
        =   {
              aliases                   =   [ "@${domain}" ];
              catchAll                  =   [ "${domain}" ];
              hashedPasswordFile        =   secret.decrypt { encryptedFile = ./root-at-sivizius.eu.asc; owner = "dovecot2"; };
              sieveScript               =   '''';
            };

        "sivizius@${domain}"
        =   {
              hashedPasswordFile        =   secret.decrypt { encryptedFile = ./sivizius-at-sivizius.eu.asc; owner = "dovecot2"; };
              quota                     =   "10G";
              sieveScript               =   '''';
            };
      };
}