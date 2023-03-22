{ config, core, foreign, ... } @ libs:
  let
    inherit(core) path;
    inherit(config) modules;
  in
  {
    legacyModules                       =   path.import ./legacyModules libs;
    modules                             =   modules.load ./modules;
  }