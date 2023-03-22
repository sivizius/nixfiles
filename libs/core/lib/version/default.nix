{ intrinsics, list, string, time, type, ... }:
  let
    Version# { major: string, minor: string, patch: string } -> Version
    =   type "Version"
        {
          from
          =   { major, minor, patch }:
                Version.instanciate
                {
                  inherit major minor patch;
                };
        };
  in
  {
    compare#: string -> string -> int
    =   intrinsics.compareVersions;

    deriveVersion#: ?
    =   dateTime:
          let
            dateTime'                   =   time dateTime;
            pad
            =   value:
                  if  value == null
                  then
                    "00"
                  else if value < 10
                  then
                    "0${string value}"
                  else
                    string value;
            month                       =   pad dateTime'.month;
            day                         =   pad dateTime'.day;
            hour                        =   pad dateTime'.hour;
            minute                      =   pad dateTime'.minute;
            second                      =   pad dateTime'.second;
          in
            if dateTime' != null
            then
              "${string dateTime'.year}-${month}-${day}T${hour}:${minute}:${second}"
            else
              "dev";

    language#: string?
    =   intrinsics.langVersion or null;

    main#: string -> string
    =   version: "${string version.major}.${string version.minor}";

    nix#: string?
    =   intrinsics.nixVersion or null;

    parseDerivationName#: string -> { name: string, version: string }
    =   intrinsics.parseDrvName
    or  (
          derivationName:
            let
              result                    =   string.match "(([^-]|-[^0-9])*)-([0-9].*)" derivationName;
            in
            {
              name                      =   list.get result 0;
              version                   =   list.get result 2;
            }
        );

    split#: string -> Version
    =   version:
          let
            result                      =   string.split "[.]" version;
          in
            Version
            {
              major                     =   list.get result 0;
              minor                     =   list.get result 1;
              patch                     =   list.get result 2;
            };

    split'#: string -> [ string ]
    =   intrinsics.splitVersion
    or  (
          version:
            string.splitAt "[.]" version
        );
  }
