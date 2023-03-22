{ core, ... }:
{ ... } @ lib:
  let
    inherit(core) set;
  in
  {
    deepSeqAll
    =   set.mapValues
          (
            module:
              ({ ... }: module)
          )
          lib;
  }