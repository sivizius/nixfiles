{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  "2-octyldodecyl" = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "2-Octyl||dodecyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        eine Alkyl\-gruppe
      '';
    };
    data = {
      kind = "Chemical";
      short = "2-OD";
      struct = ''
        \cheme{\chemfig{-[:90]-[::60]-[::-60]-[::60]-[::-60]-[::60]-[::-60]-[::60]-[::-60]-[::60](-[::60]-[::60]-[::60]-[::-60]-[::60]-[::-60]-[::60]-[::-60])-[::-60]-[::60]R}}{}
      '';
    };
  };
  acetyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Acetyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        \ch{H3CCO},
          eine Acyl\-gruppe
      '';
    };
    data = {
      kind = "Chemical";
      short = "Ac";
      struct = ''
        \cheme{\chemfig{R-[:30](=[::60]O)-[::-60]CH_3}}{}
      '';
    };
  };
  benzyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Benzyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        \ch{-CH2<phenyl>},
          eine Aryl\-gruppe
      '';
    };
    data = {
      kind = "Chemical";
      short = "Bzl";
      struct = ''
        \cheme{\chemfig{R-[:30]-[::-60]*6(-=-=-=)}}{}
      '';
    };
  };
  cyclopentadienyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Cyclo||pentadienyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        vom ${compound.format "Cyclo|penta|di|en"}\-anion (\ch{C5H5-}) abgeleitet,
          eine Aryl\-gruppe
      '';
    };
    data = {
      kind = "Chemical";
      short = "Cp";
      struct = ''
        \cheme{\chemfig{R-[:30]**5(--(-[::126,0.88,,,,draw=none]\text{\ominus})---)}}{}
      '';
    };
  };
  "cyclopentadienyl*" = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Tetra|methyl||cyclo||penta|di|enyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        vom ${compound.format "Penta|methyl||cyclo|penta|di|en"}\-anion (\ch{C5(CH3)5-}) abgeleitet,
          eine Aryl\-gruppe
      '';
    };
    data = {
      kind = "Chemical";
      short = "<cyclopentadienyl>*";
    };
  };
  dipp = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Di|iso|propyl||phenyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        \ch{-<phenyl>(<isoPropyl>)2},
          eine Aryl\-gruppe
      '';
    };
    data = {
      kind = "Chemical";
      short = "'dipp'";
    };
  };
  ethyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Ethyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        \ch{-CH2CH3}, eine Alkyl\-gruppe
      '';
    };
    data = {
      kind = "Chemical";
      short = "Et";
      struct = ''
        \cheme{\chemfig{R-[:30]-[:-30]CH_3}}{}
      '';
    };
  };
  ferrocenyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Ferrocenyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        von ${compound.format "Ferrocen"} (\ch{Fe(h5 -C5H5)2}) abgeleitet, eine Metallocyl\-gruppe
      '';
    };
    data = {
      kind = "Chemical";
      short = "Fc";
      struct = ''
        \cheme{\chemname{\chemfig{-[:-303.51,0.4476]-[::303.51,,,,]-[::303.51,0.4476]<[::251.67,0.7741]@{r5}{}>[::329.64,0.7741]-[::205.18,0.7472,,,draw=none]@{r1}{}-[::80,0.70]Fe-[::0,0.85]\ -[::0,0]@{r2}{}-[::85,0.7472,,,draw=none]<[::128.51,0.4476]@{r3}{}-[::56.49,,,,line width=2pt]@{r4}{}(-[::333.245]R)>[::56.49,0.4476]-[::108.33,0.7741]-[::30.36,0.7741]}}{gestaffelt}\chemname{\chemfig{<[:303.51-\rotate,0.4476]@{r15}{}-[:: 56.49,,,,line width=2pt]@{r16}{}>[:: 56.49,0.4476]-[::108.33,0.7741]-[::30.36,0.7741]-[::159.82,0.7472,,,draw=none]@{r11}{}-[::95,0.70]Fe-[::  0,0.85]\ -[::0,0]@{r12}{}-[::85,0.7472,,,draw=none]<[::128.51,0.4476]@{r13}{}-[:: 56.49,,,,line width=2pt]@{r14}{}(-[::333.245]R)>[:: 56.49,0.4476]-[::108.33,0.7741]-[::30.36,0.7741]}}{ekliptisch}}{\draw[rotate=\rotate] (r1) ellipse (6pt and 2pt);\draw[rotate=\rotate] (r2) ellipse (6pt and 2pt);\draw[-,rotate=\rotate,line width=0.6pt] (r2)\fill[rotate=\rotate] (r3) ellipse (1.3pt and 1pt);\fill[rotate=\rotate] (r4) ellipse (1.3pt and 1pt);\fill[rotate=\rotate] (r5) ellipse (1pt and 1.3pt);\draw[rotate=\rotate] (r11) ellipse (6pt and 2pt);\draw[rotate=\rotate] (r12) ellipse (6pt and 2pt);\draw[-,rotate=\rotate,line width=0.6pt] (r12)\fill[rotate=\rotate] (r13) ellipse (1.3pt and 1pt);\fill[rotate=\rotate] (r14) ellipse (1.3pt and 1pt);\fill[rotate=\rotate] (r15) ellipse (1.3pt and 1pt);\fill[rotate=\rotate] (r16) ellipse (1.3pt and 1pt);}
      '';
    };
  };
  fmoc = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Fluorenyl||methoxy||carbonyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        \ch{???},
          Schutz\-gruppe für \acrshort{forExample} ${compound.format "Amine"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "Fmoc";
    };
  };
  isoPropyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Iso|propyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        \ch{-CH(CH3)2},
        eine Alkyl\-gruppe
      '';
    };
    data = {
      kind = "Chemical";
      short = "^iPr";
      struct = ''
        \cheme{\chemfig{R-[:30](-[:30]CH_3)-[:-30]CH_3}}{}
      '';
    };
  };
  mesyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Mesyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        \ch{-SO2CH3},
          systematisch nach \acrshort{iupac}: ${compound.format "Methan||sulfonyl||gruppe"},
          die Ester und Salze der ${compound.format "Methan||sulfonsäure"} (\ch{MsOH}) werden als ${compound.format "Mesylate"} bezeichnet,
            welche als Abgangs\-gruppe für nukleo\-phile Substitutions\-reaktionen
              durch Reaktion des ${compound.format "Säure\-chlorides"} mit einem ${compound.format "Alkohol"}
                gebildet werden kann
      '';
    };
    data = {
      kind = "Chemical";
      short = "Ms";
      struct = ''
        \cheme{\chemfig{R-[:30]-S(=[::75]O)(=[::45]O)[::-60]CH_3}}{}
      '';
    };
  };
  methyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Methyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        \ch{-CH3}, eine Alkyl\-gruppe
      '';
    };
    data = {
      kind = "Chemical";
      short = "Me";
      struct = ''
        \cheme{\chemfig{R-[:30]CH_3}}{}
      '';
    };
  };
  naphthalenediimide = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Naphthalen§-1,4,5,8-tetra|carboxyl§||di|imid"}";
      };
    };
    description = {
      deu = ''
        von ${compound.format "Naphthalen"} abgeleite, tetrazyklische hetero\-aromatische Gruppe
      '';
    };
    data = {
      kind = "Chemical";
      short = "NDI";
      struct = ''
        \cheme{\chemfig{*6(-(*6(-(=O)-N(-R)-(=O)-))=(*6(-=-=(*6(-(=O)-N(-R)-(=O)-))-))-=-=)}}{}
      '';
    };
  };
  phenyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Phenyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        von ${compound.format "Benzen"} (\ch{C6H6}) abgeleitet,
          einem aromatischen ${compound.format "Kohlen||wasserstoff"}.
      '';
    };
    data = {
      kind = "Chemical";
      short = "Ph";
      struct = ''
        \cheme{\chemfig{R-[:30]*6(-=-=-=)}}{}
      '';
    };
  };
  pyrenyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Pyrenyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        von ${compound.format "Pyren"} (\ch{C16H10}) abgeleitet,
          einem poly\-zyklischen aromatischen ${compound.format "Kohlen||wasserstoff"}.
      '';
    };
    data = {
      kind = "Chemical";
      short = "Py";
    };
  };
  tosyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Tosyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        \ch{-SO2<phenyl><methyl>},
          systematisch nach \acrshort{iupac}: ${compound.format "p-Toluen||sulfonyl||gruppe"},
          die Ester und Salze der ${compound.format "p-Toluen||sulfonsäure"} (\ch{TsOH}) werden als ${compound.format "Tosylate"} bezeichnet,
            welche als Abgangs\-gruppe für nukleo\-phile Substitutions\-reaktionen
              durch Reaktion des ${compound.format "Säure\-chlorides"} mit einem ${compound.format "Alkohol"}
                gebildet werden kann
      '';
    };
    data = {
      kind = "Chemical";
      short = "Ts";
    };
  };
  triflyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Triflyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        \ch{-SO2CF3},
          systematisch nach \acrshort{iupac}: ${compound.format "Tri|fluor||methan||sulfonyl||gruppe"},
          die Ester und Salze der ${compound.format "Tri|fluor||methan||sulfonsäure"} (\ch{TfOH}) werden als ${compound.format "Triflate"} bezeichnet,
            welche als Abgangs\-gruppe für nukleo\-phile Substitutions\-reaktionen
              durch Reaktion des ${compound.format "Säure\-chlorides"} mit einem ${compound.format "Alkohol"}
                gebildet werden kann
      '';
    };
    data = {
      kind = "Chemical";
      short = "Tf";
    };
  };
  trimethylsilyl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Tri|methyl||silyl||gruppe"}";
      };
    };
    description = {
      deu = ''
        \ch{-Si(CH3)3}
      '';
    };
    data = {
      kind = "Chemical";
      short = "TMS";
      struct = ''
        \cheme{\chemfig{R-Si(-[::-120]H_3C)(-[::120]H_3C)-[::0]CH_3}}{}
      '';
    };
  };
}