{ core, chemistry, ... } @ libs:
  let
    inherit(core)       library;
    inherit(chemistry)  compound;
  in
  {
    aibn = {
      section = "Substances";
      text = {
        deu = {
          tex = "${compound.format "Azo||bis|iso|butyro||nitril"}";
        };
      };
      data = {
        kind = "Chemical";
        short = "AIBN";
      };
    };
    alox = {
      section = "Substances";
      text = {
        deu = {
          tex = "${compound.format "Aluminium(III)-oxid"}";
        };
      };
      description = {
        deu = ''
          als stationäre Phase der Säulen\-chromato\-graphie
        '';
      };
      data = {
        kind = "Chemical";
        short = "ALOX";
      };
    };
    bop = {
      section = "Substances";
      text = {
        deu = {
          tex = "${compound.format "Benzo||tri|azol-1-yl||oxy||tris(di|methyl||amino)phosphonium||hexa|fluorido||phosphat"}";
        };
      };
      data = {
        kind = "Chemical";
        short = "BOP";
      };
    };
    dbdmh = {
      section = "Substances";
      text = {
        deu = {
          tex = "${compound.format "1,3-Di|brom-5,5-di|methyl||hydantoin"}";
        };
      };
      description = {
        deu = ''
          eine ${compound.format "Brom"}ierungs\-reagenz
        '';
      };
      data = {
        kind = "Chemical";
        short = "DBDMH";
      };
    };
    dbpo = {
      section = "Substances";
      text = {
        deu = {
          tex = "${compound.format "Di|benzoyl||per|oxid"}";
        };
      };
      data = {
        kind = "Chemical";
        short = "DBPO";
      };
    };
    dead = {
      section = "Substances";
      text = {
        deu = {
          tex = "${compound.format "Azo||di|carbonsäure||di|ethyl||ester"}";
        };
      };
      data = {
        kind = "Chemical";
        short = "DEAD";
      };
    };
    diad = {
      section = "Substances";
      text = {
        deu = {
          tex = "${compound.format "Azo||di|carbonsäure||di|iso|propyl||ester"}";
        };
      };
      data = {
        kind = "Chemical";
        short = "DIAD";
      };
    };
    naphthalenedianhydride = {
      section = "Substances";
      text = {
        deu = {
          tex = "${compound.format "Naphthalen§-1,4,5,8-tetra|carboxyl§||di|anhydrid"}";
        };
      };
      data = {
        kind = "Chemical";
        short = "NDA";
        struct = ''
          \cheme{\chemfig{*6(-(*6(-(=O)-O-(=O)-))=(*6(-=-=(*6(-(=O)-O-(=O)-))-))-=-=)}}{}
        '';
      };
    };
    phb = {
      section = "Substances";
      text = {
        deu = {
          tex = "${compound.format "4-Hydroxy||benzyl||alkohol"}";
        };
      };
      data = {
        kind = "Chemical";
        short = "PHB";
      };
    };
  }
  //  library.import ./acids.nix        libs
  //  library.import ./amines.nix       libs
  //  library.import ./aminoacids.nix   libs
  //  library.import ./aromatics.nix    libs
  //  library.import ./bases.nix        libs
  //  library.import ./groups.nix       libs
  //  library.import ./ligands.nix      libs
  //  library.import ./meta.nix         libs
  //  library.import ./nucleicacids.nix libs
  //  library.import ./polymers.nix     libs
  //  library.import ./silanes.nix      libs
  //  library.import ./solvents.nix     libs
