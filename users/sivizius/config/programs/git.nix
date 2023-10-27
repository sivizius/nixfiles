{ user, ... }:
{
  enable = true;
  extraConfig.init.defaultBranch = "development";
  delta.enable = true;
  signing = {
    key = "CC1862DD37260C5EF4DA26C79CB027E330D31FB0";
    signByDefault = true;
  };
  userName = user.realName;
  userEmail = "sebastian.walz@secunet.com";
}
