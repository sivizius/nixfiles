{ core, registries, user, ... }:
  let
    inherit(core) set;
    inherit(user.extra.config) packages;
  in
    set.mapValues
      (directory: packages.load directory registries)
      {
        common                          =   ./common;
        desktop                         =   ./desktop;
      }
