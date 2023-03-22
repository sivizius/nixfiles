{ core, ... }:
  Library "libweb"
    { inherit core; }
    {
      vCard                             =   ./vCard;
    }
