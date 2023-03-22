{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  LiAlH4 = {
    section = "Substances";
    text = {
      deu = "${compound.format "Lithium||aluminium||hydrid"}";
    };
    data = {
      kind = "Chemical";
      short = "LiAlH4";
      struct = ''
        \cheme{\chemfig{H-Al^\text{\ominus}(-[::-120]H)(-[::120]H)-[::0]H-[::0,,,,draw=none]Li^\text{\oplus}}}{}
      '';
    };
  };
  NaOH = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Natrium||hydroxid"}";
      };
    };
    data = {
      kind = "Chemical";
      short = "NaOH";
    };
  };
  lda = {
    section = "Substances";
    text = {
      deu = "${compound.format "Lithium||di|iso|propyl||amid"}";
    };
    data = {
      kind = "Chemical";
      short = "LDA";
    };
  };
  nBuLi = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "n-Butyl||lithium"}";
      };
    };
    description = {
      deu = ''
        \ch{H3C(CH2)3Li},
          eine ${compound.format "Organo|lithium||verbindung"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "^nBuLi";
      struct = ''
        \cheme{\chemfig{H_3C-[:30]-[:-30]-[:30]-[:-30]Li}}{}
      '';
    };
  };
  tBuLi = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "tert-Butyl||lithium"}";
      };
    };
    description = {
      deu = ''
        \ch{(H3C)3CLi},
          eine ${compound.format "Organo|lithium||verbindung"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "^tBuLi";
      struct = ''
        \cheme{\chemfig{H_3C-C(-[::-120]H_3C)(-[::120]H_3C)-[::0]Li}}{}
      '';
    };
  };
  tBuOK = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Kalium-tert-butanolat"}";
      };
    };
    description = {
      deu = ''
        \ch{H3C(CH2)3OK},
          ein ${compound.format "Kalium||alkoholat"}
      '';
    };
    data = {
      kind = "Chemical";
      short = "^tBuOK";
      struct = ''
        \cheme{\chemfig{H_3C-C(-[::-120]H_3C)(-[::120]H_3C)-O^\text{\ominus}-[::0,,,,draw=none]K^\text{\oplus}}}{}
      '';
    };
  };
}