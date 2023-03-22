{ core, registries, ... }:
{
  fonts
  =   {
        fonts
        =   with registries.nix;
            [
              dejavu_fonts
              font-awesome_5
              liberation_ttf
              noto-fonts
              noto-fonts-emoji
              roboto
              roboto-mono
              roboto-slab
              unifont
            ];
        fontconfig
        =   {
              localConf                 =   core.path.readFile ./fontconfig.xml;
              defaultFonts
              =   {
                    emoji               =   [ "Noto Color Emoji"  ];
                    serif               =   [ "Dejavu Serif"      ];
                    sansSerif           =   [ "Roboto Condensed"  ];
                    monospace           =   [ "Roboto Mono"       ];
                  };
            };
      };
}
