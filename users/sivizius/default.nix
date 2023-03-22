{ ... } @ extra:
  User "Sebastian Walz"
  {
    inherit extra;
    configuration                       =   ./config;
    dates
    =   {
          "1996-10-03"                  =   "Birthday";
        };
    keys
    =   {
          aleph                         =   [ ./keys/ssh/aleph.nix ];
        };
  }
