{ core, ... } @ env:
  let
    inherit(core) path;
  in
  {
    gpg-agent
    =   {
          enable                        =   true;
          enableBashIntegration         =   true;
          enableExtraSocket             =   false;
          enableScDaemon                =   true;
          enableSshSupport              =   true;
          enableZshIntegration          =   true;
          defaultCacheTtl               =   60 * 2; # 2 minutes
          defaultCacheTtlSsh            =   60 * 2; # 2 minutes
          grabKeyboardAndMouse          =   true;
          maxCacheTtl                   =   60 * 60; # 60 minutes
          maxCacheTtlSsh                =   60 * 60; # 60 minutes
          pinentryFlavor                =   "gtk2";
          sshKeys
          =   [
                "DEEE6586C847CF09A204714BFC23BF127D62006C"  # sivizius@sivizius.eu, sivizius@aleph.sivizius.eu
                "FDCE333287DC03BE9310F4028ADC2A58F7A24CB0"  # sivizius@github.com
                "52741DDC13174BFDE1C0E7F7C3621FF942446CFF"  # sivizius@git.sivizius.eu:2222
                "749401CEE75CEBE3A588273C6A7D24794D6C8229"  # infra.run
              ];
          verbose                       =   false;
        };
    mako                                =   path.import ./mako.nix       env;
    #redshift                            =   path.import ./redshift.nix   env;
  }
