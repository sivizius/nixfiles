{ chemistry, ... }:
let
  inherit (chemistry) compound;
in
{
  dna = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Des|oxy||ribo||nuklein||säure"}";
      };
    };
    description = {
      deu = ''
        eine aus ${compound.format "Des|oxy||ribo||nukleotiden"} aufgebaute ${compound.format "Nuklein||säure"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "DNA";
    };
  };
  rna = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Ribo||nuklein||säure"}";
      };
    };
    description = {
      deu = ''
        eine aus ${compound.format "Ribo||nukleotiden"} aufgebaute ${compound.format "Nuklein||säure"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "RNA";
    };
  };
}
