{ debug, integer, intrinsics, list, set, string, type, ... }:
  let
    Architecture#: struct { bits: integer, endianness: Endianness, family: Family }
    =   type "Architecture"
        {
          inherit Endianness Family;
          inherit all families;

          from#: type -> (string | Architecture)? -> Architecture
          =   architecture:
                if !(Architecture.isInstanceOf architecture)
                then
                  type.matchPrimitiveOrPanic architecture
                  {
                    null                =   all.unknown;
                    string              =   all.${architecture} or (debug.panic "Architecture" "Unknown architecture »${architecture}«!");
                  }
                else
                  architecture;
        };

    Endianness#: enum { big, little, none }
    =   type.enum "Endianness"
        {
          big                           =   1;
          little                        =   2;
          none                          =   3;
        };

    Family#: type
    =   type "Family"
        {};#{ name = string; arch = string || null; version = integer || null; };

    all#: { string -> Architecture }
    =   let
          new#: integer -> Endianness -> Family -> Architecture
          =   bits:
              endianness:
              family:
                Architecture.instanciate
                {
                  __toString            =   { name, ... }: name;
                  inherit bits endianness family;
                };
          all
          =   {
                aarch64                 =   new   64  Endianness.little families.arm8-a;
                aarch64_be              =   new   64  Endianness.big    families.arm8-a;
                alpha                   =   new   64  Endianness.little families.alpha;
                amd64                   =   new   64  Endianness.little families.amd64;
                arm                     =   new   32  Endianness.little families.arm;
                armv5tel                =   new   32  Endianness.little families.arm5t;
                armv6m                  =   new   32  Endianness.little families.arm6-m;
                armv6l                  =   new   32  Endianness.little families.arm6;
                armv7a                  =   new   32  Endianness.little families.arm7-a;
                armv7r                  =   new   32  Endianness.little families.arm7-r;
                armv7m                  =   new   32  Endianness.little families.arm7-m;
                armv7l                  =   new   32  Endianness.little families.arm7;
                armv8a                  =   new   32  Endianness.little families.arm8-a;
                armv8r                  =   new   32  Endianness.little families.arm8-a;
                armv8m                  =   new   32  Endianness.little families.arm8-m;
                avr                     =   new    8  Endianness.none   families.avr;
                i386                    =   new   32  Endianness.little families.i386;
                i486                    =   new   32  Endianness.little families.i486;
                i586                    =   new   32  Endianness.little families.i586;
                i686                    =   new   32  Endianness.little families.i686;
                js                      =   new   32  Endianness.little families.js;
                m68k                    =   new   32  Endianness.big    families.m68k;
                microblaze              =   new   32  Endianness.big    families.microblaze;
                microblazeel            =   new   32  Endianness.little families.microblaze;
                mips                    =   new   32  Endianness.big    families.mips;
                mips64                  =   new   64  Endianness.big    families.mips;
                mips64el                =   new   64  Endianness.little families.mips;
                mipsel                  =   new   32  Endianness.little families.mips;
                mmix                    =   new   64  Endianness.big    families.mmix;
                msp430                  =   new   16  Endianness.little families.msp430;
                or1k                    =   new   32  Endianness.big    families.or1k;
                powerpc                 =   new   32  Endianness.big    families.power;
                powerpc64               =   new   64  Endianness.big    families.power;
                powerpc64le             =   new   64  Endianness.little families.power;
                powerpcle               =   new   32  Endianness.little families.power;
                riscv32                 =   new   32  Endianness.little families.riscv;
                riscv64                 =   new   64  Endianness.little families.riscv;
                rx                      =   new   32  Endianness.little families.rx;
                s390                    =   new   32  Endianness.big    families.s390;
                s390x                   =   new   64  Endianness.big    families.s390;
                sparc                   =   new   32  Endianness.big    families.sparc;
                sparc64                 =   new   64  Endianness.big    families.sparc;
                unknown                 =   new null  Endianness.none   families.unknown;
                vc4                     =   new   32  Endianness.little families.vc4;
                wasm32                  =   new   32  Endianness.little families.wasm;
                wasm64                  =   new   64  Endianness.little families.wasm;
                x86_64                  =   all.amd64;
              };
        in
          set.name all;

    families#: { string -> Family }
    =   {
          alpha                         =   { name = "alpha"; };
          amd64                         =   families.x86  //  { arch  = "amd64";                };
          arm                           =   { name = "arm"; };
          arm5                          =   families.arm  //  { arch  = "armv5";  version = 5;  };
          arm5t                         =   families.arm5 //  { arch  = "armv5t";               };
          arm6                          =   families.arm  //  { arch  = "armv6";  version = 6;  };
          arm6-m                        =   families.arm6 //  { arch  = "armv6-m";              };
          arm7                          =   families.arm  //  { arch  = "armv7";  version = 7;  };
          arm7-a                        =   families.arm7 //  { arch  = "armv7-a";              };
          arm7-m                        =   families.arm7 //  { arch  = "armv7-m";              };
          arm7-r                        =   families.arm7 //  { arch  = "armv7-r";              };
          arm8                          =   families.arm  //  { arch  = "armv8";  version = 8;  };
          arm8-a                        =   families.arm8 //  { arch  = "armv8-a";              };
          arm8-m                        =   families.arm8 //  { arch  = "armv8-m";              };
          avr                           =   { name = "avr"; };
          i386                          =   families.x86  //  { arch  = "i386";                 };
          i486                          =   families.x86  //  { arch  = "i486";                 };
          i586                          =   families.x86  //  { arch  = "i586";                 };
          i686                          =   families.x86  //  { arch  = "i686";                 };
          js                            =   { name = "js"; };
          m68k                          =   { name = "m68k"; };
          microblaze                    =   { name = "microblaze"; };
          mips                          =   { name = "mips"; };
          mmix                          =   { name = "mmix"; };
          msp430                        =   { name = "msp430"; };
          or1k                          =   { name = "or1k"; };
          power                         =   { name = "power"; };
          riscv                         =   { name = "riscv"; };
          rx                            =   { name = "rx"; };
          s390                          =   { name = "s390"; };
          sparc                         =   { name = "sparc"; };
          unknown                       =   { name = "unknown"; };
          vc4                           =   { name = "vc4"; };
          wasm                          =   { name = "wasm"; };
          x86                           =   { name = "x86"; };
          x86_64                        =   families.amd64;
        };
  in
    Architecture
