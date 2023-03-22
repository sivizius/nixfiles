{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  apt = {
    section = "Analytical";
    text = {
      deu = "Attached Proton Test";
      eng = "Attached Proton Test";
    };
    description = {
      deu = ''
        Verfahren der \acrshort{nuclearMagneticResonance}-Spektro\-metrie zur Bestimmung aller direkt benachbarter Protonen
          \acrshort{forExample} an ${compound.format "Kohlenstoff"},
        liefert zusätzlich zu den Signalen von \acrshort{dept} die \acrshort{quaternary} ${compound.format "Kohlenstoffe"}
      '';
    };
    data = {
      kind = "Default";
      short = "APT";
    };
  };
  chemShift = {
    section = "Variables";
    text = {
      deu = "Chemische Verschiebung";
    };
    description = {
      deu = ''
        in \Newunit{ppm}{}, \acrshort{english} \textit{chemical shift},
        Abszissen\-wert in der \acrshort{nuclearMagneticResonance}-Spektro\-metrie,
        Verhältnis der Differenz der Resonanz\-frequenzen der Zentren eines Referenz\-signales und
          eines Mess\-signales zum Zentrum der Resonanz\-frequenz des Referenz\-signales
      '';
    };
    data = {
      kind = "Math";
      short = "\\delta";
    };
    sortedBy = "δ";
  };
  cosy = {
    section = "Analytical";
    text = {
      deu = "Korrelations\\-spektro\\-metrie";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{COrrelation SpectroscopY},
          Verfahren der \acrshort{nuclearMagneticResonance}-Spektro\-metrie zur Bestimmung
            von miteinander koppelnder Kerne, meist ${compound.format "Wasserstoff"}
      '';
    };
    data = {
      kind = "Default";
      short = "COSY";
    };
  };
  dept = {
    section = "Analytical";
    text = {
      deu = "Verzerrungs\\-freie Verbesserung durch Polarisations\\-transfer";
      eng = "Distortionless Enhancement by Polarisation Transfer";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Distortionless Enhancement by Polarisation Transfer},
        Verfahren der \acrshort{nuclearMagneticResonance}-Spektro\-metrie zur Bestimmung direkt benachbarter Protonen
          \acrshort{forExample} an ${compound.format "Kohlenstoff"}
      '';
    };
    data = {
      kind = "Default";
      short = "DEPT";
    };
  };
  hmbc = {
    section = "Analytical";
    text = {
      deu = "Hetero\\-nukleare Mehrfach\\-bindungen\\-korrelation";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Heteronuclear Multi Bond Correlation},
        Verfahren der \acrshort{nuclearMagneticResonance}-Spektro\-metrie
          zur Zuordnung der Signale verschiedener Kerne,
            welche über mehrere Bindungen koppeln,
          \acrshort{forExample} \textsuperscript{1}H-\textsuperscript{13}C-Korrelationen,
        von \acrshort{english} \Q{Hetero\-nuclear Multiple Bond Correlation}
      '';
    };
    data = {
      kind = "Default";
      short = "HMBC";
    };
  };
  hsbc = {
    section = "Analytical";
    text = {
      deu = "Hetero\\-nukleare Einfach\\-bindungen\\-korrelation";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Heteronuclear Single Bond Correlation},
        Verfahren der \acrshort{nuclearMagneticResonance}-Spektro\-metrie
          zur Zuordnung der Signale verschiedener Kerne,
            welche über eine Bindung koppeln,
          \acrshort{forExample} \textsuperscript{1}H-\textsuperscript{13}C-Korrelationen,
        von \acrshort{english} \Q{Hetero\-nuclear Single Bond Correlation}
      '';
    };
    data = {
      kind = "Default";
      short = "HSBC";
    };
  };
  hsqc = {
    section = "Analytical";
    text = {
      deu = "Hetero\\-nukleare Einzel\\-quanten\\-kohärenz";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Heteronuclear Single Quantum Coherence},
        Verfahren der \acrshort{nuclearMagneticResonance}-Spektro\-metrie
          zur Zuordnung der Signale verschiedener Kerne,
            welche über eine Bindung verbunden sind,
          \acrshort{forExample} \textsuperscript{1}H-\textsuperscript{13}C- und
            \textsuperscript{1}H-\textsuperscript{15}N-Korrelationen,
        von \acrshort{english} \Q{Hetero\-nuclear Single Quantum Coherence}
      '';
    };
    data = {
      kind = "Default";
      short = "HSQC";
    };
  };
  noesy = {
    section = "Analytical";
    text = {
      deu = "Kern-Overhauser-Effekt-Spektro\-metrie";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Nuclear Overhauser Effect Spectro\-Metry},
        Verfahren der \acrshort{nuclearMagneticResonance}-Spektro\-metrie zur Bestimmung benachbarter Kerne über den Raum
      '';
    };
    data = {
      kind = "Default";
      short = "NOESY";
    };
  };
  nuclearMagneticResonance = {
    section = "Analytical";
    text = {
      deu = "Kern\\-magnet\\-resonanz";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Nuclear Magnetic Resonance}, auch \Q{Kern\-spin\-resonanz}
      '';
    };
    data = {
      kind = "Default";
      short = "NMR";
    };
  };
}