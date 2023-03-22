{ context, ... } @ libs:
  let
    libs'                               =   libs // { context = context ++ [ "style" ]; };
    tuc                                 =   import ./tuc.nix      ( libs' // { inherit vanilla; } );
    vanilla                             =   import ./vanilla.nix  libs';
  in
    { inherit tuc vanilla; }
