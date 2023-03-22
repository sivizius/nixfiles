{ user, ... }:
{
  enable                                =   true;
  extraConfig.init.defaultBranch        =   "development";
  delta.enable                          =   true;
  signing
  =   {
        key                             =   "6A6A9F7C47BA4CBEDCD5CB747BB421C684E821D8";
        signByDefault                   =   true;
      };
  userName                              =   user.realName;
  userEmail                             =   "sivizius@sivizius.eu";
}
