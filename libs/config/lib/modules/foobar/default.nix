let
  # Methods
  inherit(builtins) attrNames foldl' getFlake import match removeAttrs replaceStrings trace;

  lib
  =   {
        extendPath
        =   path:
            name:
              let
                path'
                =   if path != null
                    then
                      "${path}."
                    else
                      "";
                this
                =   match
                      "[A-Za-z_][0-9A-Za-z_'-]*"
                      name;
                name'
                =   replaceStrings
                      [ "\""    "\n"  "\r"  "\t"  ]
                      [ "\\\""  "\\n" "\\r" "\\t" ]
                      name;
              in
                if this == [] then  "${path'}${name}"
                else                "${path'}\"${name'}\"";
      };

  format                                =   import ./format.nix   lib;
  toObject                              =   import ./toObjext.nix lib;

  modules
  =   nixpkgs.lib.evalModules
      {
        modules
        =   (import "${nixpkgs}/nixos/modules/module-list.nix")
        ++  [
              {
                nixpkgs.hostPlatform = "x86_64-linux";
              }
            ];
      };
  nixpkgs                               =   getFlake "github:sivizius/nixpkgs/master";

  options
  =   toObject null
      (
        removeAttrs
          (modules.options)
          [ "_module" "assertions" "warnings"
      );

  output                                =   format options;
in
  options
