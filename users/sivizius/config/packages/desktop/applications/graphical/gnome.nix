{ nix, ... }:
with nix;
[
  adwaita-icon-theme
  hicolor-icon-theme

  atk
  nautilus
  #gdk-pixbuf
  gtk3
  libappindicator-gtk3
  pango
  sushi
]
