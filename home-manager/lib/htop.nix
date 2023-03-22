{ core, ... }:
  let
    inherit(core) list string;
    formatMeters
    =   side:
        meters:
        {
          "${side}_meters"              =   list.map ({ name, ... }: name) meters;
          "${side}_meter_modes"         =   list.map ({ mode, ... }: mode) meters;
        };

    leftMeters                          =   formatMeters "left";
    rightMeters                         =   formatMeters "right";

    getNames                            =   column: string.concatWords (list.map ({name, ... }: name) column);
    getModes                            =   column: string.concatWords (list.map ({mode, ... }: string mode) column);
    toMeters
    =   header_layout:
        columns:
        (
          list.fold
          (
            { index, result }:
            column:
              {
                index                   =   index + 1;
                result
                =   result
                //  {
                      "column_meters_${string index}"
                      =   getNames column;
                      "column_meter_modes_${string index}"
                      =   getModes column;
                    };
              }
          )
          {
            index                       =   0;
            result                      =   { inherit header_layout; };
          }
          columns
        ).result;

    fields
    =   {
          PID                           =   0;
          COMM                          =   1;
          STATE                         =   2;
          PPID                          =   3;
          PGRP                          =   4;
          SESSION                       =   5;
          TTY_NR                        =   6;
          TPGID                         =   7;
          MINFLT                        =   9;
          MAJFLT                        =   11;
          PRIORITY                      =   17;
          NICE                          =   18;
          STARTTIME                     =   20;
          PROCESSOR                     =   37;
          M_SIZE                        =   38;
          M_RESIDENT                    =   39;
          ST_UID                        =   45;
          PERCENT_CPU                   =   46;
          PERCENT_MEM                   =   47;
          USER                          =   48;
          TIME                          =   49;
          NLWP                          =   50;
          TGID                          =   51;
          PERCENT_NORM_CPU              =   52;
          ELAPSED                       =   53;
          CMINFLT                       =   10;
          CMAJFLT                       =   12;
          UTIME                         =   13;
          STIME                         =   14;
          CUTIME                        =   15;
          CSTIME                        =   16;
          M_SHARE                       =   40;
          M_TRS                         =   41;
          M_DRS                         =   42;
          M_LRS                         =   43;
          M_DT                          =   44;
          CTID                          =   99;
          VPID                          =   100;
          VXID                          =   102;
          RCHAR                         =   102;
          WCHAR                         =   103;
          SYSCR                         =   104;
          SYSCW                         =   105;
          RBYTES                        =   106;
          WBYTES                        =   107;
          CNCLWB                        =   108;
          IO_READ_RATE                  =   109;
          IO_WRITE_RATE                 =   110;
          IO_RATE                       =   111;
          CGROUP                        =   112;
          OOM                           =   113;
          IO_PRIORITY                   =   114;
          M_PSS                         =   118;
          M_SWAP                        =   119;
          M_PSSWP                       =   120;
        };

    modes
    =   {
          Bar                           =   1;
          Text                          =   2;
          Graph                         =   3;
          LED                           =   4;
        };

    # Utilities for constructing meters
    meter                               =   mode: name: { inherit mode name; };
    bar                                 =   meter modes.Bar;
    text                                =   meter modes.Text;
    graph                               =   meter modes.Graph;
    led                                 =   meter modes.LED;
    blank                               =   text "Blank";

    layouts
    =   list.mapNamesToSet
        (
          name:
          {
            __functor                   =   { ... }: toMeters name;
          }
        )
        [
          "two_50_50" "two_33_67" "two_67_33"
          "three_33_34_33" "three_25_25_50" "three_25_50_25" "three_50_25_25" "three_40_20_40"
          "four_25_25_25_25"
        ];
  in
  {
    inherit fields layouts modes leftMeters rightMeters meter bar text graph led blank;
  }
