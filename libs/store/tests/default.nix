{ core, ... }:
{ ... } @ lib:
  let
    inherit(core) expression;
  in
    {
      deepSeqAll
      =   { ... }:
            expression.deepSeq lib lib;
    }
