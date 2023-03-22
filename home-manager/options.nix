{ modules, ... }:
  let
    inherit(modules) options types;
    literalExpression
    =   text:
        {
          _type                         =   "literalExpression";
          inherit text;
        };
  in
  {
    home-manager."sivizius"
    =   {
          shell
          =   options.mkOption
              {
                type                    =   types.nullOr types.shellPackage;
                default                 =   null;
                defaultText             =   literalExpression "pkgs.zsh";
                description
                =   ''
                      The user’s shell derivations, like pkgs.zsh,
                        or null for system default.
                    '';
              };
        };
  }
