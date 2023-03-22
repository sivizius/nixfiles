{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  AcMe = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Aceton"}";
      };
    };
    description = {
      deu = ''
        \ch{H3CCOCH3},
          systematisch nach \acrshort{iupac}: \textit{${compound.format "Propanon"}},
          organisches aprotisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "<acetyl><methyl>";
    };
    sortedBy = "AcMe";
  };
  CDCl3 = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Deuteriertes Chloroform"}";
      };
    };
    description = {
      deu = ''
        \ch{CDCl3}, Chloroform-d\textsubscript{1},
          systematisch nach \acrshort{iupac}: \textit{${compound.format "deuteriertes Tri|chlor||methan"}},
          organisches, aprotisch-polares Lösungs\-mittel für die \acrshort{nuclearMagneticResonance}-Spektro\-metrie
      '';
    };
    data = {
      kind = "Chemical";
      short = "CDCl3";
    };
  };
  "1,2-dimethoxyethane" = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Ethylen||glycol||di|methyl||ether"}";
      };
    };
    description = {
      deu = ''
        \ch{<methyl>O(CH2)2O<methyl>},
        Trivial\-name: \textit{${compound.format "1,2-Di|methoxy||ethan"}},
        organisches aprotisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "1,2-DME";
    };
  };
  Et2O = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Di|ethyl||ether"}";
      };
    };
    description = {
      deu = ''
        \ch{(H3CCH2)2O}, organisches aprotisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "<ethyl>2O";
      struct = ''
        \cheme{\chemfig{H_3C-[:30]-[:-30]O-[:30]-[:-30]CH_3}}{}
      '';
    };
  };
  EtOAc = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Essig||säure||ethyl||ester"}";
      };
    };
    description = {
      deu = ''
        \ch{H3COOCH2CH3},
          nach \acrshort{iupac}: \textit{${compound.format "Ethyl||acetat"}} \acrshort{beziehungsweise}
          systematisch: \textit{${compound.format "Ethyl||ethanoat"}},
          organisches aprotisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "<ethyl>O<acetyl>";
    };
    sortedBy = "EtOAc";
  };
  EtOH = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Ethanol"}";
      };
    };
    description = {
      deu = ''
        \ch{H3CCH2OH}, organisches protisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "<ethyl>OH";
      struct = ''
        \cheme{\chemfig{H_3C-[:30]-[:-30]OH}}{}
      '';
    };
  };
  MeOH = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Methanol"}";
      };
    };
    description = {
      deu = ''
        \ch{H3COH}, organisches protisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "<methyl>OH";
    };
  };
  dichloromethane = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Di|chlor||methan"}";
      };
    };
    description = {
      deu = ''
        \ch{CH2Cl2},
          Trivial\-name: \textit{${compound.format "Methylen||chlorid"}},
          organisches aprotisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "DCM";
    };
  };
  dmf = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Di|methyl||formamid"}";
      };
    };
    description = {
      deu = ''
        \ch{(H3C)2NCHO}, organisches aprotisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "DMF";
    };
  };
  dmso = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Di|methyl||sulfoxid"}";
      };
    };
    description = {
      deu = ''
        \ch{(H3C)2SO}, organisches aprotisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "DMSO";
    };
  };
  isoPropylOH = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Iso|propyl||alkohol"}";
      };
    };
    description = {
      deu = ''
        \ch{H3C(CHOH)CH3},
          systematisch nach \acrshort{iupac}: \textit{${compound.format "Propan-2-ol"}},
          organisches protisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "<isoPropyl>OH";
      struct = ''
        \cheme{\chemfig{H_3C-[:30](-[:30]OH)-[:-30]CH_3}}{}
      '';
    };
  };
  orthoDichloroBenzene = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "1,2-Di|chlor||benzen"}";
      };
    };
    description = {
      deu = ''
        ${compound.format "o-Di|chlor||benzol"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "ODCB";
    };
  };
  petrolether = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Petrol||ether"}";
      };
    };
    description = {
      deu = ''
        Gemisch verschieder gesättigter ${compound.format "Kohlen||wasserstoff|e"} mit niedrigem Siedepunkt,
          \acrshort{forExample} ${compound.format "Hexan|e"} und ${compound.format "Petan|e"},
          kein Ether (\ch{ROR}) im chemischen Sinne
      '';
    };
    data = {
      kind = "Chemical";
      short = "PE";
    };
  };
  tetrahydrofuran = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Tetra|hydro||furan"}";
      };
    };
    description = {
      deu = ''
        \ch{C4H8O}, organisches aprotisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "THF";
      struct = ''
        \cheme{\chemfig{*5(--O---)}}{}
      '';
    };
  };
  trichlormethane = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Chloroform"}";
      };
    };
    description = {
      deu = ''
        \ch{CHCl3},
          systematisch nach \acrshort{iupac}: \textit{${compound.format "Tri|chlor||methan"}},
          organisches aprotisch-polares Lösungs\-mittel
      '';
    };
    data = {
      kind = "Chemical";
      short = "CHCl3";
    };
  };
}