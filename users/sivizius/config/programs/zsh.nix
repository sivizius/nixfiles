{ registries, ... }:
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
  enableAutosuggestions = true;
  enableCompletion = true;
  syntaxHighlighting.enable = true;
  enableVteIntegration = false;
  history = {
    expireDuplicatesFirst = true;
    extended = true;
    ignoreDups = true;
    ignorePatterns = [
      "[lnrtuvcbdefghijk]{44}" # YubiKey OTP
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
  initExtra = ''
    source ${registries.nix.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
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
