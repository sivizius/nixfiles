{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  dibenzylideneacetone = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Di|benzyliden||aceton"}";
      };
    };
    description = {
      deu = ''
        \ch{<phenyl>(CH)2CO(CH)2<phenyl>},
          Ligang der Organo\-metall\-chemie
      '';
    };
    data = {
      kind = "Chemical";
      short = "'dba'";
    };
  };
  dppf = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "1,1′-Bis(di:phenyl|phosphino)|ferrocen"}";
      };
    };
    description = {
      deu = ''
        \ch{<ferrocenyl>(P<phenyl>2)2},
          substituiertes ${compound.format "Ferrocen"}, ${compound.format "Di|phosphan"}, Ligang der Organo\-metall\-chemie
      '';
    };
    data = {
      kind = "Chemical";
      short = "'dppf'";
    };
  };
}