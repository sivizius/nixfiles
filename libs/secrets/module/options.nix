{ ... }:
{ lib, ... }:
  let
    inherit(lib) types;

    secretType
    =   types.submodule
        {
          options
          =   {
                encryptedFile
                =   lib.mkOption
                    {
                      type              =   types.nullOr types.path;
                      default           =   null;
                      description       =   "Path to an encrypted secret to decrypt.";
                    };
                generator
                =   lib.mkOption
                    {
                      type              =   types.nullOr types.str;
                      default           =   "[:graph:]";
                      description       =   "Generator pattern of token.";
                      example           =   "[0-9a-f]";
                    };
                group
                =   lib.mkOption
                    {
                      type              =   types.nullOr types.str;
                      default           =   null;
                      description
                      =   ''
                            The group of this secret.
                            If not set (default), only the owner can read this secret.
                            However, the group is set to the owner’s login-group.
                          '';
                      example           =   "network";
                    };
                length
                =   lib.mkOption
                    {
                      type              =   types.nullOr types.ints.positive;
                      default           =   32;
                      description       =   "Length of generated token.";
                      example           =   64;
                    };
                owner
                =   lib.mkOption
                    {
                      type              =   types.nullOr types.str;
                      default           =   "root";
                      description
                      =   ''
                            The owner of this secret.
                          '';
                      example           =   "user";
                    };
                type
                =   lib.mkOption
                    {
                      type              =   types.enum [ "decrypt" "generateEnvFile" "generateToken" ];
                      description       =   "Type of this secret.";
                    };
                variables
                =   lib.mkOption
                    {
                      type              =   types.nullOr (types.listOf types.str);
                      default           =   null;
                      description       =   "List of secrets to generate an environment file from.";
                    };
              };
        };
  in
  {
    key
    =   lib.mkOption
        {
          type                          =   types.str;
          default                       =   "/var/vault.gpg";
          description                   =   "Private pgp-key without passphrase!";
        };
    secrets
    =   lib.mkOption
        {
          type                          =   types.attrsOf secretType;
          default                       =   {};
          description                   =   "Set of secrets.";
        };
    vault
    =   lib.mkOption
        {
          type                          =   types.str;
          default                       =   "/run/vault";
          example                       =   "/run/secrets";
          description                   =   "Path to the Vault";
        };
  }
