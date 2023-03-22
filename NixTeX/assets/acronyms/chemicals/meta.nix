{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  metalOrganicFramework = {
    section = "Substances";
    text = {
      deu = "Metall\\-organische Gerüst\\-verbindung";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Metal Organic Framework}
      '';
    };
    data = {
      kind = "Chemical";
      short = "MOF";
    };
  };
  nhc = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "N-hetero||cyclische(s )~Carben(e )"}";
      };
    };
    data = {
      kind = "Chemical";
      short = "NHC";
    };
  };
  silanCouplingAgent = {
    section = "Substances";
    text = {
      deu = "Silan\\-kupplungs\\-mittel";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Silane Coupling Agent}
      '';
    };
    data = {
      kind = "Default";
      short = "SCA";
    };
  };
}