{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  dibromoIsocyanuricAcid = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Di|brom||iso|cyanur||säure"}";
      };
    };
    description = {
      deu = ''
        eine ${compound.format "Brom"}ierungs\-reagenz
      '';
    };
    data = {
      kind = "Chemical";
      short = "DBI";
    };
  };
  tfa = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Tri|fluor||essigsäure"}";
      };
    };
    data = {
      kind = "Chemical";
      short = "TFA";
    };
  };
  trimesic = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Tri|mesin||säure"}";
      };
    };
    description = {
      deu = ''
        ${compound.format "1,3,5-Benzen||tri|carbonsäure"} sowie deren Salze, Ester, \acrshort{etc}
      '';
    };
    data = {
      kind = "Chemical";
      short = "'btc'";
      struct = ''
        \cheme{\chemfig{R-[:30]CH_3}}{}
      '';
    };
  };
}