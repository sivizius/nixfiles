{ ... }:
{
  dinStandard = {
    section = "Standards";
    text = {
      deu = "Deutsche Industrie\\-norm";
    };
    description = {
      deu = ''
        vom Deutschen Institut für Normung erarbeitete freiwillige Industrie\-norm
      '';
    };
    data = {
      kind = "Default";
      short = "DIN";
    };
  };
  icdd = {
    section = "Standards";
    text = {
      deu = "Inter\\-nationales Zentrum für Beugungs\\-daten";
      eng = "Inter\-national Centre for Diffraction Data";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Inter\-national Centre for Diffraction Data}
          \acrshort{beziehungsweise} deren Datenbank für \acrlong{pxrd}\-daten
      '';
    };
    data = {
      kind = "Default";
      short = "ICDD";
    };
  };
  isoStandard = {
    section = "Standards";
    text = {
      deu = "Inter\\-nationale Organisation für Normung";
    };
    description = {
      deu = ''
        Inter\-nationale Vereinigung von Normungs\-organisationen,
          welche international geltende Normen festlegen
      '';
    };
    data = {
      kind = "Default";
      short = "ISO";
    };
  };
  iupac = {
    section = "Standards";
    text = {
      deu = "Inter\\-nationale Union für reine und angewandte Chemie";
      eng = "International Union of Pure and Applied Chemistry";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{International Union of Pure and Applied Chemistry}
      '';
    };
    data = {
      kind = "Default";
      short = "IUPAC";
    };
  };
  siStandard = {
    section = "Standards";
    text = {
      deu = "Inter\\-nationales Einheiten\\-system";
      fre = "Système International d’unités";
    };
    description = {
      deu = ''
        von \acrshort{french} \Q{système international d’unités}
          (\acrshort{dinStandard}\,\acrshort{isoStandard}\,1000),
          das am weitesten verbreitete Einheiten\-system physikalischer Größen
      '';
    };
    data = {
      kind = "Default";
      short = "SI";
    };
  };
}