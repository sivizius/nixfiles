{ home-manager, ... }:
  let
    inherit(home-manager.htop) bar graph led text fields layouts;
  in
  {
    enable                              =   true;
    settings
    =   {
          account_guest_in_cpu_meter    =   false;
          cpu_count_from_one            =   false;
          color_scheme                  =   0;
          delay                         =   9;
          detailed_cpu_time             =   false;
          enable_mouse                  =   true;
          header_margin                 =   true;
          hide_function_bar             =   false;
          hide_kernel_threads           =   true;
          hide_threads                  =   false;
          hide_userland_threads         =   false;
          highlight_base_name           =   false;
          highlight_megabytes           =   true;
          highlight_threads             =   true;
          shadow_other_users            =   true;
          show_program_path             =   true;
          show_thread_names             =   false;
          sort_direction                =   1;
          sort_key                      =   fields.PERCENT_CPU;
          tree_view                     =   false;
          update_process_names          =   false;
          fields
          =   with fields;
              [
                PID
                USER
                PRIORITY
                NICE
                STATE
                MAJFLT
                IO_READ_RATE
                IO_WRITE_RATE
                PERCENT_CPU
                PERCENT_MEM
                M_SWAP
                COMM
              ];
        }
    //  (
          layouts.four_25_25_25_25
          [
            [
              ( bar   "AllCPUs"     )
            ]
            [
              ( text  "LoadAverage" )
              ( text  "Tasks"       )
              ( graph "CPU"         )
              ( bar   "Memory"      )
              ( bar   "Swap"        )
            ]
            [
              ( graph "NetworkIO"   )
              ( graph "DiskIO"      )
            ]
            [
              ( led   "Clock"       )
              ( text  "Date"        )
              ( text  "System"      )
              ( text  "Hostname"    )
              ( text  "Uptime"      )
              ( text  "Systemd"     )
            ]
          ]
        );
  }
