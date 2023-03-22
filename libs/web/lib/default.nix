{ core, ... }:
  Library "libweb"
    { inherit core; }
    {
      css                              =   ./css;
      html                             =   ./html;
    }
