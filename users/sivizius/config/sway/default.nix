{ core, profile, ... } @ env:
  let
    inherit(core) path set string;
  in
  {
    enable                              =   profile.isDesktop;
    config                              =   set.ifOrEmpty profile.isDesktop (path.import ./config.nix env);
    extraSessionCommands
    =   string.ifOrEmpty profile.isDesktop
        ''
          export SDL_VIDEODRIVER=wayland
          export QT_QPA_PLATFORM=wayland
          export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
          export _JAVA_AWT_WM_NONREPARENTING=1
        '';
  }
