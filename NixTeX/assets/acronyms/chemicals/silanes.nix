{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  odes = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "n-Octadecyl||tri|ethoxy||silan"}";
      };
    };
    data = {
      kind = "Chemical";
      short = "ODES";
      struct = ''
        \cheme{\chemfig{Si(-[:-120]O-[:175]-[:-120]H_{3}C)(-[:150]O-[:85]-[:150]H_{3}C)(-[:60]O-[:-5]-[:60]CH_3)(-[:-30]-[:30]-[:-30]-[:30]-[:-30]-[:30]-[:-30]-[:30]-[:-30]-[:30]-[:-30]-[:30]-[:-30]-[:30]-[:-30]-[:30]-[:-30]-[:30]CH_{3})}}{}
      '';
    };
  };
  pfotes = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "1H,1H,2H,2H-Per|fluor||octyl||tri|ethoxy||silan"}";
      };
    };
    data = {
      kind = "Chemical";
      short = "PFOTES";
      struct = ''
        \cheme{\chemfig{Si(-[:-120]O-[:185]-[:-120]H_{3}C)(-[:150]O-[:95]-[:150]H_{3}C)(-[:60]O-[:5]-[:60]CH_3)(-[:-30]-[:30]-[:-30](-[:-120]F)(-[:-60]F)-[:30](-[:120]F)(-[:60]F)-[:-30](-[:-120]F)(-[:-60]F)-[:30](-[:120]F)(-[:60]F)-[:-30](-[:-120]F)(-[:-60]F)-[:30](-[:30]F)(-[:-30]F)(-[:90]F))}}{}
      '';
    };
  };
  tmscl = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "Chlor||tri|methyl||silan"}";
      };
    };
    data = {
      kind = "Chemical";
      short = "TMSCl";
      struct = ''
        \cheme{\chemfig{H_3C-Si(-[::-120]H_3C)(-[::120]H_3C)-[::0]Cl}}{}
      '';
    };
  };
  tpm = {
    section = "Substances";
    text = {
      deu = {
        tex = "${compound.format "3-(Tri|methoxy||silyl)propyl||methacrylat"}";
      };
    };
    data = {
      kind = "Chemical";
      short = "TPM";
      struct = ''
        \cheme{\chemfig{H_3CO-Si(-[:90]OCH_3)(-[:-90]OCH_3)(-[:0]-[:-30]-[:30]-[:-30]O-[:30](=[:90]O)-[:-30](-[:-90]CH_3)=[:30]CH_2)}}{}
      '';
    };
  };
}