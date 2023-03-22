let
  wsWebBrowser                          =   "0";
  wsFileBrowser                         =   "1";
  wsMailClient                          =   "2";
  wsMessenger                           =   "3";
  wsDevelopment                         =   "4";
in
{
  ${wsWebBrowser}
  =   [
        { app_id                        =   "^firefox$";              }
        { class                         =   "^Spotify$";              }
      ];
  ${wsFileBrowser}
  =   [
        { title                         =   "^ranger$";               }
      ];
  ${wsMailClient}
  =   [
        { title                         =   "^neomutt$";              }
      ];
  ${wsMessenger}
  =   [
        { app_id                        =   "^org.telegram.desktop$"; }
        { app_id                        =   "^dino$";                 }
        { title                         =   "^nheko";                 }
        { class                         =   "^discord$";              }
        { class                         =   "^Mumble$";               }
        { class                         =   "^Signal$";               }
        { class                         =   "^SchildiChat$";          }
      ];
  ${wsDevelopment}
  =   [
        { class                         =   "^VSCodium$";             }
      ];
}
