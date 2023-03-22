{ core, ... }:
  Library "libsecrets"
    { inherit core; }
    {
      secret                            =   ./secret;
      vault                             =   ./vault;
    }
