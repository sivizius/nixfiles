{ ... }:
  let
    # trait -> { ... } -> T -> T
    implementFor
    =   trait:
        { ... } @ methods:
        { __traits__ ? {}, ... } @ struct:
          struct
          //  {
                __traits__
                =   __traits__
                //  ( trait methods );
              };

    # { __traits__: T } -> T
    # where T: { ... } | null
    getTraits                           =   { __traits__ ? null, ... }: __traits__;
  in
  {
    inherit implementFor getTraits;
  }