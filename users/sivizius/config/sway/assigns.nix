let
  wsWebBrowser = "0";
  wsFileBrowser = "1";
  wsMailClient = "2";
  wsMessenger = "3";
  wsDevelopment = "4";
in
{
  ${wsWebBrowser} = [
    { app_id = "^firefox$"; }
  ];
  ${wsFileBrowser} = [
    { title = "^ranger$"; }
  ];
  ${wsMailClient} = [
    { title = "^neomutt$"; }
    { app_id = "^org.gnome.Fractal$"; }
  ];
  ${wsMessenger} = [
  ];
  ${wsDevelopment} = [
    { class = "^VSCodium$"; }
  ];
}
