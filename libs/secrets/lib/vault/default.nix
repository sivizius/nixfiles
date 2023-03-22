{ core, secret, ... }:
  let
    inherit(core)   debug list path set string type;
    inherit(secret) Secret;

    defaultHasher
    =   value:
          if path.isInstanceOf value
          then
            path.hash "sha256" value
          else
            string.hash "sha256" (string value);

    Vault
    =   type "Vault"
        {
          from
          =   {
                hash          ? defaultHasher,
                vaultBasePath ? "/run/vault",
                ...
              }:
                Vault.instanciate
                {
                  inherit hash vaultBasePath;
                  __functor
                  =   { hash, vaultBasePath, ... } @ self:
                      source:
                      this:
                        (Secret.expect this) { inherit hash source vaultBasePath; };
                };

          update
          =   set.fold
              (
                { ... } @ secrets:
                name:
                secret':
                  let
                    secret              =   secrets.${name} or null;
                  in
                    secrets
                    //  {
                          ${name}
                          =   if secret' == null || secret == secret'
                              then
                                secret
                              else if secret == null
                              then
                                secret'
                              else
                                Secret.${secret.type}.merge secret secret';
                        }
              );
        };
  in
    Vault // { inherit Vault; }
