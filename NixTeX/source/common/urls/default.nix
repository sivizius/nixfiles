{ core, ... }:
  let
    inherit(core) string;
    escape                              =   string.replace [ "_" "%" ] [ "\\_" "\\%" ];
    formatEmailTeX                      =   href: formatTeX "mailto:${href}";
    formatHttpsTeX                      =   href: formatTeX "https://${href}";
    formatHttpsTeX'                     =   href: formatTeX "https:\\//${href}";
    formatTeX                           =   href: text: "\\href{${href}}{${escape text}}";
  in
  {
    inherit formatEmailTeX formatHttpsTeX formatHttpsTeX' formatTeX;
    formatEmailTeXboxed                 =   href: text: "\\mbox{${formatEmailTeX  href text}}";
    formatHttpsTeXboxed                 =   href: text: "\\mbox{${formatHttpsTeX  href text}}";
    formatHttpsTeXboxed'                =   href: text: "\\mbox{${formatHttpsTeX' href text}}";
    formatTeXboxed                      =   href: text: "\\mbox{${formatTeX       href text}}";
  }
