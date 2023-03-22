{ nix, ... }:
  with nix;
  [
    # audio
    audacity
    pavucontrol

    # documents
    cairo
    evince
    #libreoffice
    pandoc
    pdfpc
    pdftk
    poppler_utils
    qpdf

    # images
    feh
    gimp
    imagemagick
    inkscape
    librsvg

    # video
    ffmpeg
    mpv
  ]
