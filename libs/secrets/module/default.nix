{ core, ... } @ libs:
{ config, lib, pkgs, ... } @ env:
  let
    inherit(core) path;
  in
  {
    options.vault                       =   path.import ./options.nix  libs env;
    config                              =   path.import ./config.nix   libs env;
  }
