{ configurations, core, packages, ... }:
  let
    inherit(configurations) Configuration;
    inherit(core)           debug list path set string time type;

    loadKey
    =   { hostName, realName }:
        key:
          let
            convert
            =   { contact ? null, date ? null, key, method, ... }:
                  let
                    contact'
                    =   if contact != null
                        then
                          " contact = \"${contact}\";"
                        else
                          "";
                    date'               =   time date;
                    pad                 =   value: if value < 10 then "0${string value}" else string value;
                    date''
                    =   if date != null
                        then
                          " date = \"${string date'.year}-${pad date'.month}-${pad date'.day}\";"
                        else
                          "";
                  in
                    ''ssh-${method} ${key} { host = "${hostName}"; owner = "${realName}";${contact'}${date''} }'';
          in
            if path.isInstanceOf key
            then
              convert (path.import key)
            else
              convert key;

    User
    =   type "User"
        {
          from
          =   realName:
              {
                configuration ? {},
                dates         ? {},
                extra         ? {},
                keys          ? {},
              }:
                User.instanciate
                {
                  inherit configuration;
                  trusted               =   false;
                  user
                  =   {
                        inherit dates extra realName;
                        keys
                        =   set.map
                              (
                                hostName:
                                hostKeys:
                                  if hostKeys == null
                                  then
                                    []
                                  else if list.isInstanceOf hostKeys
                                  then
                                    list.map (loadKey { inherit hostName realName; }) hostKeys
                                  else
                                    [ (loadKey { inherit hostName realName; } hostKeys) ]
                              )
                              keys;
                      };
                };
        };

    UserConfiguration
    =   Configuration "User"
        {
          call
          =   { environment, host, modules, ... }:
              { arguments, configuration, user, wrap, ... }:
                let
                  environment'
                  =   environment
                  //  {
                        inherit packages;
                        user
                        =   user
                        //  {
                              extra
                              =   set.mapValues
                                    (
                                      extra:
                                        extra."${host.system}" or extra
                                    )
                                    user.extra;
                            };
                        inherit(host) profile system version;
                      };
                  hasHomeManager        =   modules.home-manager or null != null;
                in
                  wrap
                  {
                    inherit hasHomeManager host user;
                    configuration
                    =   configuration
                        (
                          environment'
                          //  {
                                config
                                =   if hasHomeManager
                                    then
                                      environment.config.home-manager.users.${user.name}
                                    else
                                      debug.error
                                        "UserConfiguration"
                                        "Empty `config`, because home-manager is missing."
                                        {};
                              }
                        );
                  };
          wrap
          =   { configuration, hasHomeManager, host, user, ... }:
                {
                  users.users.${user.name}
                  =   configuration.host
                  //  {
                        isNormalUser    =   true;
                        openssh.authorizedKeys
                        =   {
                              keys
                              =   debug.info [ "UserConfiguration" "openssh.authorizedKeys" ]
                                  {
                                    text = "${user.name}@${host.network.hostName}";
                                    show = true;
                                  }
                                  user.keys.${host.network.hostName} or [];
                            };
                      };
                }
                //  (
                      if hasHomeManager
                      then
                      {
                        home-manager.users.${user.name}
                        =   set.remove
                              configuration
                              [ "host" ];
                      }
                      else
                        debug.error
                          "UserConfiguration"
                          "Module `home-manager` is missing."
                          {}
                    );
        };

    collect                             =   users: list.concatMap configure (set.values users);

    configure
    =   { configuration, user, source, trusted, ... }:
          list.map
            UserConfiguration
            (
              configurations.collect
              {
                inherit configuration user source;
              }
            );

    constructors
    =   {
          inherit User;
        };

    load
    =   source:
        environment:
          configurations.load
            source
            environment
            constructors
            User;

    prepare
    =   environment:
        host:
        users:
          if set.isInstanceOf users
          then
            set.map (prepareUser environment host) users
          else
            debug.panic "prepare" "The option `users` must be a set.";

    prepareUser
    =   environment:
        host:
        name:
        user:
          {
            source                      =   host.source "users" name;
          }
          //  (User.expect user)
          //  {
                user
                =   user.user
                //  { inherit name; };
              };
  in
    constructors
    //  {
          inherit collect constructors load prepare;
        }
