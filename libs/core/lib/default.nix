{
  checked     ? false,    # enable e.g. type-checks
  intrinsics  ? builtins, # intrinsic/builtin functions, variables, etc.
  ...
}:
  Library "libcore"
  {
    inherit checked intrinsics;
  }
  {
    ansi                                =   ./ansi;
    any                                 =   ./any;
    bool                                =   ./bool;
    check                               =   ./check;
    context                             =   ./context;
    debug                               =   ./debug;
    derivation                          =   ./derivation;
    dictionary                          =   ./dictionary;
    environment                         =   ./environment;
    error                               =   ./error;
    expression                          =   ./expression;
    flake                               =   ./flake;
    float                               =   ./float;
    function                            =   ./function;
    indentation                         =   ./indentation;
    integer                             =   ./integer;
    lambda                              =   ./lambda;
    library                             =   ./library;
    list                                =   ./list;
    never                               =   ./never;
    null                                =   ./null;
    number                              =   ./number;
    path                                =   ./path;
    set                                 =   ./set;
    string                              =   ./string;
    target                              =   ./target;
    time                                =   ./time;
    type                                =   ./type;
    version                             =   ./version;
  }
