{ core, profile, registries, version, ... } @ env:
  let
    inherit(core) list path;
    email                               =   path.import ./email.nix       env;
    packages                            =   path.import ./packages        env;
  in
  {
    accounts
    =   {
          inherit email;
        };
    dconf.settings
    =   {
        };
    editorconfig
    =   {
          enable                        =   false;
          settings
          =   {
              };
        };
    fonts.fontconfig.enable             =   true;
    home
    =   {
          activation                    =   {};
          enableDebugInfo               =   true;
          enableNixpkgsReleaseCheck     =   true;
          extraOutputsToInstall         =   [ "doc" "info" "devdoc" ];
          file                          =   {};
        # homeDirectory                 =   "/home/sivizius";
          keyboard
          =   {
                layout                  =   null;
                model                   =   null;
                options                 =   [];
                variant                 =   null;
              };
          language
          =   {
                address                 =   null;
                base                    =   null;
                collate                 =   null;
                ctype                   =   null;
                measurement             =   null;
                messages                =   null;
                monetary                =   null;
                name                    =   null;
                numeric                 =   null;
                paper                   =   null;
                telephone               =   null;
                time                    =   null;
              };
          packages
          =   packages.common
          ++  (list.ifOrEmpty' profile.isDesktop packages.desktop);
          sessionVariables
          =   {
                NIX_BUILD_SHELL         =   "${registries.nix.zsh}/bin/zsh";
                NIX_SSHOPTS             =   "-t";
                TERM                    =   "xterm";
              };
          shellAliases                  =   path.import ./shellAliases.nix env;
          stateVersion                  =   version.version;
        };
    host
    =   {
          extraGroups
          =   [ "wheel" ]
          ++  (
                list.ifOrEmpty' profile.isDesktop
                [
                  "docker"
                  "lpadmin"
                  "network"
                  "scanner"
                  "video"
                ]
              );
          # Generate with: mkpasswd -m sha-512 $PASSPHRASE
          initialHashedPassword         =   "$6$mgzs1dRcXi.6t2C4$Uf1be0ppPZwF0iGlxu7im/ff6GzRFeGSrsZfhCSEaQigeuTX6o/1yTYn0Lp2FhY2.LVQRGuy5cGvtIAe3UNbp1";
          shell                         =   registries.nix.zsh;
        };
    manual
    =   {
          html.enable                   =   true;
          json.enable                   =   true;
          manpages.enable               =   true;
        };
    programs                            =   path.import ./programs  env { inherit email; };
    services                            =   path.import ./services  env;
    wayland.windowManager.sway          =   path.import ./sway      env;
  }
