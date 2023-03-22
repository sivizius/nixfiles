{ context, core, ... }:
  let
    inherit(core) list set string type;
    debug                               =   core.debug (context ++ [ "collect" ]);

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
            =   string.match
                  "[A-Za-z_][0-9A-Za-z_'-]*"
                  name;
            name'
            =   string.replace'
                {
                  "\""                  =   ''\"'';
                  "\n"                  =   ''\n'';
                  "\r"                  =   ''\r'';
                  "\t"                  =   ''\t'';
                }
                name;
          in
            if this == [] then  "${path'}${name}"
            else                "${path'}\"${name'}\"";


  in
  {
    __functor                           =   self: collect;
    configurations                      =   import ./configurations.nix { inherit core extendPath; context = context ++ [ "collect" "configurations" ]; };
    options                             =   import ./options.nix        { inherit core extendPath; context = context ++ [ "collect" "options" ]; };
  }