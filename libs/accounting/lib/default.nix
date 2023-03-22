{ core, ... }:
  Library "libaccounting"
    { inherit core; }
    {
      common                            =   ./common;
      double                            =   ./double;
      parse                             =   ./parse;
      schemes                           =   ./schemes;
      single                            =   ./single;
    }
