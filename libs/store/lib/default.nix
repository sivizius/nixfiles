{ core, ... }:
  Library "libstore"
    { inherit core; }
    {
      write                             =   ./write.nix;
    }
