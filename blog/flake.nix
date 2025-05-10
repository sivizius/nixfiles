{
  description                           =   "sivizius’ personal blog.";
  inputs
  =   {

      };
  outputs
  =   { ... }:
        let
          core                          =   null;
        in
          import ./.
          {
            inherit core;
            context                     =   [ "blog" ];
          };
}