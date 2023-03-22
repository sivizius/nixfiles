{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  polyE = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Poly||ethylen"}";
      };
    };
    description = {
      deu = ''
        ein aus ${compound.format "Ethen"} durch Ketten\-polymerisation
          hergestellter thermo\-plastischer Kunst\-stoff
      '';
    };
    data = {
      kind = "Chemical";
      short = "PE";
    };
  };
  polyET = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Poly||ethylen||terephthalat"}";
      };
    };
    description = {
      deu = ''
        ein aus ${compound.format "Terephthal||säure"} und ${compound.format "Ethylen||glycol"}
          durch Polykondensations hergestellter thermo\-plastischer Kunst\-stoff
      '';
    };
    data = {
      kind = "Chemical";
      short = "PET";
    };
  };
  polyMMA = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Poly||methyl||methacrylat"}";
      };
    };
    data = {
      kind = "Chemical";
      short = "PMMA";
    };
  };
  polyP = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Poly||propylen"}";
      };
    };
    data = {
      kind = "Chemical";
      short = "PP";
    };
  };
  polyPy = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Poly||pyrrol"}";
      };
    };
    description = {
      deu = ''
        ein leitfähiges Polymer mit ${compound.format "Pyrrol"} als Wiederholungs\-einheit
      '';
    };
    data = {
      kind = "Chemical";
      short = "PPy";
    };
  };
  polyS = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Poly||styren"}";
      };
    };
    description = {
      deu = ''
        auch \textit{${compound.format "Poly||styrol"}} und \textit{Styropor},
          systematisch nach \acrshort{iupac}: \textit{${compound.format "Poly(1-phenyl||ethylen)"}},
          ein aus ${compound.format "Styren"} (nach \acrshort{iupac}: \textit{${compound.format "Ethenyl||benzen"}})
          durch Ketten\-polymerisation hergestellter thermo\-plastischer Kunst\-stoff
      '';
    };
    data = {
      kind = "Chemical";
      short = "PS";
    };
  };
  polyT = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Poly||thiophen"}";
      };
    };
    description = {
      deu = ''
        ein leitfähiges Polymer mit \acrlong{thiophene} als Wiederholungs\-einheit
      '';
    };
    data = {
      kind = "Chemical";
      short = "PT";
    };
  };
  polyTFE = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Poly||tetra|fluor||ethylen"}";
      };
    };
    description = {
      deu = ''
        Trivialname: \textit{Teflon},
          ein aus ${compound.format "Tetra||fluor||ethen"} durch Ketten\-polymerisation
            hergestellter thermo\-plastischer Kunst\-stoff
      '';
    };
    data = {
      kind = "Chemical";
      short = "PTFE";
    };
  };
  polyVA = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Poly||vinyl||alkohol"}";
      };
    };
    data = {
      kind = "Chemical";
      short = "PVA";
    };
  };
  polyVAC = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Poly||vinyl||acetat"}";
      };
    };
    data = {
      kind = "Chemical";
      short = "PVAc";
    };
  };
  polyVC = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Poly||vinyl||chlorid"}";
      };
    };
    description = {
      deu = ''
        ein aus ${compound.format "Vinyl||chlorid"}
          (nach \acrshort{iupac}: \textit{${compound.format "Chlor||ethen"}})
          durch Ketten\-polymerisation hergestellter thermo\-plastischer Kunst\-stoff
      '';
    };
    data = {
      kind = "Chemical";
      short = "PVC";
    };
  };
}