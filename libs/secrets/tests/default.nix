{ core, ... }:
{ secret, vault, ... }@lib:
let
  inherit (core) set;
in
{
  deepSeqAll = set.mapValues (module: (_: module)) lib;
}
