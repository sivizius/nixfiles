{ debug, integer, intrinsics, list, set, string, target, type, ... }:
  let
    inherit(target) Architecture Kernel;

    System#: struct { architecture: Architecture, kernel: Kernel }
    =   type "System"
        {
          inherit all stdenv;

          current                       =   fromString ( intrinsics.currentSytem or "unknown-none" );

          mapAll#: T: ( System -> T ) -> { string -> T }
          =  map all;

          mapStdenv#: T: ( System -> T ) -> { string -> T }
          =  map stdenv;

          from#: type -> string | { architecture: string? = null, kernel: string? = null } -> System | !
          =   system:
                type.matchPrimitiveOrPanic system
                {
                  set                   =   fromSet     system;
                  string                =   fromString  system;
                };
        };

    all#: { string -> System }
    =   list.mapNamesToSet fromString
        [
          # Cygwin
          "i686-cygwin" "x86_64-cygwin"

          # Darwin
          "x86_64-darwin" "i686-darwin" "aarch64-darwin" "armv7a-darwin"

          # FreeBSD
          "i686-freebsd" "x86_64-freebsd"

          # Genode
          "aarch64-genode" "i686-genode" "x86_64-genode"

          # illumos
          "x86_64-solaris"

          # JS
          "js-ghcjs"

          # Linux
          "aarch64-linux" "armv5tel-linux" "armv6l-linux" "armv7a-linux"
          "armv7l-linux" "i686-linux" "m68k-linux" "microblaze-linux"
          "microblazeel-linux" "mipsel-linux" "mips64el-linux" "powerpc64-linux"
          "powerpc64le-linux" "riscv32-linux" "riscv64-linux" "s390-linux"
          "s390x-linux" "x86_64-linux"

          # MMIXware
          "mmix-mmixware"

          # NetBSD
          "aarch64-netbsd" "armv6l-netbsd" "armv7a-netbsd" "armv7l-netbsd"
          "i686-netbsd" "m68k-netbsd" "mipsel-netbsd" "powerpc-netbsd"
          "riscv32-netbsd" "riscv64-netbsd" "x86_64-netbsd"

          # none
          "aarch64_be-none" "aarch64-none" "arm-none" "armv6l-none" "avr-none" "i686-none"
          "microblaze-none" "microblazeel-none" "msp430-none" "or1k-none" "m68k-none"
          "powerpc-none" "powerpcle-none" "riscv32-none" "riscv64-none" "rx-none"
          "s390-none" "s390x-none" "vc4-none" "x86_64-none"

          # OpenBSD
          "i686-openbsd" "x86_64-openbsd"

          # Redox
          "x86_64-redox"

          # WASI
          "wasm64-wasi" "wasm32-wasi"

          # Windows
          "x86_64-windows" "i686-windows"
        ];

    stdenv
    =   {
          inherit(all)  aarch64-linux aarch64-darwin
                        x86_64-linux  x86_64-darwin;
        };

    fromSet#: { architecture: ToArchitecture? = null, kernel: ToKernel = null } -> System
    =   { architecture ? null, kernel ? null }:
          System.instanciate
          {
            __toString#: { architecture: Architecture, kernel: Kernel } -> string
            =   { architecture, kernel, ... }:
                  "${string architecture}-${string kernel}";
            architecture                =   Architecture  architecture;
            kernel                      =   Kernel        kernel;
          };

    fromString#: string -> System | !
    =   name:
          let
            parts                       =   string.match "(.*)-(.*)" name;
          in
            if parts != null
            then
              fromSet
              {
                architecture            =   list.get parts 0;
                kernel                  =   list.get parts 1;
              }
            else
              debug.panic
                "fromString"
                {
                  text
                  =   ''
                        Cannot convert »${name}« to System!
                        A name must be »architecture-kernel«.
                      '';
                  data                  =   name;
                };

    map#: T: { string -> System } -> ( System -> T ) -> { string -> T }
    =   systems:
        convert:
          set.mapValues convert systems;
  in
    System
