{ profile, ... }:
{
  enable                                =   profile.isDesktop;
  settings
  =   {
        font.normal
        =   {
              family                    =   "Noto Sans Mono";
              size                      =   9.0;
            };

        colors
        =   {
              primary
              =  {
                    background          =   "0x000000";
                    foreground          =   "0xeaeaea";
                  };
              normal
              =   {
                    black               =   "0x6c6c6c";
                    red                 =   "0xe9897c";
                    green               =   "0xb6e77d";
                    yellow              =   "0xecebbe";
                    blue                =   "0xa9cdeb";
                    magenta             =   "0xea96eb";
                    cyan                =   "0xc9caec";
                    white               =   "0xf2f2f2";
                  };
              bright
              =   {
                    black               =   "0x747474";
                    red                 =   "0xf99286";
                    green               =   "0xc3f786";
                    yellow              =   "0xfcfbcc";
                    blue                =   "0xb6defb";
                    magenta             =   "0xfba1fb";
                    cyan                =   "0xd7d9fc";
                    white               =   "0xe2e2e2";
                  };
            };
        window
        =   {
              opacity                   =   0.6;
            };
    };
}
