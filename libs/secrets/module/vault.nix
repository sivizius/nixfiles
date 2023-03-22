{ core, self, store, ... } @ libs:
{ config, pkgs, ... } @ env:
  let
    inherit(core) list path set string type;
    gpg                                 =   path.import ./gpg.nix libs env;

    checkSecrets
    =   set.mapToListConcatted
        (
          name:
          value:
            let
              expect
              =   entry:
                    if value.${entry} != null
                    then
                      []
                    else
                      [ "Secret `${name}` is of type `${value.type}`, but is missing `${entry}`." ];
              extra
              =   entry:
                    if value.${entry} != null
                    then
                      [ "Secret `${name}` is of type `${value.type}`, but `${entry}` was set." ]
                    else
                      [];
            in
              if      value.type or null != null
              then
                {
                  decrypt               =   (expect "encryptedFile")  ++  (extra  "variables");
                  generateEnvFile       =   (extra  "encryptedFile")  ++  (expect "variables");
                  generateToken         =   (extra  "encryptedFile")  ++  (extra  "variables");
                }.${value.type} or [ "Unknown/unimplemented type `${value.type}`." ]
              else if value == null           then  [ "${name} is null, missing generateToken?" ]
              else if list.isInstanceOf value then  [ "${name} is a list, missing generateEnvFile?" ]
              else                                  [ "${name} is invalid: ${type.getPrimitive value}" ]
        );

    decryptFiles
    =   { homedir, vaultBasePath } @ args:
          set.mapToListConcatted
          (
            name:
            { group, owner, encryptedFile, type, ... }:
              let
                fileName                =   "${vaultBasePath}/${name}";
              in
                if type == "decrypt"
                then
                (gpg.decrypt args encryptedFile fileName)
                ++  (setPermissions { inherit fileName group owner; })
                else
                  []
          );

    generateEnvFiles
    =   { vaultBasePath, ... }:
          set.mapToListConcatted
          (
            name:
            { group, owner, type, variables, ... }:
              if type == "generateEnvFile"
              then
                let
                  fileName             =   "${vaultBasePath}/${name}";
                in
                  [ ''echo -n "" > "${fileName}"'' ]
                  ++  (
                        list.map
                        (
                          variable:
                            ''echo "_${variable}_=\"$(${utils}/cat "${vaultBasePath}/${variable}")\"" >> "${fileName}"''
                        )
                        variables
                      )
                  ++  (setPermissions { inherit fileName group owner; })
              else
                []
          );

    generateTokens
    =   { vaultBasePath, ... }:
          set.mapToListConcatted
          (
            name:
            { generator, group, length, owner, type, ... }:
              if type == "generateToken"
              then
                let
                  generator'            =   if generator != null then generator else "[:graph:]";
                  length'               =   if length != null then string length else "32";
                  getRandom             =   "${utils}/cat /dev/urandom";
                  filterChars           =   "${utils}/tr --delete --complement \"${generator'}\"";
                  takeChars             =   "${utils}/head --bytes \"${length'}\"";
                  fileName              =   "${vaultBasePath}/${name}";
                  generate              =   ''${getRandom} | ${filterChars} | ${takeChars} > "${fileName}"'';
                in
                  [ generate ]
                  ++  (setPermissions { inherit fileName group owner; })
              else
                []
          );

    setPermissions
    =   { fileName, group, owner }:
          let
            ifGroup                     =   value: if group != null then value else "";
            owner'                      =   if owner != null then owner else "root";
          in
          [
            ''${utils}/chmod --changes --recursive u=r,g=${ifGroup "r"},o= "${fileName}"''
            ''${utils}/chown --changes --recursive "${owner'}:${ifGroup group}" "${fileName}"''
          ];

    utils                               =   "${pkgs.coreutils}/bin";
  in
    {
      homedir ? "/tmp/keyring",
      key,
      secrets,
      vault
    }:
      let
        args
        =   {
              inherit homedir;
              vaultBasePath             =   vault;
            };
        daemon
        =   pkgs.writeShellScript "initVault.sh"
            (
              string.concatLines
              (
                [
                  ''set -e''
                  ''echo "initialise ${vault}..."''
                  ''${utils}/install --mode u=rwx,g=x,o=x --directory "${vault}/"''
                ]
#                ++  [ ''echo "enable smart card..."''           ]
#                ++  ( gpg.enableSmartCard args                  )
                ++  [ ''echo "import vault key ${key}..."''     ]
                ++  ( gpg.importKey       args  key             )
                ++  [ ''echo "decrypt files..."''               ]
                ++  ( decryptFiles        args  secrets         )
                ++  [ ''echo "generate tokens..."''             ]
                ++  ( generateTokens      args  secrets         )
                ++  [ ''echo "generate environment files..."''  ]
                ++  ( generateEnvFiles    args  secrets         )
                ++  [
                      ''echo "...done"''
                      ''exit 0''
                    ]
              )
            );
      in
      {
        errors                          =   checkSecrets secrets;
        vault
        =   ''
              ${utils}/rm --recursive --force ${homedir}
              ${utils}/install --mode u=rwx,g=,o= --directory ${homedir}
              ${gpg.startAgent { inherit daemon homedir; }}
              ${utils}/rm --recursive ${homedir}
            '';
      }
