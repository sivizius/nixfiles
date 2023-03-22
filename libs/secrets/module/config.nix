{ core, ... } @ libs:
{ config, lib, ... } @ env:
  let
    inherit(core) list path;
    inherit(initVault { inherit(config.vault) key secrets vault; }) errors vault;
    initVault                           =   path.import ./vault.nix libs env;
  in
    lib.mkIf (config.vault.secrets != {})
    {
      assertions
      =   list.map
            (message: { assertion = false; inherit message; })
            errors;
      environment.loginShellInit
      =   ''
            echo "Check vault of user: $USER..."
          '';
      system.activationScripts.initialise-vault
      =   {
            deps                        =   [ "users" "groups" ];
            text                        =   vault;
          };
    }
