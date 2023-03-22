{ lib, registries, ... }:
let
  inherit (lib.instrinsics) mapAttrs;
  inherit (lib.nixlib)      mkEnableOption mkOption types;

  secretOptions
  =   {
        decrypt
        =   mkOption
            {
              type                      =   types.nullOr types.path;
              default                   =   null;
              description               =   "Decrypt encrypted secret. Mutually exclusive with `generate`.";
            };
        generate
        =   let
              options
              =   {
                    length
                    =   mkOption
                        {
                          type          =   types.ints.unsigned;
                          default       =   32;
                          example       =   64;
                          description   =   "Lengt of generated token.";
                        };
                    set
                    =   mkOption
                        {
                          type          =   types.str;
                          default       =   "[:graph:]";
                          example       =   "[:alnum:]";
                          description   =   "Set of allowed characters, see `tr --help`.";
                        };
                  };
            in
              mkOption
              {
                type                    =   types.nullOr ( types.submodule { inherit options; } );
                default                 =   null;
                description             =   "Generate a random token. Mutually exclusive with `decrypt`.";
              };
        group
        =   mkOption
            {
              type                      =   types.nullOr types.str;
              default                   =   null;
              example                   =   "metrics";
              description               =   "Set group of secret.";
            };
        owner
        =   mkOption
            {
              type                      =   types.nullOr types.str;
              default                   =   null;
              example                   =   "root";
              description               =   "Set user of secret.";
            };
        path
        =   mkOption
            {
              type                      =   types.nullOr types.str;
              internal                  =   true;
              default                   =   null;
            };
      };

  keyOptions
  =   {
        default
        =   mkOption
            {
              type                      =   types.nullOr types.str;
              default                   =   null;
              example                   =   "/var/keys/host.gpg";
              description               =   "Path to the default-key, which will be generated on activation, if necessary.";
            };
        mandatory
        =   mkOption
            {
              type                      =   types.listOf types.path;
              default                   =   [ ];
              description               =   "List of mandatory secret-keys to import";
            };
        optional
        =   mkOption
            {
              type                      =   types.listOf types.path;
              default                   =   [ ];
              description
              =   ''
                    List of optional secret-keys to import
                    Usefull if multile users should unlock the vault,
                      so only the keys the user knows the password of will be imported.
                    Otherwise the user might get asked for the password of multiple keys
                      which they do not know to unlock.
                  '';
            };
      };

  vaultType
  =   types.submodule
      (
        { ... } @ env:
        {
          options
          =   {
                keys
                =   mkOption
                    {
                      type              =   types.submodule { options = keyOptions; };
                      default           =   { };
                      description       =   "List of private pgp-keys available to gpg to initialise the vault.";
                    };
                secrets
                =   mkOption
                    {
                      type              =   types.attrsOf ( types.submodule { options = secretOptions; } );
                      default           =   { };
                      description       =   "List of named secrets.";
                    };
              };
        }
      );
  secretExample
  =   {
        keys
        =   {
              mandatory
              =   [
                    ./optionalKey.gpg
                  ];
              optional
              =   [
                    ./hostKey.gpg
                  ];
            };
        secrets
        =   {
              foo                       =   { generate = { set = "A-Z"; length = 8; }; };
              bar                       =   { decrypt = ./secret.gpg; };
            };
      };
in
  mkOption
  {
    type
    =   types.submodule
        {
          options
          =   {
                enable                  =   mkEnableOption "confidential managment of secrets.";
                enableSSH               =   mkEnableOption "initialising the vault via an ssh-connection.";
                host
                =   mkOption
                    {
                      type              =   vaultType;
                      default           =   { };
                      example           =   secretExample;
                      description       =   "Configure host-secrets";
                    };
                pinentry
                =   mkOption
                    {
                      type              =   types.nullOr types.package;
                      default           =   (registries.nix.pinentry).tty;
                      example           =   (registries.nix.pinentry).curses;
                      description       =   "Pinentry to use. Loopback if false.";
                    };
                quiet
                =   mkOption
                    {
                      type              =   types.bool;
                      default           =   true;
                      example           =   false;
                      description       =   "Make gpg as silent as possible.";
                    };
                user
                =   mkOption
                    {
                      type              =   types.attrsOf vaultType;
                      default           =   { };
                      example           =   secretExample;
                      description       =   "Configure user-secrets.";
                    };
                vault
                =   mkOption
                    {
                      type              =   types.str;
                      default           =   "/run/vault";
                      example           =   "/run/secrets";
                      description       =   "Path to the Vault";
                    };
              };
        };
    apply
    =   let
          mapSecrets
          =   directory:
                mapAttrs
                (
                  name:
                  secret:
                    secret // { path = "${directory}/${name}"; }
                );
        in
        (
          { vault, host, user, ... } @ cfg:
            cfg
            //  {
                  host.secrets          =   mapSecrets "${vault}/host" host.secrets;
                  user
                  =   mapAttrs
                      (
                        user:
                        secrets:
                          mapSecrets "${vault}/user/${user}/" secrets.secrets
                      )
                      user;
                }
        );
    description
    =   ''
          The vault-module.
        '';
  }
