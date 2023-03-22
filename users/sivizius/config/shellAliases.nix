{ core, profile, registries, secret, ... }:
  let
    inherit(core) bool set string;
    lt                                  =   "${registries.nix.exa}/bin/exa -lahTL";
  in
  {
    edit
    =   bool.select
          profile.isDesktop
          "${registries.nix.vscodium}/bin/codium"
          "${registries.nix.nano}/bin/nano";
    enby                                =   "${registries.nix.man-db}/bin/man";
    frg
    =   ''
          :(){
            unset -f :
            if [ "$#" -ne "0" ]
            then
              regex="$1"
              shift 1
              echo "find:  $@"
              echo "regex: $regex"
              ${registries.nix.findutils}/bin/find $@ | ${registries.nix.ripgrep}/bin/rg $regex
            else
              echo "$0 regex [find-options]"
            fi
          };:\
        '';
    fuck
    =   ''
          :(){
            unset -f :
            TF_PYTHONIOENCODING=$PYTHONIOENCODING;
            export TF_SHELL=${registries.nix.zsh}/bin/zsh;
            export TF_ALIAS=fuck;
            TF_SHELL_ALIASES=$(alias);
            export TF_SHELL_ALIASES;
            TF_HISTORY="$(fc -ln -10)";
            export TF_HISTORY;
            export PYTHONIOENCODING=utf-8;
            TF_CMD=$(thefuck THEFUCK_ARGUMENT_PLACEHOLDER $@) && eval $TF_CMD;
            unset TF_HISTORY;
            export PYTHONIOENCODING=$TF_PYTHONIOENCODING;
            test -n "$TF_CMD" && print -s $TF_CMD
          };:\
        '';
    l                                   =   "${registries.nix.exa}/bin/exa -l@ah";
    inherit lt;
    man
    =   ''
          :(){
            unset -f :
            echo "Use"
            echo "  enby $@"
            echo "Fight teh cistem!"
          };:\
        '';
    nixsh                               =   "${registries.nix.nix}/bin/nix-shell --run ${registries.nix.zsh}/bin/zsh ";
    please                              =   "${registries.nix.sudo}/bin/sudo";
    py                                  =   "${registries.python3.ipython}/bin/ipython";
    rainbow
    =   ''
          for x in {0..8}
          do
            for i in {30..37}
            do
              for a in {40..47}
              do
                echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
              done
              echo ""
            done
          done
        '';
    use                                 =   "useFrom https://github.com/sivizius/nixpkgs/archive/master.tar.gz";
    useFrom
    =   ''
          :(){
            unset -f :
            nixpkgs="$1"
            shift 1
            mkdir -p "~/.cache/use/"
            for p in $@
            do
              echo "$p@$nixpkgs" >> "~/.cache/use/history.log"
            done
            ${registries.nix.nix}/bin/nix-shell -I nixpkgs=$nixpkgs --packages $@
          };:\
        '';
  }
  //  (
        set.generate
          (
            index:
            {
              name                      =   "l${string (index + 1)}";
              value                     =   "${lt}${string (index + 1)}";
            }
          )
          9
      )
