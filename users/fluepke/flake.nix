{
  description                           =   "User-Configuration of fluepke";
  inputs
  =   {
        libconfig.url                   =   "github:sivizius/nixfiles/development?dir=libs/config";
      };
  outputs
  =   { libconfig, ... }:
      {
        user                            =   libconfig.lib.users.load ./.;
      };
}
