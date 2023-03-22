{ glossaries, ... }:
let
  inherit(glossaries.acronyms) Unit Angle;
in
{
  ampere
  =   Unit "A"
      {
        title
        =   {
              deu                       =   "Ampere";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der elektrischen Strom\\-stärke";
                    person
                    =   {
                          about         =   "dem französischen Physiker";
                          name          =   "André-Marie Ampère";
                        };
                    siBasic             =   true;
                  };
            };
      };
  angstroem
  =   Unit "\\AA"
      {
        title
        =   {
              deu                       =   "\\AA ngström";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Länge";
                    person
                    =   {
                          about         =   "dem schwedischen Astronom und Physiker";
                          name          =   "Anders Jonas Ångström";
                        };
                    value               =   { value = { value = 1; exp = -10; }; unit = "metre"; };
                  };
            };
        sortedBy                        =   "a";
      };
  bar
  =   Unit "bar"
      {
        title
        =   {
              deu                       =   "Bar";
            };
        description
        =   {
              deu
              =   {
                    about               =   "des Druckes";
                    foreign
                    =   {
                          language      =   "greek";
                          text          =   "βαρύς";
                          latin         =   "barys";
                          meaning       =   "schwer";
                        };
                    value               =   { value = { value = 1; exp = 5; }; unit = [ "kilogram" "metre-1" "second-1"]; };
                  };
            };
      };
  becquerel
  =   Unit "Bq"
      {
        title
        =   {
              deu                       =   "Becquerel";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Aktivität";
                    person
                    =   {
                          about         =   "dem französischen Physiker und Ingeneur";
                          name          =   "Henri Becquerel";
                        };
                    value               =   { value = 1; unit = "second-1"; };
                  };
            };
      };
  candela
  =   Unit "cd"
      {
        title
        =   {
              deu                       =   "Candela";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Licht\\-stärke";
                    foreign
                    =   {
                          language      =   "latin";
                          text          =   "candela";
                          meaning       =   "Kerze";
                        };
                    siBasic             =   true;
                  };
            };
      };
  celsius
  =   Unit "°C"
      {
        title
        =   {
              deu                       =   "Grad Celsius";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Temperatur";
                    description
                    =   ''
                          ''${\Physical{0}{}{celsius}{} = \Physical{273.15}{}{kelvin}{}}$,
                          ''${\Physical{100}{}{celsius}{} = \Physical{373.15}{}{kelvin}{}}$
                        '';
                    person
                    =   {
                          about         =   "dem schwedischen Astronom, Mathematiker und Physiker";
                          name          =   "Anders Celsius";
                        };
                  };
            };
        sortedBy                        =   "c";
      };
  cm-1
  =   Unit "cm\\textsuperscript{-1}"
      {
        title
        =   {
              deu                       =   "Reziproke \\acrtext[centi]{Centi}\\-\\acrtext[metre]{meter}";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der \\acrlong{waveNumber}";
                    description
                    =   ''
                          insbesondere der \acrshort{infrared}-Spektro\-skopie
                        '';
                    value               =   { value = 100; unit = "metre-1"; };
                  };
            };
        sortedBy                        =   "cm-1";
      };
  coulomb
  =   Unit "C"
      {
        title
        =   {
              deu                       =   "Coulomb";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der elektrischen Ladung";
                    siDerived           =   true;
                    person
                    =   {
                          about         =   "dem französischen Physiker";
                          name          =   "Charles Augustin de Coulomb";
                        };
                    value               =   { value = 1; unit = [ "ampere" "second" ]; };
                  };
            };
      };
  countsPerSecond
  =   Unit "cps"
      {
        title
        =   {
              deu                       =   "Zähl\\-impulse je Sekunde";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Zähl\\-rate";
                    foreign
                    =   {
                          language      =   "english";
                          text          =   "Counts Per Second";
                        };
                    value               =   { value = 1; unit = "second-1"; };
                  };
            };
      };
  dalton
  =   Unit "u"
      {
        title
        =   {
              deu                       =   "Atomare Massen\\-einheit";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Masse";
                    foreign
                    =   {
                          language      =   "english";
                          text          =   "Unified atomic mass unit";
                        };
                    description
                    =   ''
                          ein Zwölftel der Masse
                            eines isolierten Atomes des Kohlenstoff\-isotops \textsuperscript{12}C
                            im Grund\-zustand
                        '';
                    value               =   { value = { value = 1.66053906660; exp = -27; precision = 11; }; unit = "kilogram"; };
                  };
            };
      };
  degree
  =   Angle "°"
      {
        title
        =   {
              deu                       =   "Grad";
            };
        description
        =   {
              deu
              =   {
                    about               =   "des Winkels";
                    value               =   { value = "\\frac{\\pi}{180}"; unit = "radian"; };
                  };
            };
      };
  electronVolt
  =   Unit "eV"
      {
        title
        =   {
              deu                       =   "Elektron\\-volt";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Energie";
                    alternatives        =   [ "Elektronen\\-volt" ];
                    description
                    =   ''
                          entspricht der kinetischen Energie eines Elektrons,
                            welches mit \Physical{1}{}{volt}{} beschleunigt wurde
                        '';
                    value
                    =   [
                          { value = { value = 1.6022; exp = -19; precision = 4; }; unit = "joule"; }
                          { value = 1; unit = [ "volt" "elementaryCharge" ]; }
                        ];
                  };
            };
      };
  equivalent
  =   Unit "eq."
      {
        title
        =   {
              deu                       =   "Äquivalent";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der relativen Stoff\\-menge";
                    foreign
                    =   {
                          language      =   "english";
                          text          =   "EQuivalent";
                        };
                    description
                    =   ''
                          veraltet auch \textit{Val}
                        '';
                  };
            };
      };
  hertz
  =   Unit "Hz"
      {
        title
        =   {
              deu                       =   "Hertz";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Frequenz";
                    person
                    =   {
                          about         =   "dem deutschen Physiker";
                          name          =   "Heinrich Hertz";
                        };
                    value               =   { value = 1; unit = "second-1"; };
                  };
            };
      };
  hour
  =   Unit "h"
      {
        title
        =   {
              deu                       =   "Stunden";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Zeit";
                    foreign
                    =   {
                          language      =   "english";
                          text          =   "Hours";
                        };
                    value               =   { value = 3600; unit = "second"; };
                  };
            };
      };
  joule
  =   Unit "J"
      {
        title
        =   {
              deu                       =   "Joule";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Energie";
                    person
                    =   {
                          about         =   "dem britischen Physiker";
                          name          =   "James Prescott Joule";
                        };
                    value               =   { value = 1; unit = [ "kilogram" "metre+2" "second-2" ]; };
                  };
            };
      };
  kelvin
  =   Unit "K"
      {
        title
        =   {
              deu                       =   "Kelvin";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der absoluten Temperatur";
                    siBasic             =   true;
                    person
                    =   {
                          about         =   "dem britischen Physiker";
                          name          =   "Lord Kelvin";
                        };
                  };
            };
      };
  kilocalorie
  =   Unit "kcal"
      {
        title
        =   {
              deu                       =   "\\acrtext[kilo]{Kilo}\\-kalorie";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Energie";
                    archaic             =   true;
                    foreign
                    =   {
                          language      =   "latin";
                          text          =   "calor";
                          meaning       =   "Wärme";
                        };
                    value               =   { value = { value = 4.1868; exp = 3; precision = 4; }; unit = "joule"; };
                  };
            };
      };
  kilogram
  =   Unit "kg"
      {
        title
        =   {
              deu                       =   "\\acrtext[kilo]{Kilo}\\-gramm";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Masse \\acrshort{beziehungsweise} des Gewichtes";
                    foreign
                    =   {
                          language      =   "greek";
                          text          =   "γράμμα";
                          latin         =   "gramma";
                          meaning       =   "Buchstabe";
                        };
                    siBasic             =   true;
                  };
            };
      };
  litre
  =   Unit "l"
      {
        title
        =   {
              deu                       =   "Liter";
            };
        description
        =   {
              deu
              =   {
                    about               =   "des Volumens";
                    foreign
                    =   {
                          language      =   "greek";
                          text          =   "λίτρα";
                          latin         =   "litra";
                          meaning       =   "Pfund";
                        };
                    value               =   { value = { value = 1; exp = -3; }; unit = "metre+3"; };
                  };
            };
      };
  metre
  =   Unit "m"
      {
        title
        =   {
              deu                       =   "Meter";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Länge";
                    foreign
                    =   {
                          language      =   "greek";
                          text          =   "μέτρον";
                          latin         =   "metron";
                          meaning       =   "Maß, Länge";
                        };
                    siBasic             =   true;
                  };
            };
      };
  minute
  =   Unit "min"
      {
        title
        =   {
              deu                       =   "Minuten";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Zeit";
                    foreign
                    =   {
                          language      =   "latin";
                          text          =   "pars minuta";
                          meaning       =   "verminderter Teil";
                        };
                    value               =   { value = 60; unit = "second"; };
                  };
            };
      };
  mol
  =   Unit "mol"
      {
        title
        =   {
              deu                       =   "Mol";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Stoff\\-menge";
                    foreign
                    =   {
                          language      =   "latin";
                          text          =   "molecula";
                          meaning       =   "kleine \\mbox{Masse}";
                        };
                    siBasic             =   true;
                  };
            };
      };
  molar
  =   Unit "M"
      {
        title
        =   {
              deu                       =   "Molar";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Stoff\\-mengen\\-konzentration";
                    foreign
                    =   {
                          language      =   "latin";
                          text          =   "molecula";
                          meaning       =   "kleine Masse";
                        };
                    value               =   { value = 1; unit = [ "mol" "litre-1" ]; };
                  };
            };
      };
  newton
  =   Unit "N"
      {
        title
        =   {
              deu                       =   "Newton";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Kraft";
                    person
                    =   {
                          about         =   "dem englischen Physiker";
                          name          =   "Isaac Newton";
                        };
                    value               =   { value = 1; unit = [ "kilogram" "metre" "second-2" ]; };
                  };
            };
      };
  ohm
  =   Unit "\\Omega"
      {
        title
        =   {
              deu                       =   "Ohm";
            };
        description
        =   {
              deu
              =   {
                    about               =   "des elektrischen Widerstandes";
                    person
                    =   {
                          about         =   "dem deutschen Physiker";
                          name          =   "Georg Simon Ohm";
                        };
                    value               =   { value = 1; unit = [ "kilogram" "metre+2" "ampere-2" "second-3" ]; };
                  };
            };
        sortedBy                        =   "O";
      };
  pascal
  =   Unit "Pa"
      {
        title
        =   {
              deu                       =   "Pascal";
            };
        description
        =   {
              deu
              =   {
                    about               =   "des Druckes";
                    person
                    =   {
                          about         =   "dem französischen Mathematiker und Physiker";
                          name          =   "Blaise Pascal";
                        };
                    value               =   { value = 1; unit = [ "kilogram" "metre-1" "second-2" ]; };
                  };
              };
      };
  percent
  =   Unit "\\%"
      {
        title
        =   {
              deu                       =   "Prozent";
        };
        description
        =   {
              deu
              =   {
                    about               =   "";
                    pseudoUnit          =   true;
                    foreign
                    =   {
                          language      =   "latin";
                          text          =   "per centum";
                          meaning       =   "von Hundert";
                        };
                    value               =   { value = { value = 1; exp = -2; }; unit = []; };
                  };
        };
      };
  permille
  =   Unit "‰"
      {
        title
        =   {
              deu                       =   "Promille";
            };
        description
        =   {
              deu
              =   {
                    about               =   "";
                    pseudoUnit          =   true;
                    foreign
                    =   {
                          language      =   "latin";
                          text          =   "per mille";
                          meaning       =   "von Tausend";
                        };
                    value               =   { value = { value = 1; exp = -3; }; unit = []; };
                  };
            };
      };
  ppm
  =   Unit "ppm"
      {
        title
        =   {
              deu                       =   "Millionstel";
            };
        description
        =   {
              deu
              =   {
                    about               =   "";
                    pseudoUnit          =   true;
                    foreign
                    =   {
                          language      =   "english";
                          text          =   "Parts Per Million";
                          meaning       =   "Teile je \\mbox{Million}";
                        };
                    value               =   { value = { value = 1; exp = -9; }; unit = []; };
                  };
            };
      };
  radian
  =   Unit "rad"
      {
        title
        =   {
              deu                       =   "Radiant";
            };
        description
        =   {
              deu
              =   {
                    about               =   "des Winkels";
                    foreign
                    =   {
                          language      =   "latin";
                          text          =   "radius";
                          meaning       =   "Strahl";
                        };
                  };
        };
      };
  rpm
  =   Unit "rpm"
      {
        title
        =   {
              deu                       =   "Umdrehungen pro Minute";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Dreh\\-zahl";
                    foreign
                    =   {
                          language      =   "english";
                          text          =   "Rotations Per Minute";
                        };
                    value               =   { value = 1; unit = "minute-1"; };
                  };
            };
      };
  second
  =   Unit "s"
      {
        title
        =   {
              deu                       =   "Sekunden";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Zeit";
                    foreign
                    =   {
                          language      =   "latin";
                          text          =   "pars minuta secunda";
                          meaning       =   "zweiter verminderter Teil";
                        };
                    description
                    =   ''
                           das 9.192.631.770-fache der Periodendauer der Strahlung,
                            die dem Übergang zwischen den beiden Hyper\-fein\-struktur\-niveaus des Grund\-zustandes
                            von Atomen des Nuklids \textsuperscript{133}Cs entspricht
                        '';
                    siBasic             =   true;
                  };
            };
      };
  siemens
  =   Unit "S"
      {
        title
        =   {
              deu                       =   "Siemens";
            };
        description
        =   {
              deu
              =   {
                    about               =   "des elektrischen Leit\\-wertes";
                    person
                    =   {
                          about         =   "dem deutschen Erfinder und Elektro\\-ingenieur";
                          name          =   "Werner von Siemens";
                        };
                    value               =   { value = 1; unit = "ohm-1"; };
                  };
            };
      };
  torr
  =   Unit "Torr"
      {
        title
        =   {
              deu                       =   "Torr";
            };
        description
        =   {
              deu
              =   {
                    about               =   "des Druckes";
                    archaic             =   true;
                    description
                    =   ''
                          identisch mit der Milli\-meter\-quecksilber\-säule
                        '';
                    person
                    =   {
                          about         =   "dem italienischen Physiker und Mathematiker";
                          name          =   "Evangelista Torricelli";
                        };
                    value               =   { value = { value = 1.33322; exp = 2; precision = 5; }; unit = [ "kilogram" "metre-1" "second-2" ]; };
                  };
            };
      };
  volt
  =   Unit "V"
      {
        title
        =   {
              deu                       =   "Volt";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der elektrischen Spannung";
                    person
                    =   {
                          about         =   "dem italienischen Physiker";
                          name          =   "Alessandro Volta";
                        };
                    value               =   { value = 1; unit = [ "kilogram" "metre+2" "ampere-1" "second-3" ]; };
                  };
            };
      };
  watt
  =   Unit "W"
      {
        title
        =   {
              deu                       =   "Watt";
            };
        description
        =   {
              deu
              =   {
                    about               =   "der Leistung";
                    person
                    =   {
                          about         =   "dem schottischen Physiker";
                          name          =   "James Watt";
                        };
                    value               =   { value = 1; unit = [ "kilogram" "metre+2" "second-3" ]; };
                  };
            };
      };
}
