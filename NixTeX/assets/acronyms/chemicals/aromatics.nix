{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  "benzo[12b:45b']dithiophene" = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Benzo§[1,2-b:4,5-b']§di|thiophen"}";
      };
    };
    description = {
      deu = ''
        ein tricyclischer Hetero\-aromat
      '';
    };
    data = {
      kind = "Chemical";
      short = "BDT";
      struct = ''
        \cheme{\chemfig{*5(-S-(*5(-S-=-=))=-=)}}{}
      '';
    };
  };
  "benzo[12b:45c']dithiophenedione" = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Benzo§[1,2-b:4,5-c']§di|thiophen§-4,8-§di|on"}";
      };
    };
    description = {
      deu = ''
        ein tricyclischer Hetero\-aromat
      '';
    };
    data = {
      kind = "Chemical";
      short = "BDD";
      struct = ''
        \cheme{\chemfig{*5(-S-=(*6(-(=O)-(*5(=-S-=))--(=O)-))-=)}}{}
      '';
    };
  };
  benzothiadiazole = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "2,1,3-Benzo||thia||di|azol"}";
      };
    };
    description = {
      deu = ''
        ein bicyclischer Hetero\-aromat
      '';
    };
    data = {
      kind = "Chemical";
      short = "BT";
      struct = ''
        \cheme{\chemfig{*6(-(*5(=N-S-N=))--=-=)}}{}
      '';
    };
  };
  benzotriazole = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Benzo||tri|azol"}";
      };
    };
    description = {
      deu = ''
        ein bicyclischer Hetero\-aromat
      '';
    };
    data = {
      kind = "Chemical";
      short = "BTA";
      struct = ''
        \cheme{\chemfig{*6(-(*5(=N-N-N=))--=-=)}}{}
      '';
    };
  };
  bipy = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Bi|pyrridin"}";
      };
    };
    description = {
      deu = ''
        ein hetero\-aromatisches Biaryl
      '';
    };
    data = {
      kind = "Chemical";
      short = "'bipy'";
      struct = ''
        \cheme{\chemfig{*6(=N-(*6(=N-=-=-))=-=-)}}{}
      '';
    };
  };
  bithiophene = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "2,2'-Bi|thiophen"}";
      };
    };
    description = {
      deu = ''
        ein hetero\-aromatisches Biaryl
      '';
    };
    data = {
      kind = "Chemical";
      short = "T2";
      struct = ''
        \cheme{\chemfig{*5(-S-(*5(-S-=-=))=-=)}}{}
      '';
    };
  };
  carbazole = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "§9H-§Carbazol"}";
      };
    };
    description = {
      deu = ''
        ein tricyclischer Hetero\-aromat
      '';
    };
    data = {
      kind = "Chemical";
      short = "Cbz";
      struct = ''
        \cheme{\chemfig{*6(=-(*5(-(*6(-=-=-=^))--\chembelow{N}{H}-))=-=-)}}{}
      '';
    };
  };
  dihydroindacenodithiophene = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "4,9-Di|hydro-s-indaceno§[1,2-b:5,6-b']§di|thiophen"}";
      };
    };
    description = {
      deu = ''
        ein pentacyclischer Hetero\-aromat
      '';
    };
    data = {
      kind = "Chemical";
      short = "IDT";
      struct = ''
        \cheme{\chemfig{*5(-S-(*5(-(*6(=-(*5(-(-[::-74]R)(-[::-34]R)-(*5(-=-S-=^))--))=-=))--(-[::-74]R)(-[::-34]R)-))=-=)}}{}
      '';
    };
  };
  diketopyrrolopyrrole = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "2,5-Di|hydro||pyrrolo§[3,4-c]§pyrrol§-1,4-§di|on"}";
      };
    };
    description = {
      deu = ''
        ein bicyclischer Hetero\-aromat
      '';
    };
    data = {
      kind = "Chemical";
      short = "DPP";
      struct = ''
        \cheme{\chemfig{*5(-N(-R)-(=O)-(*5(=-N(-R)-(=O)-))-=)}}{}
      '';
    };
  };
  fluorene = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Fluoren"}";
      };
    };
    description = {
      deu = ''
        ein tricyclischer aromatischer ${compound.format "Kohlen||wasserstoff"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "Fl";
      struct = ''
        \cheme{\chemfig{*6(=-(*5(-(*6(-=-=-=^))---))=-=-)}}{}
      '';
    };
  };
  "thieno[32b]thiophene" = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Thieno§[3,2-b]§thiophen"}";
      };
    };
    description = {
      deu = ''
        ein bicyclischer Hetero\-aromat
      '';
    };
    data = {
      kind = "Chemical";
      short = "TT";
      struct = ''
        \cheme{\chemfig{*5(-S-(*5(-=-S-))=-=)}}{}
      '';
    };
  };
  thiophene = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Thiophen"}";
      };
    };
    description = {
      deu = ''
        ein ${compound.format "schwefel||haltiger"} hetero\-aromatischer Fünf\-ring
      '';
    };
    data = {
      kind = "Chemical";
      short = "T";
      struct = ''
        \cheme{\chemfig{*5(-S-=-=)}}{}
      '';
    };
  };
}