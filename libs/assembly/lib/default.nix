{ core, ... }:
  Library "libaes"
    { inherit core; }
    {
      mos6502                           =   ./mos6502;
    }
