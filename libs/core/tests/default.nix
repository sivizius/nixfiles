{ ... }:
{ ansi, debug, error, expression, set, target, ... } @ lib:
{
  deepSeqAll
  =   let
        lib'
        =   lib
        //  {
              never                     =   null;
            };
      in
        set.mapValues
        (
          module:
            ({ ... }: module)
        )
        lib';
  foo
  =   {
        bar
        =   {
              hmm                       =   [ { a = 1; } ];
              mew                       =   [ 1 2 ];
              miau                      =   foo: true;
              ohh                       =   { a = true; b = { c = true; }; };
            };
        success                         =   true && true;
      };
}
