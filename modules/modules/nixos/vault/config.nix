{ self, lib, registries, ...}:
let
  inherit (lib.intrinsics) abort map mapAttrs attrNames attrValues length dirOf toString toFile;
  inherit (lib.nixlib) mkIf;
  inherit(registries.nix) coreutils gnupg runtimeShell;

  pinentry
  =   if self.pinentry != null
      then
        "pinentry-program ${self.pinentry}/bin/pinentry"
      else
        "";

  loopback
  =   if self.pinentry == null
      then
        " --pinentry-mode loopback"
      else
        "";

  quiet
  =   if self.quiet
      then
        " --quiet"
      else
        "";

  homedir                               =   "/tmp/keyring";
  utils                                 =   "${coreutils}/bin/";

  mapSecrets
  =   secrets:
        attrValues
        (
          mapAttrs
          (
            name:
            value:
              let
                setPermissions
                =   fileName:
                    owner:
                    group:
                      if owner != null
                      then
                        if group != null
                        then
                          ''
                            ${utils}/chown "${owner}:${group}" "${fileName}"
                            ${utils}/chmod u=r,g=r,o= "${fileName}"
                          ''
                        else
                          ''
                            ${utils}/chown "${owner}" "${fileName}"
                            ${utils}/chmod u=r,g=,o= "${fileName}"
                          ''
                      else
                        if group != null
                        then
                          ''
                            ${utils}/chgrp "${group}" "${fileName}"
                            ${utils}/chmod u=r,g=r,o= "${fileName}"
                          ''
                        else
                          ''
                            ${utils}/chmod u=r,g=,o= "${fileName}"
                          '';
              in
                if      value.decrypt  != null
                then
                  let
                    encrypted           =   "\"${value.decrypt}\"";
                  in
                  ''
                    ${gnupg}/bin/gpg --homedir ${homedir}${loopback}${quiet} --decrypt ${encrypted} --output "${value.path}"
                    ${setPermissions value.path value.owner value.group}
                  ''
                else if value.generate != null
                then
                  let
                    set                 =   "\"${value.generate.set}\"";
                    length              =   "\"${value.generate.length}\"";
                  in
                  ''
                    ${utils}/cat /dev/urandom | ${utils}/tr --delete --complement ${set} | ${utils}/head --bytes ${length} > "${value.path}"
                    ${setPermissions value.path value.owner value.group}
                  ''
                else
                  abort "Either option `decrypt` or `generate` must be set!"
          )
          secrets
        );

  hostDefaultKey
  =   if self.host.keys.default != null
      then
        [ "\"${self.host.keys.default}\"" ]
      else
        [ ];

  mandatoryKeys                         =   hostDefaultKey ++ self.host.keys.mandatory;
  importMandatoryKeys
  =   map
      (
        key:
          "${gnupg}/bin/gpg --homedir ${homedir}${quiet} --batch --import \"${key}\"\n"
      );

  makeUserDirectories
  =   map
      (
        userName:
          "${utils}/install --owner \"${userName}\" --mode u=rwx,g=x,o=x --directory \"${self.vault}/user/${userName}\""
      );

  importOptionalKeys
  =   keys:
        if keys != [ ]
        then
          ''
            PS3="Select optional key to import or 0: "
            select key in ${toString (map (key: "\"${key}\"") keys)}
            do
              if [ "$key" != "" ]
              then
                ${gnupg}/bin/gpg --homedir ${homedir}${quiet} --batch --import "$key"
              else
                break
              fi
            done
          ''
        else
          "";

  initVault
  =   toFile "initVault.sh"
      ''
        #!${runtimeShell}
        # set up the confidential and ephemeral vault-directory as the secrets-store
        echo "initialise ${self.vault}…"
        # root will be able to create files and list the directory
        # everyone else can only access certain files by path
        ${utils}/install --mode u=rwx,g=x,o=x --directory ${self.vault}/host
        ${toString (makeUserDirectories (attrNames self.user))}
        # import mandatory keys and ask for optional keys to import
        ${toString (importMandatoryKeys mandatoryKeys)}${importOptionalKeys self.host.keys.optional}
        # decrypt or generate secrets
        ${toString (mapSecrets self.host.secrets)}
      '';

  startAgent
  =   let
        gpgConfig
        =   toFile "startAgent.config"
            ''
              default-cache-ttl 34560000
              max-cache-ttl 34560000
              ${pinentry}
            '';
      in
        task:
          toFile "startAgent.sh"
          ''
            #!${runtimeShell}
            # initialise a temporary keyring, start the agent to initialise the vault and then clean up afterwards
            ${utils}/rm --recursive --force ${homedir}
            ${utils}/install --mode u=rwx,g=,o= --directory ${homedir}
            ${gnupg}/bin/gpg-agent --homedir ${homedir}${quiet} --options ${gpgConfig} --daemon ${task}
            ${utils}/rm --recursive ${homedir}
          '';

  generateDefaultKey
  =   name:
      owner:
      path:
        let
          gpgConfig
          =   toFile "generateDefaultKey.config"
              ''
                Key-Type: eddsa
                Key-Curve: Ed25519
                Key-Usage: sign,auth
                Subkey-Type: ecdh
                Subkey-Curve: Curve25519
                Subkey-Usage: encrypt
                Name: ${name}
                Name-Comment: default vault-key
                Preferences: SHA512 AES256 Uncompressed
                Expire-Date: 0
              '';
        in
          toFile
          ''
            #!${runtimeShell}
            # generate a default-key for host/user ${name} (${owner})
            echo "generate default-key ${name}…"
            ${utils}/install --mode u=r,g=,o= --owner "${owner}" --directory "${dirOf path}"
            ${gnupg}/bin/gpg ${quiet}--batch --generate-key ${gpgConfig}
            ${gnupg}/bin/gpg ${quiet}--export --armor "${name}" --output "${path}"
          '';

  mayGenerateHostDefaultKey
  =   if self.host.keys.default != null
      then
        ''
          if [ ! -f "${self.host.keys.default}" ]
          then
            ${startAgent (generateDefaultKey config.network.hostName "root" self.host.keys.default)}
          fi
        ''
      else
        "";
in
  mkIf self.enable
  {
    system.activationScripts.initialise-vault
    =   {
          deps                          =   [ "users" "groups" ];
          text                          =   "${mayGenerateHostDefaultKey}${startAgent initVault}";
        };
  }
