{ ... }:
let
  realName                              =   "Sebastian Walz";
  gpg
  =   {
        encryptByDefault                =   false;
        key                             =   "6A6A9F7C47BA4CBEDCD5CB747BB421C684E821D8";
        signByDefault                   =   true;
      };
in
{
  "sivizius@ohai.su"
  =   {
        index                           =   2;
        host                            =   "imap.fnoco.eu";
        inherit gpg realName;
      };
  "sivizius@sivizius.eu"
  =   {
        index                           =   0;
        host                            =   "sivizius.eu";
        primary                         =   true;
        inherit gpg realName;
      };
  "root@sivizius.eu"
  =   {
        index                           =   1;
        host                            =   "sivizius.eu";
        inherit gpg realName;
      };
}
