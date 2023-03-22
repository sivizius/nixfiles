{ configurations, core, ... }:
  let
    inherit(configurations) Configuration';
    inherit(core)           debug list set string type;

    __functor
    =   self:
        extraConfig:
          self // extraConfig;

    Device
    =   type.enum "Device"
        {
          Disk
          =   fsType:
              label:
              device:
              {
                inherit __functor device fsType label;
                configure
                =   index:
                    { device, fsType, label, name, source, ... }:
                      DeviceConfiguration
                      {
                        configuration.fileSystems.${name}
                        =   {
                              inherit fsType label;
                              device    =   toDevice device;
                            };
                        inherit source;
                      };
              };

          Swap
          =   device:
              {
                inherit __functor device;
                configure
                =   index:
                    { device, name, source, ... }:
                      DeviceConfiguration
                      {
                        configuration.swapDevices
                        =   [
                              {
                                device  =   toDevice device;
                              }
                            ];
                        inherit source;
                      };
              };
        };

    DeviceConfiguration                 =   Configuration' "Device";

    collect                             =   list.imap configure;

    configure
    =   index:
        { configure ? null, ... } @ device:
          configure index device;

    constructors
    =   {
          inherit Device;
          inherit(Device) Disk Swap;
          VFAT                          =   Device.Disk "vfat";
          XFS                           =   Device.Disk "xfs";
        };

    prepare
    =   environment:
        host:
        devices:
          if    set.isInstanceOf devices
          then
            set.mapToList
              (
                name:
                device:
                  {
                    source              =   host.source "devices" name;
                  }
                  //  (Device.expect device)
                  //  { inherit name; }
              )
              devices
          else if list.isInstanceOf devices
          then
            list.imap
              (
                index:
                device:
                  let
                    name                =   "#${string index}";
                  in
                  {
                    source              =   host.source "devices" index;
                  }
                  //  (Device.expect device)
                  //  { inherit name; }
              )
              devices
          else
            debug.panic "prepare" "The option `devices` must be a set or a list.";

    toDevice
    =   let
          toDevice
          =   { uuid ? null, ... }:
                if uuid != null
                then
                  "/dev/disk/by-uuid/${uuid}"
                else
                  debug.panic
                    "toDevice"
                    "Need either uuid, … or ….";
        in
          device:
            type.matchPrimitiveOrPanic device
            {
              string                    =   device;
              set                       =   toDevice device;
            };
  in
    constructors
    //  {
          inherit collect constructors prepare toDevice;
        }
