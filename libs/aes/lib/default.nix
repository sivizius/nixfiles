{ core, ... }:
  Library "libaes"
    { inherit core; }
    {
      decrypt                           =   ./decrypt;
      encrypt                           =   ./encrypt;
      key                               =   ./key;
      helpers                           =   ./helpers;
      serde                             =   ./serde;
    }
