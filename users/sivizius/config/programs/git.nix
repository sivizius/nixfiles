{ user, ... }:
{
  enable = true;
  extraConfig.init.defaultBranch = "development";
  delta.enable = true;
  signing = {
    key = "9ECC4999AE01F9906C80B1BB5516370FA26C395C";
    signByDefault = true;
  };
  userName = user.realName;
  userEmail = "sebastian.walz@secunet.com";
}
