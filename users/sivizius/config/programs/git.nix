{ user, ... }:
{
  enable = true;
  extraConfig = {
    branch = {
      # Most-recent branch first:
      sort = "-committerdate";
    };

    column = {
      ui = "auto";
    };

    commit = {
      # Include diff as a comment when editing the commit message:
      verbose = true;
    };

    diff = {
      algorithm = "histogram";
      colorMoved = "plain";
      mnemonicPrefix = true;
      renames = true;
    };

    fetch = {
      all = true;
      fsckObjects = true;
      prune = true;
      pruneTags = true;
    };

    help = {
      autocorrect = "prompt";
    };

    init = {
      defaultBranch = "development";
    };

    log = {
      date = "iso";
    };

    merge = {
      conflictstyle = "zdiff3";
    };

    pull = {
      rebase = true;
    };

    push = {
      # No more `--set-upstream origin HEAD`:
      autoSetupRemote = true;
      default = "simple";
      followTags = true;
    };

    rebase = {
      autoSquash = true;
      autoStash = true;
      updateRefs = true;
    };

    receive = {
      fsckObjects = true;
    };

    rerere = {
      # Record merge conflict resolutions:
      enabled = true;

      # Apply recorded resolutions:
      autoupdate = true;
    };

    tag = {
      sort = "version:refname";
    };

    transfer = {
      fsckObjects = true;
    };
  };
  delta.enable = true;
  signing = {
    key = "9ECC4999AE01F9906C80B1BB5516370FA26C395C";
    signByDefault = true;
  };
  userName = user.realName;
  userEmail = "sebastian.walz@secunet.com";
}
