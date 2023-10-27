{ core, profile, ... } @ env:
extra:
let
  inherit (core) path;
in
{
  #abook = path.import ./abook         env;

  alacritty = path.import ./alacritty.nix env;
  bash = path.import ./bash.nix env;
  firefox = path.import ./firefox.nix env;
  git = path.import ./git.nix env;
  htop = path.import ./htop.nix env;
  mbsync.enable = profile.isDesktop;
  #nano = path.import ./nano          env;
  neomutt = path.import ./neomutt.nix env extra;
  ssh = path.import ./ssh.nix env;
  zsh = path.import ./zsh.nix env;

  # Installs https://github.com/hickford/git-credential-oauth
  # Might be useful, set to `false` if you do not want it.
  git-credential-oauth.enable = true;
}
