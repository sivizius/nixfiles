{ core, ... }:
  let
    inherit(core) debug type;

    cannotMerge
    =   { type, ... } @ secret:
        { ... } @ secret':
          debug.panic [ "cannotMerge" type ]
          {
            text                        =   "Cannot merge secrets:";
            data                        =   { inherit secret secret'; };
            nice                        =   true;
          }
          null;

    decrypt
    =   {
          toSecret
          =   { encryptedFile, group, owner, ... }:
              {
                inherit encryptedFile group owner;
                inherit(decrypt) type;
              };

          merge                         =   cannotMerge;

          type                          =   "decrypt";
          __functor
          =   { toSecret, type, ... }:
              { encryptedFile, group ? null, owner ? null }:
                Secret.instanciateAs type
                {
                  inherit encryptedFile group owner;

                  __functor
                  =   { encryptedFile, ... } @ args:
                      { hash, vaultBasePath, ... }:
                        let
                          secret        =   hash encryptedFile;
                        in
                        {
                          secrets       =   { ${secret} = toSecret args; };
                          value         =   loadPath.toValue { inherit secret vaultBasePath; };
                        };
                };
        };

    decryptGrafanaSecret
    =   { encryptedFile, group ? null, owner ? "grafana" }:
          Secret.instanciateAs "decryptGrafanaSecret"
          {
            inherit encryptedFile group owner;

            merge                       =   cannotMerge;

            __functor
            =   { encryptedFile, group, owner, ... } @ args:
                { hash, vaultBasePath, ... }:
                  let
                    secret              =   hash encryptedFile;
                  in
                  {
                    secrets             =   { ${secret} = decrypt.toSecret args; };
                    value               =   loadGrafanaSecret.toValue { inherit secret vaultBasePath; };
                  };
          };

    decryptVariable
    =   environment:
        { encryptedFile, group ? null, owner ? null }:
          Secret.instanciateAs "decryptVariable"
          {
            inherit encryptedFile environment group owner;

            merge                       =   cannotMerge;

            __functor
            =   { encryptedFile, environment, ... } @ args:
                { hash, vaultBasePath, ... }:
                  let
                    secret              =   hash encryptedFile;
                    secret'             =   hash environment;
                  in
                  {
                    secrets
                    =   {
                          ${secret}     =   decrypt.toSecret          args;
                          ${secret'}    =   generateEnvFile.toSecret  { variables = [ secret ]; };
                        };
                    value               =   loadVariable.toValue { inherit secret vaultBasePath; };
                  };
          };

    generateEnvFile
    =   {
          toSecret
          =   { group ? null, owner ? null, variables, ... }:
              {
                inherit group owner variables;
                inherit(generateEnvFile) type;
              };

          type                          =   "generateEnvFile";

          merge
          =   { variables, ... } @ secret:
              { ... } @ secret':
                if  secret.type   ==  generateEnvFile.type
                &&  secret'.type  ==  generateEnvFile.type
                then
                  secret
                  //  {
                        variables
                        =   variables
                        ++  secret'.variables;
                      }
                else
                  cannotMerge secret secret';

          __functor
          =   { toSecret, type, merge, ... }:
              environment:
              { group ? null, owner ? null, variables ? [] }:
                Secret.instanciateAs type
                {
                  inherit environment group owner merge variables;

                  __functor
                  =   { environment, ... } @ args:
                      { hash, vaultBasePath, ... }:
                        let
                          secret        =   hash environment;
                        in
                        {
                          secrets       =   { ${secret} = toSecret args; };
                          value         =   loadPath.toValue { inherit secret vaultBasePath; };
                        };
                };
        };

    generateToken
    =   {
          toSecret
          =   { generator ? null, group ? null, length ? null, owner ? null, ... } @ args:
              debug.warn [ "generateToken" "toSecret" ]
              {
                text                    =   "No owner set!";
                when                    =   owner == null;
                data                    =   args;
              }
              {
                inherit generator group length owner;
                inherit(generateToken) type;
              };

          type                          =   "generateToken";

          merge                         =   cannotMerge;

          __functor
          =   { toSecret, type, ... }:
              identifier:
              { generator ? null, group ? null, length ? null, owner ? null }:
                Secret.instanciateAs type
                {
                  inherit generator group identifier length owner;

                  __functor
                  =   { identifier, ... } @ args:
                      { hash, vaultBasePath, ... }:
                        let
                          secret        =   hash identifier;
                        in
                        {
                          secrets       =   { ${secret} = toSecret (args // { inherit secret; }); };
                          value         =   loadPath.toValue { inherit secret vaultBasePath; };
                        };
                };
        };

    loadGrafanaSecret
    =   {
          toValue
          =   { secret, vaultBasePath, ... }:
                "$__file{${vaultBasePath}/${secret}}";

          type                          =   "loadGrafanaSecret";

          merge                         =   cannotMerge;

          __functor
          =   { toValue, type, ... }:
              secret:
                Secret.instanciateAs type
                {
                  inherit secret;

                  __functor
                  =   { secret, ... }:
                      { vaultBasePath, ... }:
                      {
                        secrets         =   { ${secret} = null; };
                        value           =   toValue { inherit secret vaultBasePath; };
                      };
                };
        };

    loadPath
    =   {
          toValue
          =   { secret, vaultBasePath, ... }:
                "${vaultBasePath}/${secret}";

          type                          =   "loadPath";

          merge                         =   cannotMerge;

          __functor
          =   { toValue, type, ... }:
              secret:
                Secret.instanciateAs type
                {
                  inherit secret;

                  __functor
                  =   { secret, ... }:
                      { vaultBasePath, ... }:
                      {
                        secrets         =   { ${secret} = null; };
                        value           =   toValue { inherit secret vaultBasePath; };
                      };
                };
        };

    loadTokenPath
    =   identifier:
          Secret.instanciateAs "loadTokenPath"
          {
            inherit identifier;

            merge                       =   cannotMerge;

            __functor
            =   { identifier, ... }:
                { hash, vaultBasePath, ... }:
                  let
                    secret              =   hash identifier;
                  in
                  {
                    secrets             =   { ${secret} = null; };
                    value               =   loadPath.toValue { inherit secret vaultBasePath; };
                  };
          };

    loadVariable
    =   {
          toValue
          =   { secret, vaultBasePath, ... }:
                "@_${secret}_@";

          type                          =   "loadVariable";

          merge                         =   cannotMerge;

          __functor
          =   { toValue, type, ... }:
              secret:
                Secret.instanciateAs type
                {
                  inherit secret;

                  __functor
                  =   { secret, ... }:
                      { vaultBasePath, ... }:
                      {
                        secrets         =   { ${secret} = null; };
                        value           =   toValue { inherit secret vaultBasePath; };
                      };
                };
          };

    Secret
    =   type "Secret"
        {
          inherit decrypt decryptGrafanaSecret decryptVariable
                  generateEnvFile generateToken
                  loadGrafanaSecret loadPath loadTokenPath loadVariable;

          decrypt'
          =   encryptedFile:
                Secret.decrypt { inherit encryptedFile; };

          decryptGrafanaSecret'
          =   encryptedFile:
                Secret.decryptGrafanaSecret { inherit encryptedFile; };

          decryptVariable'
          =   environment:
              encryptedFile:
                Secret.decryptVariable environment { inherit encryptedFile; };

          generateEnvFile'
          =   environment:
                Secret.generateEnvFile environment {};

          generateToken'
          =   identifier:
                Secret.generateToken identifier {};
        };
  in
    Secret // { inherit Secret; }
