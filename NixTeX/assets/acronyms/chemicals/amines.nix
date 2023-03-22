{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  dipa = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Di|iso|propyl||amin"}";
      };
    };
    description = {
      deu = ''
        sekundäres ${compound.format "Alkyl||amin"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "DIPA";
    };
  };
  dipea = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Di|iso|propyl||ethyl||amin"}";
      };
    };
    description = {
      deu = ''
        tertiäres ${compound.format "Alkyl||amin"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "DIPEA";
    };
  };
  dmf = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "N,N-Di|methyl||formamid"}";
      };
    };
    description = {
      deu = ''
        \ch{(H3C)2NCHO},
          ${compound.format "Di|methyl||amid"} der ${compound.format "Ameisen||säure"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "DMF";
    };
  };
  tbaf = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Tetra|butyl||ammonium||fluorid"}";
      };
    };
    description = {
      deu = ''
        \ch{(H3C(CH2)3)4NF},
          quartäres ${compound.format "Ammonium||halogenid"}, ${compound.format "Fluorid"} von \acrlong{tetraButylAmmonium}
      '';
    };
    data = {
      kind = "Chemical";
      short = "TBAF";
    };
  };
  tetraButylAmmonium = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Tetra|butyl||ammonium"}";
      };
    };
    description = {
      deu = ''
        \ch{(H3C(CH2)3)4N+}, organisches Kation \acrshort{forExample} für das Leit\-salz \ch{<tetraButylAmmonium>PF6} in der \acrlong{cyclicVoltammetry}
      '';
    };
    data = {
      kind = "Chemical";
      short = "TBA";
    };
  };
  tmeda = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "N,N,N',N'-Tetra|methyl||ethylen||di|amin"}";
      };
    };
    description = {
      deu = ''
        \ch{(H3C)2NC2H4N(CH3)2},
          tertiäres ${compound.format "Alkyl||di|amin"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "TMEDA";
      struct = ''
        \cheme{\chemfig{-[:-30]N(-[::-60])-[::60]-[::-60]-[::60]N(-[::-60])-[::60]}}{}
      '';
    };
  };
  triethylamine = {
    section = "Substances";
    text = {
      deu = "${compound.format "Tri|ethyl||amin"}";
    };
    description = {
      deu = ''
        \ch{N<ethyl>3},
          tertiäres ${compound.format "Alkyl||amin"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "N<ethyl>3";
    };
  };
}