{ core, chemistry, glossaries, ... } @ libs:
  let
    inherit(core)       library;
    inherit(chemistry)  compound;
    inherit(glossaries) acronyms;
    inherit(acronyms)   Miscellaneous;
  in
  {
    adhd = Miscellaneous {
      description = {
        deu = ''
          Verhaltens- und emotionalen Störungen mit Beginn in der Kindheit und Jugend,
            welche sich durch Probleme mit Aufmerksamkeit, Impulsivität, Selbstregulation und Motivation äußert.
        '';
        eng = "";
      };
      long = {
        deu = "Aufmerksamkeits\\-defizit-/Hyper\\-aktivitäts\\-störung";
      };
      short = {
        deu = "ADHS";
        eng = "ADHD";
      };
    };
    chemicalVaporDeposition = {
      section = "Miscellaneous";
      text = {
        deu = "Chemische Gas\\-phasen\\-abscheidung";
      };
      description = {
        deu = ''
          von \acrshort{english} \Q{Chemical Vapor Deposition},
          Beschichtungs\-verfahren,
            bei denen Material aus der Gas\-phase auf eine Oberfläche durch eine chemische Reaktion aufgetragen wird
        '';
      };
      data = {
        kind = "Default";
        short = "CVD";
      };
    };
    concentrated = {
      section = "Miscellaneous";
      text = {
        deu = "konzentriert";
      };
      description = {
        deu = ''
          Unverdünnte Lösung einer Substanz, \acrshort{forExample} Säure
        '';
      };
      data = {
        kind = "Default";
        short = "konz.";
      };
    };
    diluted = {
      section = "Miscellaneous";
      text = {
        deu = "verdünnt";
      };
      description = {
        deu = ''
          Nicht-\acrlong{concentrated}e Lösung einer Substanz, \acrshort{forExample} Base
        '';
      };
      data = {
        kind = "Default";
        short = "verd.";
      };
    };
    quantitative = {
      section = "Miscellaneous";
      text = {
        deu = "quantitativ";
      };
      description = {
        deu = ''
          Vollständiger oder nahezu vollständiger Umsatz
        '';
      };
      data = {
        kind = "Default";
        short = "quant.";
      };
    };
    saturated = {
      section = "Miscellaneous";
      text = {
        deu = "gesättigt";
      };
      description = {
        deu = ''
          Maximal unverdünnte Lösung einer Substanz, \acrshort{forExample} Sole
        '';
      };
      data = {
        kind = "Default";
        short = "ges.";
      };
    };
    selfAssembledMonolayer = {
      section = "Miscellaneous";
      text = {
        deu = "Selbst\\-organisierende Mono\\-schicht";
        eng = "Self-Assembled Mono\\-layer";
      };
      description = {
        deu = ''
        '';
      };
      data = {
        kind = "Default";
        short = "SAM";
      };
    };
    quaternary = {
      section = "Miscellaneous";
      text = {
        deu = "Quartär";
      };
      description = {
        deu = ''
          Atom mit vier gebundenen Resten, welche kein ${compound.format "Wasserstoff"} sind,
            \acrshort{forExample} \ch{CR4} und \ch{N+R4}
        '';
      };
      data = {
        kind = "Default";
        short = "quart.";
      };
    };
  }
  //  library.import ./analytics        libs
  //  library.import ./constants.nix    libs
  //  library.import ./chemicals        libs
  //  library.import ./electronics.nix  libs
  //  library.import ./general.nix      libs
  //  library.import ./german.nix       libs
  //  library.import ./physicals.nix    libs
  //  library.import ./prefixes.nix     libs
  //  library.import ./quantum.nix      libs
  //  library.import ./standards.nix    libs
  //  library.import ./units.nix        libs
