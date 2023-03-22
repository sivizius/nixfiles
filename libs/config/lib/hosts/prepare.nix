{ about, configurations, core, devices, networks, profiles, systems, users, versions, ... }:
{ ... } @ environment:
  let
    inherit(configurations) Configuration';
    inherit(core) debug list path type;

    ConfigConfiguration                 =   Configuration' "Config";

    fail
    =   hostName:
        fieldName:
          debug.panic "prepareHost" "Field `${fieldName}` of host `${hostName}` missing!";

    prepareAbout                        =   about.prepare       environment;
    prepareConfig
    =   { source, ... }:
          list.map
          (
            fileName:
              ConfigConfiguration
              {
                configuration           =   path.import fileName;
                source                  =   source fileName;
              }
          );
    prepareDevices                      =   devices.prepare     environment;
    prepareNetwork                      =   networks.prepare    environment;
    prepareProfile                      =   profiles.prepare    environment;
    prepareSystem                       =   systems.prepare     environment;
    prepareUsers                        =   users.prepare       environment;
    prepareVersion                      =   versions.prepare    environment;
  in
    {
      about,
      config      ? [],
      devices     ? fail host.name "devices",
      name,
      network     ? fail host.name "network",
      profile     ? fail host.name "profile",
      source,
      system      ? fail host.name "system",
      users       ? fail host.name "users",
      version     ? fail host.name "version",
      ...
    } @ host:
      let
        env
        =   {
              inherit name source;
            };
      in
      {
        inherit name source;
        about                           =   prepareAbout      env about;
        config                          =   prepareConfig     env config;
        devices                         =   prepareDevices    env devices;
        network                         =   prepareNetwork    env network;
        profile                         =   prepareProfile    env profile;
        system                          =   prepareSystem     env system;
        users                           =   prepareUsers      env users;
        version                         =   prepareVersion    env version;
      }