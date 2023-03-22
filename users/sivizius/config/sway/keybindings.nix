{ core, registries, store, ... }:
{
  lock, terminal,
  volumeDelta, brightnessDelta,
  modifier, up, down, left, right
}:
  let
    inherit(core) debug string;
    bluetoothctl                        =   "${registries.nix.bluez}/bin/bluetoothctl";
    brightnessctl                       =   "${registries.nix.brightnessctl}/bin/brightnessctl";
    htop                                =   "${terminal} -e ${registries.nix.htop}/bin/htop";
    makoctl                             =   "${registries.nix.mako}/bin/makoctl";
    pactl                               =   "${registries.nix.pulseaudio}/bin/pactl";
    playerctl                           =   "${registries.nix.playerctl}/bin/playerctl";
    qutebrowser                         =   "${registries.nix.qutebrowser}/bin/qutebrowser";
    ripgrep                             =   "${registries.nix.ripgrep}/bin/rg";
    sed                                 =   "${registries.nix.gnused}/bin/sed";
    swaymsg                             =   "${registries.nix.sway}/bin/swaymsg";
    wpa_cli                             =   "${registries.nix.wpa_supplicant}/bin/wpa_cli";
    woficmd                             =   "${registries.custom.wofi-unpatched}/bin/wofi --style ${./assets/wofi.css} ";

    takeScreenshot
    =   let
          script
          =   store.write.shellScript "screenshooter"
              ''
                directory="$HOME/Pictures/Screenshots"
                ${registries.nix.coreutils}/bin/mkdir -p "$directory"
                OUTPUT="$directory/$(date -Iseconds).png"
                ${registries.nix.grim}/bin/grim -g "$(${registries.nix.slurp}/bin/slurp -d)" "$OUTPUT"
                ${registries.nix.libnotify}/bin/notify-send -t 10000 "Screenshot saved to" "$OUTPUT"
              '';
        in
          "sh ${script}";

    listPasswords
    =   let
          script
          =   store.write.shellScript "passwords"
              ''
                cd $HOME/Passwords
                for file in $(${registries.nix.findutils}/bin/find . -name "*.gpg")
                do
                  echo "''${file%.gpg}" | ${sed} "s/^.\///g"
                done
              '';
        in
          "sh ${script}";

    selectNetwork
    =   string.concatWords
        [
          "${wpa_cli} select_network"
          "$("
            "${wpa_cli} list_networks"
            "| ${registries.nix.coreutils}/bin/tail -n +3"
            "| ${ripgrep} -o \"^[^\t]+\t[^\t]+\""
            "| ${woficmd} --show dmenu"
            "| ${ripgrep} -o \"^[0-9]+\" | tee -a $HOME/network.log"
          ")"
        ];

    killer
    =   string.concatWords
        [
          "kill"
          "-SIGKILL"
          "$("
            "${registries.nix.procps}/bin/ps -H -u $USER -o pid=,cmd="
            "| ${sed} \"s/^ *\\([1-9][0-9]*\\) \\(.*\\)/\\1\\t\\2/\" "
            "| ${woficmd} --show dmenu --insensitive | rg -o \"^\d+\""
          ")"
        ];

    bluetoothConnect
    =   string.concatWords
        [
          "${bluetoothctl} connect"
          "$("
            "${bluetoothctl} devices"
            "| ${sed} \"s/^Device \\(.*\\) \\(.*\\)/\\1\\t\\2/\""
            "| ${woficmd} --show dmenu --insensitive"
            "| ${ripgrep} -o \"^[0-9A-F:]*\""
          ")"
        ];
    pass                                =   "${registries.nix.pass}/bin/pass -c $(${listPasswords} | ${woficmd} --show dmenu --insensitive)";
    menu                                =   "${woficmd} --show drun -I --insensitive";
    browser                             =   qutebrowser;
    mod                                 =   modifier;
  in
  debug.info "selectNetwork" "»${selectNetwork}«"
  {
    # Execute Stuff
    "${mod}+z"                          =   "exec ${bluetoothConnect}";
    "${mod}+h"                          =   "exec ${htop}";
    "${mod}+k"                          =   "exec ${takeScreenshot}";
    "${mod}+l"                          =   "exec ${lock}";
    "${mod}+n"                          =   "exec ${selectNetwork}";
    "${mod}+p"                          =   "exec ${pass}";
    "${mod}+t"                          =   "exec ${terminal}";
    "${mod}+u"                          =   "exec ${browser}";
    "${mod}+Escape"                     =   "exec ${menu}";

    "${mod}+Shift+x"                    =   "kill";
    "${mod}+Shift+c"                    =   "reload";
    "${mod}+Shift+q"                    =   "exec ${swaymsg} exit";
    "${mod}+Shift+e"                    =   "exec ${makoctl} dismiss -a";
    "${mod}+Shift+k"                    =   "exec ${killer}";

    # Tilling
    "${mod}+b"                          =   "splith";
    "${mod}+v"                          =   "splitv";

    "${mod}+q"                          =   "layout stacking";
    "${mod}+e"                          =   "layout tabbed";
    "${mod}+y"                          =   "layout toggle split";
    "${mod}+x"                          =   "fullscreen";

    "${mod}+c"                          =   "floating toggle";
    "${mod}+j"                          =   "focus mode_toggle";
    "${mod}+m"                          =   "focus parent";
    "${mod}+f"                          =   "move scratchpad";
    "${mod}+g"                          =   "scratchpad show";

    # Focus
    "${mod}+${up}"                      =   "focus up";
    "${mod}+Up"                         =   "focus up";
    "${mod}+${left}"                    =   "focus left";
    "${mod}+Left"                       =   "focus left";
    "${mod}+${down}"                    =   "focus down";
    "${mod}+Down"                       =   "focus down";
    "${mod}+${right}"                   =   "focus right";
    "${mod}+Right"                      =   "focus right";

    # Moving
    "${mod}+Shift+${up}"                =   "move  up";
    "${mod}+Shift+Up"                   =   "move  up";
    "${mod}+Shift+${left}"              =   "move  left";
    "${mod}+Shift+Left"                 =   "move  left";
    "${mod}+Shift+${down}"              =   "move  down";
    "${mod}+Shift+Down"                 =   "move  down";
    "${mod}+Shift+${right}"             =   "move  right";
    "${mod}+Shift+Right"                =   "move  right";

    # Resizing
    "${mod}+r"                          =   "mode \"resize\"";

    # Workspaces
    "${mod}+F1"                         =   "workspace 0";
    "${mod}+Shift+F1"                   =   "move container to workspace 0";
    "${mod}+F2"                         =   "workspace 1";
    "${mod}+Shift+F2"                   =   "move container to workspace 1";
    "${mod}+F3"                         =   "workspace 2";
    "${mod}+Shift+F3"                   =   "move container to workspace 2";
    "${mod}+F4"                         =   "workspace 3";
    "${mod}+Shift+F4"                   =   "move container to workspace 3";
    "${mod}+F5"                         =   "workspace 4";
    "${mod}+Shift+F5"                   =   "move container to workspace 4";
    "${mod}+F6"                         =   "workspace 5";
    "${mod}+Shift+F6"                   =   "move container to workspace 5";
    "${mod}+F7"                         =   "workspace 6";
    "${mod}+Shift+F7"                   =   "move container to workspace 6";
    "${mod}+F8"                         =   "workspace 7";
    "${mod}+Shift+F8"                   =   "move container to workspace 7";
    "${mod}+F9"                         =   "workspace 8";
    "${mod}+Shift+F9"                   =   "move container to workspace 8";
    "${mod}+F10"                        =   "workspace 9";
    "${mod}+Shift+F10"                  =   "move container to workspace 9";
    "${mod}+F11"                        =   "workspace a";
    "${mod}+Shift+F11"                  =   "move container to workspace a";
    "${mod}+F12"                        =   "workspace b";
    "${mod}+Shift+F12"                  =   "move container to workspace b";
    "${mod}+1"                          =   "workspace c";
    "${mod}+Shift+1"                    =   "move container to workspace c";
    "${mod}+2"                          =   "workspace d";
    "${mod}+Shift+2"                    =   "move container to workspace d";
    "${mod}+3"                          =   "workspace e";
    "${mod}+Shift+3"                    =   "move container to workspace e";
    "${mod}+4"                          =   "workspace f";
    "${mod}+Shift+4"                    =   "move container to workspace f";
    "${mod}+5"                          =   "workspace g";
    "${mod}+Shift+5"                    =   "move container to workspace g";
    "${mod}+6"                          =   "workspace h";
    "${mod}+Shift+6"                    =   "move container to workspace h";
    "${mod}+7"                          =   "workspace i";
    "${mod}+Shift+7"                    =   "move container to workspace i";
    "${mod}+8"                          =   "workspace j";
    "${mod}+Shift+8"                    =   "move container to workspace j";
    "${mod}+9"                          =   "workspace k";
    "${mod}+Shift+9"                    =   "move container to workspace k";
    "${mod}+0"                          =   "workspace l";
    "${mod}+Shift+0"                    =   "move container to workspace l";

    # Special Keys
    "XF86AudioRaiseVolume"              =   "exec ${pactl} set-sink-volume @DEFAULT_SINK@    +${volumeDelta}";
    "XF86AudioLowerVolume"              =   "exec ${pactl} set-sink-volume @DEFAULT_SINK@    -${volumeDelta}";
    "XF86AudioMute"                     =   "exec ${pactl} set-sink-mute   @DEFAULT_SINK@    toggle";
    "XF86AudioMicMute"                  =   "exec ${pactl} set-source-mute @DEFAULT_SOURCE@  toggle";
    "XF86MonBrightnessDown"             =   "exec ${brightnessctl} set ${brightnessDelta}-";
    "XF86MonBrightnessUp"               =   "exec ${brightnessctl} set +${brightnessDelta}";
    "XF86AudioPlay"                     =   "exec ${playerctl} play-pause";
    "XF86AudioNext"                     =   "exec ${playerctl} next";
    "XF86AudioPrev"                     =   "exec ${playerctl} previous";

    # Keyboard Layout
    "Ctrl+Shift+F1"                     =   "input * xkb_layout de(basic)";
    "Ctrl+Shift+F2"                     =   "input * xkb_layout il(phonetic)";
    "Ctrl+Shift+F3"                     =   "input * xkb_layout bg(phonetic)";
    "Ctrl+Shift+F4"                     =   "input * xkb_layout gr(basic)";
    "Ctrl+Shift+F5"                     =   "input * xkb_layout us(basic)";
  }
