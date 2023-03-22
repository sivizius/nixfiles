{
  autocd                                =   true;
  cdpath
  =   [
      ];
  completionInit
  =   ''
      '';
  defaultKeymap                         =   null;
  dirHashes
  =   {
        active                          =   "$HOME/Projects/Active";
        foreign                         =   "$HOME/Projects/Foreign";
        keys                            =   "$HOME/Keys";
      };
  dotDir                                =   ".config/zsh";
  enable                                =   true;
  enableAutosuggestions                 =   true;
  enableCompletion                      =   true;
  enableSyntaxHighlighting              =   true;
  enableVteIntegration                  =   false;
  history
  =   {
        expireDuplicatesFirst           =   true;
        extended                        =   true;
        ignoreDups                      =   true;
        ignorePatterns
        =   [
            ];
        ignoreSpace                     =   false;
        path                            =   "$HOME/.cache/zsh/history.log";
        save                            =   65536;
        share                           =   true;
        size                            =   65536;
      };
  historySubstringSearch
  =   {
        enable                          =   true;
        searchDownKey                   =   "^[[B";
        searchUpKey                     =   "^[[A";
      };
  initExtra
  =   ''
      '';
  initExtraBeforeCompInit
  =   ''
      '';
  initExtraFirst
  =   ''
      '';
  localVariables
  =   {
      };
  loginExtra
  =   ''
      '';
  logoutExtra
  =   ''
      '';
  oh-my-zsh
  =   {
        custom                          =   "";
        enable                          =   true;
        extraConfig
        =   ''
            '';
        plugins
        =   [
              "git"
              "pass"
            ];
        theme                           =   "candy";
      };
  plugins
  =   [
      ];
  prezto
  =   {
      };
  profileExtra
  =   ''
      '';
  sessionVariables
  =   {
      };
}
