{ config, core, registries, store, user, ... } @ libs:
  let
    inherit(core) bool list path set string;
    accounts                            =   set.map registerAccount mailAccounts;
    mailAccounts                        =   path.import ./mailAccounts.nix libs;

    maildirBasePath                     =   "E-Mails";
    registerAccount
    =   name:
        {
          address   ? name,
          aliases   ? [],
          gpg       ? null,
          host      ? null,
          imapHost  ? host,
          index     ? null,
          kinit     ? "",
          patterns  ? [ "*" ],
          primary   ? false,
          realName  ? user.realName,
          signature ? null,
          smtpHost  ? host,
          userName  ? name,
          ...
        }:
        {
          inherit address aliases gpg primary realName userName;
          folders
          =   {
                drafts                  =   "Drafts";
                inbox                   =   "INBOX";
                sent                    =   "Sent";
                trash                   =   "Trash";
              };
          imap.host                     =   imapHost;
          mbsync
          =   {
                inherit patterns;
                create                  =   "both";
                enable                  =   true;
              };
          neomutt
          =   {
                enable                  =   true;
                extraConfig
                =   let
                      extraConfig
                      =   string.concatLines
                          (
                            [ ]
                            ++  (list.ifOrEmpty (gpg.key or null != null) ''set pgp_sign_as = "${gpg.key}"'')
                          );
                      signatureFile
                      =   bool.select
                            (signature != null)
                            (path.toFile "signature.txt" signature)
                            "\"fortune |\"";
                    in
                      ''
                        unmailboxes *
                        mailboxes   `find ${maildirBasePath}/${name} -maxdepth 1 -mindepth 1 -printf "=\"%P\" "`
                        set sidebar_sort_method = path
                        set signature = ${signatureFile}
                        ${extraConfig}
                      '';
              };
          passwordCommand
          =   let
                passwordCommand
                =   store.write.shellScript "passwordCommand"
                    ''
                      if [ $# -gt 1 ]
                      then
                        ${registries.nix.pass}/bin/pass "Communication/E-Mail/$2" | ${registries.nix.krb5}/bin/kinit "$1"
                        shift 1
                      fi

                      ${registries.nix.pass}/bin/pass "Communication/E-Mail/$1"
                    '';
              in
                "sh ${passwordCommand} ${kinit} ${name}";
          smtp.host                     =   smtpHost;
        };
  in
  {
    inherit accounts maildirBasePath;
  }
