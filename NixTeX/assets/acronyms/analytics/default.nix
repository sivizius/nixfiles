{ core, ... } @ libs:
let
  inherit(core) library;
in
{
  attenuatedTotalReflectance = {
    section = "Analytical";
    text = {
      deu = "Abgeschwächte Total\\-reflexion";
      eng = "Attenuated Total Reflectance";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Attenuated Total Reflectance},
          eine Mess\-technik der \acrlong{infrared}\-spektro\-metrie an einer Material\-oberfläche
      '';
    };
    data = {
      kind = "Default";
      short = "ATR";
    };
  };

  energyDispersiveXray = {
    section = "Analytical";
    text = {
      deu = "Energie\\-dispersive Röntgen\\-spektroskopie";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Energy Dispersive X-ray (spectroscopy)}
      '';
    };
    data = {
      kind = "Default";
      short = "EDX";
    };
  };

  electroSprayIonisation = {
    section = "Analytical";
    text = {
      deu = "Elektro\\-spray\\-ionisation";
      end = "Electro\\-spray ionisation";
    };
    description = {
      deu = ''
        Technik zur Erzeugung von Ionen durch Zerstäubung der Analyt\-lösungen in einem elektrischen Feld
      '';
    };
    data = {
      kind = "Default";
      short = "ESI";
    };
  };

  fourierTransformation = {
    section = "Analytical";
    text = {
      deu = "\\person{Fourier}-Trans\\-formation";
    };
    data = {
      kind = "Default";
      short = "FT";
    };
  };

  gasChromatography = {
    section = "Analytical";
    text = {
      deu = "Gas\\-chromato\\-graphie";
    };
    data = {
      kind = "Default";
      short = "GC";
    };
  };

  gpc = {
    section = "Analytical";
    text = {
      deu = "Gel\\-permeations\\-chromato\\-graphie";
    };
    description = {
      deu = ''
        auch \textit{Größen\-ausschluss\-chromato\-graphie}
      '';
    };
    data = {
      kind = "Default";
      short = "GPC";
    };
  };

  highResolutionMassSpectrometry = {
    section = "Analytical";
    text = {
      deu = "Hoch\\-aufgelöste Massen\\-spektro\\-metrie";
      eng = "High-Resolution Mass Spectrometry";
    };
    data = {
      kind = "Default";
      short = "HRMS";
    };
  };

  massSpectrometry = {
    section = "Analytical";
    text = {
      deu = "Massen\\-spektro\\-metrie";
      eng = "Mass Spectrometry";
    };
    data = {
      kind = "Default";
      short = "MS";
    };
  };

  ortep = {
    section = "Analytical";
    text = {
      deu = "Oak Ridge Thermal Ellipsoid Plot Programme";
    };
    description = {
      deu = ''
        Program zur Darstellung von Kristall\-strukturen
      '';
    };
    data = {
      kind = "Default";
      short = "ORTEP";
    };
  };

  pxrd = {
    section = "Analytical";
    text = {
      deu = "Pulver\\-röntgen\\-diffrakto\\-metrie";
    };
    description = {
      deu = ''
        von \acrshort{english} \Q{Powder X-Ray Diffraction}
      '';
    };
    data = {
      kind = "Default";
      short = "PXRD";
    };
  };

  scanningElectronMicroscope = {
    section = "Analytical";
    text = {
      deu = "Raster\\-elektronen\\-mikroskopie";
    };
    data = {
      kind = "Default";
      short = "REM";
    };
  };

  timeOfFlightMS = {
    section = "Analytical";
    text = {
      deu = "Flug\\-zeit\\-massen\\-spektrometrie";
      eng = "Time Of Flight Mass Spetrometry";
    };
    description = {
      deu = ''
        Variante der \acrfull{massSpectrometry},
          bei der das \acrlong{massToChargeRatio} durch Messung der Flug\-zeit der Ionen,
            welche in einem elektrischen Feld beschleunigt worden,
          bestimmt wird
      '';
    };
    data = {
      kind = "Default";
      short = "TOF-MS";
    };
  };
}
//  library.import ./electrochemistry.nix libs
//  library.import ./electromagnetic.nix  libs
//  library.import ./nmr.nix              libs