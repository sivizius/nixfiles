{ registries, ... }:
{
  nix
  =   {
        extraOptions
        =   ''
              experimental-features = nix-command flakes
            '';
        gc
        =   {
              automatic                 =   true;
              options                   =   "--delete-older-than 14d";
            };
        optimise
        =   {
              automatic                 =   true;
              dates                     =   [ "23:42" ];
            };
        settings
        =   {
              auto-optimise-store       =   true;
              trusted-users
              =   [
                    "root"
                    "@wheel"
                  ];
            };
      };

  security.sudo.extraConfig
  =   ''
        Defaults  lecture               =   always
        Defaults  lecture_file          =   ${./assets/arstotzka.txt}
      '';

  system
  =   {
        autoUpgrade
        =   {
              allowReboot               =   false;
              dates                     =   "04:20";
              enable                    =   false;
              flake                     =   "github:sivizius/nixfiles/stable";
            };
      };

  programs.zsh.enable                   =   true;
  users
  =   {
        defaultUserShell                =   registries.nix.zsh;
      };
}
