{ core, profile, ... } @ env:
{ ... } @ extra:
  let
    inherit(core) path;
  in
  {
    #abook                               =   path.import ./abook         env;

    alacritty                           =   path.import ./alacritty.nix env;
    bash
    =   {
          historyControl                =   [ "erasedups" "ignoredups" ];
          historyFile                   =   "$HOME/.cache/bash/history.log";
          historyFileSize               =   65536;
          historyIgnore
          =   [
                "cd"
                "l" "l1" "l2" "l3" "l4" "l5" "l6" "l7" "l8" "l9" "ls" "lt"
                "exec" "exit"
              ];
          historySize                   =   65536;
        };
    git                                 =   path.import ./git.nix       env;
    htop                                =   path.import ./htop.nix      env;
    mbsync.enable                       =   profile.isDesktop;
    #nano                                =   path.import ./nano          env;
    neomutt                             =   path.import ./neomutt.nix   env extra;
    ssh                                 =   path.import ./ssh.nix       env;
    zsh                                 =   path.import ./zsh.nix;
  }
