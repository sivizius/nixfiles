{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  glycine = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Glycin"}";
      };
    };
    description = {
      deu = ''
        eine polare alkylische proteinogene Amino\-säure
      '';
    };
    data = {
      kind = "Chemical";
      short = "Gly";
    };
  };
  phenylalanine = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Phenyl||alanin"}";
      };
    };
    description = {
      deu = ''
        eine unpolare aromatische proteinogene Amino\-säure
      '';
    };
    data = {
      kind = "Chemical";
      short = "Phe";
    };
  };
  valine = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Valin"}";
      };
    };
    description = {
      deu = ''
        eine unpolare alkylische proteinogene Amino\-säure
      '';
    };
    data = {
      kind = "Chemical";
      short = "Val";
    };
  };
}