{ core, registries, store, profile, ... } @ arguments:
  let
    inherit(core) path string;

    swaymsg                             =   "${registries.nix.sway}/bin/swaymsg";
    lock                                =   "${registries.nix.swaylock}/bin/swaylock -efu -c 000000 -i ${./assets/otter.png} -s center";
  # timeOutDark                         =   120;
    timeOutLock                         =   120;
    lightsOff                           =   "${swaymsg} 'output * dpms off'";
    lightsOn                            =   "${swaymsg} 'output * dpms on'";

    lockScreen
    =   store.write.shellScript "lockScreen"
        ''
          ${registries.nix.swayidle}/bin/swayidle -w \
          timeout       ${string timeOutLock} "${lightsOff}; ${lock}" \
          resume        "${lightsOn}" \
          before-sleep  "${lock}" \
          lock          "${lock}"
        '';
    brightnessDelta                     =   "5%";
    volumeDelta                         =   "5%";
    resizeHeight                        =   "10px";
    resizeWidth                         =   "10px";

    modifier                            =   "Mod4";
    up                                  =   "w";
    left                                =   "a";
    down                                =   "s";
    right                               =   "d";

    terminal                            =   "${registries.nix.alacritty}/bin/alacritty";
  in
  {
    assigns                             =   path.import ./assigns.nix;
    bars                                =   [ ];

    floating
    =   {
          border                        =   2;
          criteria
          =   [
                { class = "^Pavucontrol$";  }
              ];
          titlebar                      =   true;
          inherit modifier;
        };

    fonts
    =   {
          names                         =   [ "FontAwesome" "RobotoMono" ];
          size                          =   10.0;
        };

    keybindings
    =   path.import ./keybindings.nix arguments
        {
          inherit lock terminal;
          inherit brightnessDelta volumeDelta;
          inherit modifier up down left right;
        };

    input."*"
    =   {
          pointer_accel                 =   "0.0";
          xkb_layout                    =   "de(basic)";
          xkb_options                   =   "compose:caps";
          xkb_variant                   =   "\"\"";
        };

    modes
    =   path.import ./modes.nix
        {
          inherit resizeHeight resizeWidth;
          inherit up down left right;
        };

    output."*".bg                       =   "\"${./assets/Crater_Cluster.png}\" fill";

    startup
    =   let
          bar                           =   "${registries.nix.waybar}/bin/waybar -c ${./assets/waybar/config.json} -s ${./assets/waybar/style.css}";
          neomutt
          =   store.write.shellScript "neomuttWrapper"
              ''
                ${registries.nix.neomutt}/bin/neomutt 2> ~/.cache/neomutt.log
              '';
        in
          assert profile.isDesktop;
          [
            { command = "${registries.nix.dino}/bin/dino";                                        always  = false;  }
            { command = "${registries.nix.discord}/bin/Discord";                                  always  = false;  }
            { command = "${registries.nix.firefox}/bin/firefox";                                  always  = false;  }
            { command = "${registries.nix.spotify}/bin/spotify";                                  always  = false;  }
            { command = "${registries.nix.tdesktop}/bin/telegram-desktop";                        always  = false;  }
            { command = "${registries.nix.tdesktop}/bin/signal-desktop";                          always  = false;  }
            { command = "${registries.nix.schildichat-desktop}/bin/schildichat-desktop";          always  = false;  }
            { command = "${terminal}  -t neomutt  -e ${neomutt}";                                 always  = false;  }
            { command = "${terminal}  -t ranger   -e ${registries.nix.ranger}/bin/ranger";        always  = false;  }
            { command = "${bar}";                                                                 always  = false;  }
            { command = "${lockScreen}";                                                          always  = true;   }
          ];

    window
    =   {
          border                        =   2;
          commands                      =   [ ];
          hideEdgeBorders               =   "both";
          titlebar                      =   false;
        };

    workspaceAutoBackAndForth           =   true;
  }
