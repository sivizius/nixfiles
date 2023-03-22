{ chemistry, ... }:
let
  inherit(chemistry) compound;
in
{
  absorptionCoefficient = {
    section = "Variables";
    text = {
      deu = "Absorptions\\-koeffizient";
    };
    description = {
      deu = ''
        von \acrshort{latin} \textit{extinctio} \Q{Auslöschung},
        auch \Q{Dämpfungs\-konstante} oder \Q{linearer Schwächungs\-koeffizient},
        in \Newunit{metre}{-1},
        Maß für die Verringerung der Intensität elektro\-magnetischer Strahlung beim Durchgang durch ein Medium
      '';
    };
    data = {
      kind = "Math";
      short = "\\alpha";
    };
    sortedBy = "α";
  };
  absorptionEdge = {
    section = "Variables";
    text = {
      deu = "Absorptions\\-kante";
    };
    description = {
      deu = ''
        in \Newunit{nanometre}{}
      '';
    };
    data = {
      kind = "Math";
      short = "\\lambda_{min}";
    };
    sortedBy = "λmin";
  };
  absorptionMaximum = {
    section = "Variables";
    text = {
      deu = "Wellen\\-länge des Absorptions\\-maximums";
    };
    description = {
      deu = ''
        in \Newunit{nanometre}{}
      '';
    };
    data = {
      kind = "Math";
      short = "\\lambda_{max}";
    };
    sortedBy = "λmax";
  };
  activationEnergy = {
    section = "Variables";
    text = {
      deu = "Aktivierungs\\-energie";
    };
    description = {
      deu = ''
        in \Newunit{joule}{}
      '';
    };
    data = {
      kind = "Math";
      short = "E_A";
    };
  };
  bandGap = {
    section = "Variables";
    text = {
      deu = "Band\\-lücke";
    };
    description = {
      deu = ''
        \acrshort{english} auch \Q{Band-Gap}, in \Newunit{joule}{},
        energetische Differenz zwischen Valenz- und Leitungs\-band eines Fest\-körpers
      '';
    };
    data = {
      kind = "Math";
      short = "E_g";
    };
  };
  boilingTemperature = {
    section = "Variables";
    text = {
      deu = "Siede\\-punkt";
    };
    description = {
      deu = ''
        Koch\-punkt, genauer: Siede\-bereich; Temperatur,
        ab der eine Flüssigkeit in den gas\-förmigen Aggregat\-zustand übergeht,
        in ''${\Newunit{celsius}{}}$
      '';
    };
    data = {
      kind = "Default";
      short = "Kp.";
    };
  };
  carnotFactor = {
    section = "Variables";
    text = {
      deu = "\\person{Carnot}-Wirkungs\\-grad";
    };
    description = {
      deu = ''
        Maximaler Wirkungs\-grad bei der Umwandlung von thermischer in mechanische Energie,
        ''${\acrshort{carnotFactor} = 1-\frac{T_k}{T_w}}$,
        benannt nach dem französischen Physiker \person[carnot]{Nicolas Léonard Sadi Carnot}
      '';
    };
    data = {
      kind = "Math";
      short = "\\eta_C";
    };
    sortedBy = "ηC";
  };
  catalytLoading = {
    section = "Variables";
    text = {
      deu = "Katalysator\\-beladung";
    };
    description = {
      deu = ''
        Molares Verhätlsnis von Katalysator zu Substrat
      '';
    };
    data = {
      kind = "Math";
      short = "R";
    };
  };
  coefficientOfDetermination = {
    section = "Variables";
    text = {
      deu = "Determinations\\-koeffizient";
    };
    description = {
      deu = ''
        auch \textit{Bestimmtheits\-maß}, statistische Kenn\-zahl der Anpassungs\-güte einer Regression:
          je näher dieser Wert an Eins liegt, desto besser passt ein gewähltes Modell zu den Mess\-werten
      '';
    };
    data = {
      kind = "Math";
      short = "R^2";
    };
    sortedBy = "R²";
  };
  conversion = {
    section = "Variables";
    text = {
      deu = "Umsatz";
    };
    description = {
      deu = ''
        in \Newunit{percent}{}
      '';
    };
    data = {
      kind = "Math";
      short = "U";
    };
  };
  couplingConstant = {
    section = "Variables";
    text = {
      deu = "Kopplungs\\-konstante";
    };
    description = {
      deu = ''
        in \Newunit{hertz}{}
      '';
    };
    data = {
      kind = "Math";
      short = "J";
    };
  };
  currentDensity = {
    section = "Variables";
    text = {
      deu = "Elektrische Strom\\-dichte";
    };
    description = {
      deu = ''
        in \Newunit{microampere}{}\Unit{centimetre}{-2}
      '';
    };
    data = {
      kind = "Math";
      short = "\\vec{J}";
    };
    sortedBy = "J";
  };
  dcCurrent = {
    section = "Variables";
    text = {
      deu = "Elektrische Gleich\\-strom";
    };
    description = {
      deu = ''
        in \Newunit{ampere}{}, Ladungsfluss in einem Leiter
      '';
    };
    data = {
      kind = "Math";
      short = "I";
    };
  };
  dcVoltage = {
    section = "Variables";
    text = {
      deu = "Elektrische Gleich\\-spannung";
    };
    description = {
      deu = ''
        in \Newunit{volt}{}, Differenz zweier elektrischer Potentiale
      '';
    };
    data = {
      kind = "Math";
      short = "U";
    };
  };
  decompositionTemperature = {
    section = "Variables";
    text = {
      deu = "Zersetzungs\\-punkt";
    };
    description = {
      deu = ''
        Temperatur, oberhalb der sich eine Substanz zu anderen Stoffen zersetzt, in ''${\Newunit{celsius}{}}$
      '';
    };
    data = {
      kind = "Default";
      short = "Zers.";
    };
  };
  degreeOfPolymerisation = {
    section = "Variables";
    text = {
      deu = "Polymerisatios\\-grad";
    };
    description = {
      deu = ''
        Verhältnis aus dem \acrfull{numberMeanMolarMass} und
          der \acrtext[molarMass]{molaren Masse} ($\acrshort{molarMass}_{n}$) der Wiederholungs\-einheit/Monomer
      '';
    };
    data = {
      kind = "Math";
      short = "\\bar{X}_n";
    };
    sortedBy = "Xn";
  };
  diameter = {
    section = "Variables";
    text = {
      deu = "Durchmesser";
      eng = "diameter";
    };
    description = {
      deu = ''
        größtmögliche Abstand zweier Punkte der Kreis\-linie oder der Kugel\-oberflächen\-punkte
      '';
    };
    data = {
      kind = "Default";
      short = "ø";
    };
    sortedBy = "";
  };
  diastereomericExcess = {
    section = "Variables";
    text = {
      deu = "Diastereomeren\\-überschuss";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Diastereomeric Excess}, in \Newunit{percent}{}
      '';
    };
    data = {
      kind = "Math";
      short = "de";
    };
  };
  electricConductivity = {
    section = "Variables";
    text = {
      deu = "Elektrische Leitfähigkeit";
    };
    description = {
      deu = ''
        in \Newunit{siemens}{}\Unit{metre}{-1}
      '';
    };
    data = {
      kind = "Math";
      short = "\\sigma";
    };
    sortedBy = "σ";
  };
  electrodePotential = {
    section = "Variables";
    text = {
      deu = "Elektroden\\-potential";
    };
    description = {
      deu = ''
        in \Newunit{volt}{}
      '';
    };
    data = {
      kind = "Math";
      short = "E";
    };
  };
  enantiomericExcess = {
    section = "Variables";
    text = {
      deu = "Enantiomeren\\-überschuss";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Enantiomeric Excess}, in \Newunit{percent}{}
      '';
    };
    data = {
      kind = "Math";
      short = "ee";
    };
  };
  extinctionCoefficient = {
    section = "Variables";
    text = {
      deu = "Extinktions\\-koeffizient";
    };
    description = {
      deu = ''
        von \acrshort{latin} \textit{extinctio} \Q{Auslöschung}, auch \Q{molarer Absorptionskoeffizient},
          in \Newunit{litre}{}\Unit{mol}{-1}\Unit{centimetre}{-1},
          Verhältnis von Extinktion zum Produkt aus Stoff\-mengen\-konzentration und Schicht\-dicke
      '';
    };
    data = {
      kind = "Math";
      short = "\\varepsilon";
    };
    sortedBy = "ε";
  };
  massMeanMolarMass = {
    section = "Variables";
    text = {
      deu = "Gewichts\\-mittel der molaren Masse";
    };
    description = {
      deu = ''
        in \Newunit{gram}{}\Unit{mol}{-1}
      '';
    };
    data = {
      kind = "Math";
      short = "M_\\omega";
    };
  };
  massToChargeRatio = {
    section = "Variables";
    text = {
      deu = "Masse-zu-Ladungs-Verhältnis";
      eng = "Mass-to-Charge Ratio";
    };
    description = {
      deu = ''
        in \Newunit{kilogram}{}\Unit{coulomb}{-1} oder \Newunit{dalton}{}\Unit{elementaryCharge}{-1},
          Verhältnis der Masse eines Teilchen zu seiner Ladung,
          eine Größe der \acrlong{massSpectrometry}
      '';
    };
    data = {
      kind = "Default";
      short = "\\textit{m/z}";
    };
  };
  meltingTemperature = {
    section = "Variables";
    text = {
      deu = "Schmelz\\-punkt";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Fusion Point}, genauer: Schmelz\-bereich; Temperatur,
          ab der ein Fest\-stoff in den flüssigen Aggregat\-zustand übergeht
      '';
    };
    data = {
      kind = "Default";
      short = "Fp.";
    };
  };
  molarMass = {
    section = "Variables";
    text = {
      deu = "Molare Masse";
    };
    description = {
      deu = ''
        Masse eines \acrlong{mol}s einer Substanz
      '';
    };
    data = {
      kind = "Math";
      short = "M";
    };
  };
  nD20 = {
    section = "Variables";
    text = {
      deu = "Brechungs\\-index";
    };
    description = {
      deu = ''
        bei ''${\Physical{20}{}{celsius}{}}$ und
          einer Wellen\-länge von ''${\Physical{589}{}{nanometre}{}}$ (Natrium-D-Linie
      '';
    };
    data = {
      kind = "Math";
      short = "n^{20}_D";
    };
    sortedBy = "n20D";
  };
  numberMeanMolarMass = {
    section = "Variables";
    text = {
      deu = "Zahlen\\-mittel der molaren Masse";
    };
    description = {
      deu = ''
        in \Newunit{gram}{}\Unit{mol}{-1}
      '';
    };
    data = {
      kind = "Math";
      short = "M_n";
    };
  };
  pH = {
    section = "Variables";
    text = {
      deu = "Potential des ${compound.format "Wasserstoffes"}";
    };
    description = {
      deu = ''
        von \acrshort{latin} \Q{potentia hydrogenii},
          negativer dekadischer Logarithmus der Konzentration von ${compound.format "Oxonium||ionen"} (\ch{H+.'n'}\,Solvent)
      '';
    };
    data = {
      kind = "Default";
      short = "pH";
    };
  };
  polyDispersity = {
    section = "Variables";
    text = {
      deu = "Poly\\-dispersität";
    };
    description = {
      deu = ''
        von \acrshort{latin} \textit{dispergere} \Q{zerstreuen},
          Verhältnis von \acrlong{massMeanMolarMass} zum \acrlong{numberMeanMolarMass}
      '';
    };
    data = {
      kind = "Default";
      short = "Đ";
    };
    sortedBy = "D";
  };
  ratioOfFronts = {
    section = "Variables";
    text = {
      deu = "Retentions\\-faktor";
    };
    description = {
      deu = ''
        Verhältnis von Lauf\-strecke des Analyten zur Lauf\-strecke des Lauf\-mittels
      '';
    };
    data = {
      kind = "Math";
      short = "R_f";
    };
    sortedBy = "Rf";
  };
  reactionRate = {
    section = "Variables";
    text = {
      deu = "Reaktions\\-geschwindigkeit";
    };
    description = {
      deu = ''
        ''${\nu = -\frac{d[Edukt]}{dt}}$
      '';
    };
    data = {
      kind = "Math";
      short = "\\nu";
    };
    sortedBy = "ν";
  };
  specialViscosity = {
    section = "Variables";
    text = {
      deu = "Spezifische Viskosität";
    };
    description = {
    };
    data = {
      kind = "Math";
      short = "\\eta_{sp}";
    };
    sortedBy = "η";
  };
  sublimationTemperature = {
    section = "Variables";
    text = {
      deu = "Sublimations\\-punkt";
    };
    description = {
      deu = ''
        genauer: Sublimations\-bereich; Temperatur,
          ab der eine Fest\-stoff in den gas\-förmigen Aggregat\-zustand übergeht
      '';
    };
    data = {
      kind = "Default";
      short = "Sp.";
    };
  };
  tempDegree = {
    section = "Variables";
    text = {
      deu = "Temperatur";
    };
    description = {
      deu = ''
        in \Newunit{celsius}{}, veraltet: empirische Temperatur
      '';
    };
    data = {
      kind = "Math";
      short = "\\vartheta";
    };
    sortedBy = "ϑ";
  };
  temperature = {
    section = "Variables";
    text = {
      deu = "Absolute Temperatur";
    };
    description = {
      deu = ''
        in \Newunit{kelvin}{}
      '';
    };
    data = {
      kind = "Math";
      short = "T";
    };
  };
  time = {
    section = "Variables";
    text = {
      deu = "Zeit";
    };
    description = {
      deu = ''
        in \Newunit{second}{}, \Newunit{minute}{}, \Newunit{hour}{}, \acrshort{etc}, von \acrshort{english} \Q{Time}
      '';
    };
    data = {
      kind = "Math";
      short = "t";
    };
  };
  turnoverFrequency = {
    section = "Variables";
    text = {
      deu = "Wechsel\\-zahl";
    };
    description = {
      deu = ''
        in \Newunit{second}{-1}, von \acrshort{english} \Q{Turnover Frequency}
      '';
    };
    data = {
      kind = "Math";
      short = "TOF";
    };
  };
  turnoverNumber = {
    section = "Variables";
    text = {
      deu = "katalytische Produktivität";
    };
    description = {
      deu = ''
        dimensionslos, von \acrshort{english} \Q{Turnover Number}
      '';
    };
    data = {
      kind = "Math";
      short = "TON";
    };
  };
  waveFrequency = {
    section = "Variables";
    text = {
      deu = "Wellen\\-frequenz";
    };
    description = {
      deu = ''
        in \Newunit{hertz}{}, Quotient aus \acrlong{speedOfLight} und \acrlong{waveLength}:
          ''${\nu = \frac{\acrshort{speedOfLight}}{\acrshort{waveLength}}}$
      '';
    };
    data = {
      kind = "Math";
      short = "\\nu";
    };
    sortedBy = "ν";
  };
  waveLength = {
    section = "Variables";
    text = {
      deu = "Wellen\\-länge";
    };
    description = {
      deu = ''
        in \Newunit{nanometre}{-1}, Distanz zweier Punkte gleicher Phase,
          \acrshort{forExample} Wellen\-berg zu Wellen\-berg
      '';
    };
    data = {
      kind = "Math";
      short = "\\lambda";
    };
    sortedBy = "λ";
  };
  waveNumber = {
    section = "Variables";
    text = {
      deu = "Wellen\\-zahl";
    };
    description = {
      deu = ''
        in \Newunit{cm-1}{}, Kehr\-wert der \acrlong{waveLength}:
          ''${\widetilde{\nu} = \acrshort{waveLength}^{-1}}$
      '';
    };
    data = {
      kind = "Math";
      short = "\\widetilde{\\nu}";
    };
    sortedBy = "ν";
  };
}