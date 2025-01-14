{ core, registries, ... }:
{
  autocd = true;
  cdpath = [
  ];
  completionInit = ''
      '';
  defaultKeymap = null;
  dirHashes = {
    active = "$HOME/Projects/Active";
    foreign = "$HOME/Projects/Foreign";
    keys = "$HOME/Keys";
  };
  dotDir = ".config/zsh";
  enable = true;
  autosuggestion.enable = true;
  enableCompletion = true;
  syntaxHighlighting.enable = true;
  enableVteIntegration = false;
  history = {
    expireDuplicatesFirst = true;
    extended = true;
    ignoreDups = true;
    ignorePatterns = [
      "[b-lnrtuv]{44}" # YubiKey OTP
    ];
    ignoreSpace = false;
    path = "$HOME/.cache/zsh/history.log";
    save = 65536;
    share = true;
    size = 65536;
  };
  historySubstringSearch = {
    enable = true;
    searchDownKey = "^[[B";
    searchUpKey = "^[[A";
  };
  initExtra =
    let
      states = {
        # For `git_prompt_info`:
        prefix = "%{$fg[green]%}[";
        dirty = " 💩";    # Repo != HEAD
        clean = " 🧼";    # Repo == HEAD
        suffix = "";

        # For `git_prompt_status`:
        diverged = "🔀";  # ???
        behind = "⬇️";     # Branch has additional remote commits
        ahead = "⬆️";      # Branch has additional local commits
        unmerged = "♒";  # Updated but unmerged
        stashed = "📚";   # Stashed files
        deleted = "❌";   # Commit will delete files
        renamed = "🚂";   # Commit will rename files
        modified = "🏗️";  # Changes not staged for commit
        added = "🚀";     # Changes staged for commit
        untracked = "🥷"; # Untracked files
      };

      states2env =
        let
          formatState =
            name:
            prefix:
            let
              name' = core.string.toUpperCase name;
            in
              ''ZSH_THEME_GIT_PROMPT_${name'}="${prefix}"'';
        in
        states: core.string.concatLines (core.set.mapToList formatState states);
    in
    ''
      source ${registries.nix.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      function git_prompt_info_and_status() {
        local git_info="$(git_prompt_info)"
        if [ -n "$git_info" ]; then
          local git_status="$(git_prompt_status)"
          echo "$git_info$git_status]%{$reset_color%}"
        fi
      }

      {
        local lf=$'\n'
        local res="%(?..%{$fg[red]%}[Failed with %?]$lf)"
        local host="%{$fg_bold[green]%}%n@%M"
        local time="%{$fg[blue]%}[%D{%Y-%m-%dT%H:%M:%S%z}]"
        local rel_path="%{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%}"
        local info="%(1j.%{$fg[blue]%}[🌑 %j].)"
        local prompt="%{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%}"
        PROMPT="$res$host $time $rel_path $info\$(git_prompt_info_and_status)$lf$prompt "
        _omz_register_handler _omz_git_prompt_info
        _omz_register_handler _omz_git_prompt_status
      }

      ${states2env states}
    '';
  initExtraBeforeCompInit = ''
      '';
  initExtraFirst = ''
      '';
  localVariables = { };
  loginExtra = ''
      '';
  logoutExtra = ''
      '';
  oh-my-zsh = {
    custom = "";
    enable = true;
    extraConfig = ''
            '';
    plugins = [
      "git"
      "pass"
    ];
    theme = "candy";
  };
  plugins = [
  ];
  prezto = { };
  profileExtra = ''
      '';
  sessionVariables = { };
}
