{ profile, ... }:
{
  enable                                =   profile.isDesktop;
  backgroundColor                       =   "#00000070";
  borderColor                           =   "#ffffffff";
  defaultTimeout                        =   16000;
  font                                  =   "pango:\"Font Awesome 5 Free 100\",RobotoMono10,NotoColorEmoji10";
  maxVisible                            =   2;
  sort                                  =   "-time";
  textColor                             =   "#ffffffff";
}
