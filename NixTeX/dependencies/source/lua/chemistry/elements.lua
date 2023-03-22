chem.elements
=   {
      enableLinks                       =   false,
      classes
      =   {
            AlkaliMetal                 =   1,
            AlkaliEarthMetal            =   2,
            TransitionMetal             =   3,
            Metal                       =   4,
            Lanthanoids                 =   5,
            Actinoids                   =   6,
            Metalloid                   =   7,
            NonMetal                    =   8,
            NobleGas                    =   9,
          },
      states
      =   {
            Solid                       =   1,
            Liquid                      =   2,
            Gas                         =   3,
            Unknown                     =   4,
          },
      lookUp
      =   {
            deu                         =   { },
            eng                         =   { },
          },
      pse                               =   { },
    }

local elements
=   {
--    Symbol    =   Number, Mass,     Name,                                     Electronegativity,  State,                Radioactivity,  Class
      [ "H"   ] =   {   1,    1.0079, { deu = "Wasserstoff",    eng = "Hydrogen",       },  2.2,  chem.elements.states.Gas,     false,  chem.elements.classes.NonMetal,         },
      [ "He"  ] =   {   2,    4.0026, { deu = "Helium",         eng = "Helium",         },  0,    chem.elements.states.Gas,     false,  chem.elements.classes.NobleGas,         },

      [ "Li"  ] =   {   3,    6.9675, { deu = "Lithium",        eng = "Lithium",        },  0.98, chem.elements.states.Solid,   false,  chem.elements.classes.AlkaliMetal,      },
      [ "Be"  ] =   {   4,    9.0122, { deu = "Beryllium",      eng = "Beryllium",      },  1.57, chem.elements.states.Solid,   false,  chem.elements.classes.AlkaliEarthMetal, },
      [ "B"   ] =   {   5,   10.813,  { deu = "Bor",            eng = "Boron",          },  2.04, chem.elements.states.Solid,   false,  chem.elements.classes.Metalloid,        },
      [ "C"   ] =   {   6,   12.011,  { deu = "Kohlenstoff",    eng = "Carbon",         },  2.55, chem.elements.states.Solid,   false,  chem.elements.classes.NonMetal,         },
      [ "N"   ] =   {   7,   14.007,  { deu = "Stickstoff",     eng = "Nitrogen",       },  3.04, chem.elements.states.Gas,     false,  chem.elements.classes.NonMetal,         },
      [ "O"   ] =   {   8,   15.999,  { deu = "Sauerstoff",     eng = "Oxygen",         },  3.44, chem.elements.states.Gas,     false,  chem.elements.classes.NonMetal,         },
      [ "F"   ] =   {   9,   18.998,  { deu = "Fluor",          eng = "Fluorine",       },  3.98, chem.elements.states.Gas,     false,  chem.elements.classes.NonMetal,         },
      [ "Ne"  ] =   {  10,   20.180,  { deu = "Neon",           eng = "Neon",           },  0,    chem.elements.states.Gas,     false,  chem.elements.classes.NobleGas,         },

      [ "Na"  ] =   {  11,   22.990,  { deu = "Natrium",        eng = "Sodium",         },  0.93, chem.elements.states.Solid,   false,  chem.elements.classes.AlkaliMetal,      },
      [ "Mg"  ] =   {  12,   24.305,  { deu = "Magnesium",      eng = "Magnesium",      },  1.31, chem.elements.states.Solid,   false,  chem.elements.classes.AlkaliEarthMetal, },
      [ "Al"  ] =   {  13,   26.981,  { deu = "Aluminium",      eng = "Aluminium",      },  1.61, chem.elements.states.Solid,   false,  chem.elements.classes.Metal,            },
      [ "Si"  ] =   {  14,   28.085,  { deu = "Silicium",       eng = "Silicon",        },  1.9,  chem.elements.states.Solid,   false,  chem.elements.classes.Metalloid,        },
      [ "P"   ] =   {  15,   30.974,  { deu = "Phosphor",       eng = "Phosphorus",     },  2.19, chem.elements.states.Solid,   false,  chem.elements.classes.NonMetal,         },
      [ "S"   ] =   {  16,   32.067,  { deu = "Schwefel",       eng = "Sulfur",         },  2.58, chem.elements.states.Solid,   false,  chem.elements.classes.NonMetal,         },
      [ "Cl"  ] =   {  17,   35.451,  { deu = "Chlor",          eng = "Chlorine",       },  3.16, chem.elements.states.Gas,     false,  chem.elements.classes.NonMetal,         },
      [ "Ar"  ] =   {  18,   39.948,  { deu = "Argon",          eng = "Argon",          },  0.82, chem.elements.states.Gas,     false,  chem.elements.classes.NobleGas,         },

      [ "K"   ] =   {  19,   39.098,  { deu = "Kalium",         eng = "Potassium",      },  0.82, chem.elements.states.Solid,   false,  chem.elements.classes.AlkaliMetal,      },
      [ "Ca"  ] =   {  20,   40.078,  { deu = "Calcium",        eng = "Calcium",        },  1.0,  chem.elements.states.Solid,   false,  chem.elements.classes.AlkaliEarthMetal, },
      [ "Sc"  ] =   {  21,   44.956,  { deu = "Scandium",       eng = "Scandium",       },  1.36, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Ti"  ] =   {  22,   47.867,  { deu = "Titan",          eng = "Titanium",       },  1.54, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "V"   ] =   {  23,   50.941,  { deu = "Vanadium",       eng = "Vanadium",       },  1.63, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Cr"  ] =   {  24,   51.996,  { deu = "Chrom",          eng = "Chromium",       },  1.66, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Mn"  ] =   {  25,   54.938,  { deu = "Mangan",         eng = "Manganese",      },  1.55, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Fe"  ] =   {  26,   55.845,  { deu = "Eisen",          eng = "Iron",           },  1.83, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Co"  ] =   {  27,   58.933,  { deu = "Cobalt",         eng = "Cobalt",         },  1.91, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Ni"  ] =   {  28,   58.693,  { deu = "Nickel",         eng = "Nickel",         },  1.88, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Cu"  ] =   {  29,   63.546,  { deu = "Kupfer",         eng = "Copper",         },  1.9,  chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Zn"  ] =   {  30,   65.380,  { deu = "Zink",           eng = "Zinc",           },  1.65, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Ga"  ] =   {  31,   69.723,  { deu = "Gallium",        eng = "Gallium",        },  1.81, chem.elements.states.Solid,   false,  chem.elements.classes.Metal,            },
      [ "Ge"  ] =   {  32,   72.631,  { deu = "Germanium",      eng = "Germanium",      },  2.01, chem.elements.states.Solid,   false,  chem.elements.classes.Metalloid,        },
      [ "As"  ] =   {  33,   74.922,  { deu = "Arsen",          eng = "Arsenic",        },  2.18, chem.elements.states.Solid,   false,  chem.elements.classes.Metalloid,        },
      [ "Se"  ] =   {  34,   78.972,  { deu = "Selen",          eng = "Selenium",       },  2.55, chem.elements.states.Solid,   false,  chem.elements.classes.NonMetal,         },
      [ "Br"  ] =   {  35,   79.904,  { deu = "Brom",           eng = "Bromine",        },  2.96, chem.elements.states.Liquid,  false,  chem.elements.classes.NonMetal,         },
      [ "Kr"  ] =   {  36,   83.798,  { deu = "Krypton",        eng = "Krypton",        },  0,    chem.elements.states.Gas,     false,  chem.elements.classes.NobleGas,         },

      [ "Rb"  ] =   {  37,   85.468,  { deu = "Rubidium",       eng = "Rubidium",       },  0.82, chem.elements.states.Solid,   false,  chem.elements.classes.AlkaliMetal,      },
      [ "Sr"  ] =   {  38,   87.620,  { deu = "Strontnium",     eng = "Strontnium",     },  0.95, chem.elements.states.Solid,   false,  chem.elements.classes.AlkaliEarthMetal, },
      [ "Y"   ] =   {  39,   88.906,  { deu = "Yttrium",        eng = "Yttrium",        },  1.22, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Zr"  ] =   {  40,   91.224,  { deu = "Zirconium",      eng = "Zirconium",      },  1.33, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Nb"  ] =   {  41,   92.906,  { deu = "Niob",           eng = "Niobium",        },  1.6,  chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Mo"  ] =   {  42,   95.95,   { deu = "Molybdän",       eng = "Molybdenum",     },  2.16, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Tc"  ] =   {  43,   97,      { deu = "Technetium",     eng = "Technetium",     },  1.9,  chem.elements.states.Solid,   true,   chem.elements.classes.TransitionMetal,  },
      [ "Ru"  ] =   {  44,  101.07,   { deu = "Ruthenium",      eng = "Ruthenium",      },  2.2,  chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Rh"  ] =   {  45,  102.905,  { deu = "Rhodium",        eng = "Rhodium",        },  2.28, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Pd"  ] =   {  46,  106.42,   { deu = "Palladium",      eng = "Palladium",      },  2.2,  chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Ag"  ] =   {  47,  107.686,  { deu = "Silber",         eng = "Silver",         },  1.93, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Cd"  ] =   {  48,  112.414,  { deu = "Cadmium",        eng = "Cadmium",        },  1.69, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "In"  ] =   {  49,  114.818,  { deu = "Indium",         eng = "Indium",         },  1.78, chem.elements.states.Solid,   false,  chem.elements.classes.Metal,            },
      [ "Sn"  ] =   {  50,  118.711,  { deu = "Zinn",           eng = "Tin",            },  1.96, chem.elements.states.Solid,   false,  chem.elements.classes.Metal,            },
      [ "Sb"  ] =   {  51,  121.760,  { deu = "Antimon",        eng = "Antimony",       },  2.05, chem.elements.states.Solid,   false,  chem.elements.classes.Metalloid,        },
      [ "Te"  ] =   {  52,  127.60,   { deu = "Tellur",         eng = "Tellurium",      },  2.66, chem.elements.states.Solid,   false,  chem.elements.classes.Metalloid,        },
      [ "I"   ] =   {  53,  126.904,  { deu = "Iod",            eng = "Iodine",         },  2.1,  chem.elements.states.Solid,   false,  chem.elements.classes.NonMetal,         },
      [ "Xe"  ] =   {  54,  131.294,  { deu = "Xenon",          eng = "Xenon",          },  2.6,  chem.elements.states.Gas,     false,  chem.elements.classes.NobleGas,         },

      [ "Cs"  ] =   {  55,  132.906,  { deu = "Caesium",        eng = "Caesium",        },  0.79, chem.elements.states.Solid,   false,  chem.elements.classes.AlkaliMetal,      },
      [ "Ba"  ] =   {  56,  137.328,  { deu = "Barium",         eng = "Barium",         },  0.89, chem.elements.states.Solid,   false,  chem.elements.classes.AlkaliEarthMetal, },
      [ "La"  ] =   {  57,  138.906,  { deu = "Lanthan",        eng = "Lanthanum",      },  1.1,  chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Ce"  ] =   {  58,  140.116,  { deu = "Cer",            eng = "Cerium",         },  1.12, chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Pr"  ] =   {  59,  140.908,  { deu = "Praseodym",      eng = "Praseodymium",   },  1.13, chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Nd"  ] =   {  60,  144.242,  { deu = "Neodym",         eng = "Neodymium",      },  1.14, chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Pm"  ] =   {  61,  145,      { deu = "Promethium",     eng = "Promethium",     },  1.13, chem.elements.states.Solid,   true,   chem.elements.classes.Lanthanoids,      },
      [ "Sm"  ] =   {  62,  150.360,  { deu = "Samarium",       eng = "Samarium",       },  1.17, chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Eu"  ] =   {  63,  151.964,  { deu = "Europium",       eng = "Europium",       },  1.2,  chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Gd"  ] =   {  64,  157.25,   { deu = "Gadolinium",     eng = "Gadolinium",     },  1.2,  chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Tb"  ] =   {  65,  158.925,  { deu = "Terbium",        eng = "Terbium",        },  1.1,  chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Dy"  ] =   {  66,  162.500,  { deu = "Dysprosium",     eng = "Dysprosium",     },  1.22, chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Ho"  ] =   {  67,  164.930,  { deu = "Holmium",        eng = "Holmium",        },  1.23, chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Er"  ] =   {  68,  167.259,  { deu = "Erbium",         eng = "Erbium",         },  1.24, chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Tm"  ] =   {  69,  168.934,  { deu = "Thulium",        eng = "Thulium",        },  1.25, chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Yb"  ] =   {  70,  173.045,  { deu = "Ytterbium",      eng = "Ytterbium",      },  1.1,  chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Lu"  ] =   {  71,  174.967,  { deu = "Lutetium",       eng = "Lutetium",       },  1.27, chem.elements.states.Solid,   false,  chem.elements.classes.Lanthanoids,      },
      [ "Hf"  ] =   {  72,  178.49,   { deu = "Hafnium",        eng = "Hafnium",        },  1.3,  chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Ta"  ] =   {  73,  180.948,  { deu = "Tantal",         eng = "Tantalum",       },  1.5,  chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "W"   ] =   {  74,  183.84,   { deu = "Wolfram",        eng = "Tungsten",       },  2.36, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Re"  ] =   {  75,  186.207,  { deu = "Rhenium",        eng = "Rhenium",        },  1.9 , chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Os"  ] =   {  76,  190.23,   { deu = "Osmium",         eng = "Osmium",         },  2.2,  chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Ir"  ] =   {  77,  192.217,  { deu = "Iridium",        eng = "Iridium",        },  2.2,  chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Pt"  ] =   {  78,  195.085,  { deu = "Platin",         eng = "Platinum",       },  2.28, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Au"  ] =   {  79,  196.967,  { deu = "Gold",           eng = "Gold",           },  2.54, chem.elements.states.Solid,   false,  chem.elements.classes.TransitionMetal,  },
      [ "Hg"  ] =   {  80,  200.592,  { deu = "Quecksilber",    eng = "Mercury",        },  1.9,  chem.elements.states.Liquid,  false,  chem.elements.classes.TransitionMetal,  },
      [ "Tl"  ] =   {  81,  204.384,  { deu = "Thallium",       eng = "Thallium",       },  1.62, chem.elements.states.Solid,   false,  chem.elements.classes.Metal,            },
      [ "Pb"  ] =   {  82,  207.2,    { deu = "Blei",           eng = "Lead",           },  2.33, chem.elements.states.Solid,   false,  chem.elements.classes.Metal,            },
      [ "Bi"  ] =   {  83,  208.980,  { deu = "Bismut",         eng = "Bismuth",        },  2.02, chem.elements.states.Solid,   true,   chem.elements.classes.Metal,            },
      [ "Po"  ] =   {  84,  209.98,   { deu = "Polonium",       eng = "Polonium",       },  2.0,  chem.elements.states.Solid,   true,   chem.elements.classes.Metal,            },
      [ "At"  ] =   {  85,  210,      { deu = "Astat",          eng = "Astatine",       },  2.2,  chem.elements.states.Solid,   true,   chem.elements.classes.Metal,            },
      [ "Rn"  ] =   {  86,  222,      { deu = "Radon",          eng = "Radon",          },  0,    chem.elements.states.Gas,     true,   chem.elements.classes.NobleGas,         },

      [ "Fr"  ] =   {  87,  223,      { deu = "Francium",       eng = "Francium",       },  0.7,  chem.elements.states.Solid,   true,   chem.elements.classes.AlkaliMetal,      },
      [ "Ra"  ] =   {  88,  226,      { deu = "Radium",         eng = "Radium",         },  0.89, chem.elements.states.Solid,   true,   chem.elements.classes.AlkaliEarthMetal, },
      [ "Ac"  ] =   {  89,  227,      { deu = "Actinium",       eng = "Actinium",       },  1.1,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Th"  ] =   {  90,  232.038,  { deu = "Thorium",        eng = "Thorium",        },  1.5,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Pa"  ] =   {  91,  231.036,  { deu = "Protactinium",   eng = "Protactinium",   },  1.3,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "U"   ] =   {  92,  238.029,  { deu = "Uran",           eng = "Uranium",        },  1.36, chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Np"  ] =   {  93,  237,      { deu = "Neptunium",      eng = "Neptunium",      },  1.38, chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Pu"  ] =   {  94,  244,      { deu = "Plutonium",      eng = "Plutonium",      },  1.3,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Am"  ] =   {  95,  243,      { deu = "Americium",      eng = "Americium",      },  1.28, chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Cm"  ] =   {  96,  247,      { deu = "Curium",         eng = "Curium",         },  1.3,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Bk"  ] =   {  97,  247,      { deu = "Berkelium",      eng = "Berkelium",      },  1.3,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Cf"  ] =   {  98,  251,      { deu = "Californium",    eng = "Californium",    },  1.3,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Es"  ] =   {  99,  252,      { deu = "Einsteinium",    eng = "Einsteinium",    },  1.3,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Fm"  ] =   { 100,  257,      { deu = "Fermium",        eng = "Fermium",        },  1.3,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Md"  ] =   { 101,  258,      { deu = "Mendelevium",    eng = "Mendelevium",    },  1.3,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "No"  ] =   { 102,  259,      { deu = "Nobelium",       eng = "Nobelium",       },  1.3,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Lr"  ] =   { 103,  262,      { deu = "Lawrencium",     eng = "Lawrencium",     },  1.3,  chem.elements.states.Solid,   true,   chem.elements.classes.Actinoids,        },
      [ "Rf"  ] =   { 104,  267,      { deu = "Rutherfordium",  eng = "Rutherfordium",  },  nil,  chem.elements.states.Solid,   true,   chem.elements.classes.TransitionMetal,  },
      [ "Db"  ] =   { 105,  269,      { deu = "Dubnium",        eng = "Dubnium",        },  nil,  chem.elements.states.Solid,   true,   chem.elements.classes.TransitionMetal,  },
      [ "Sg"  ] =   { 106,  270,      { deu = "Seaborgium",     eng = "Seaborgium",     },  nil,  chem.elements.states.Solid,   true,   chem.elements.classes.TransitionMetal,  },
      [ "Bh"  ] =   { 107,  272,      { deu = "Bohrium",        eng = "Bohrium",        },  nil,  chem.elements.states.Solid,   true,   chem.elements.classes.TransitionMetal,  },
      [ "Hs"  ] =   { 108,  273,      { deu = "Hassium",        eng = "Hassium",        },  nil,  chem.elements.states.Solid,   true,   chem.elements.classes.TransitionMetal,  },
      [ "Mt"  ] =   { 109,  277,      { deu = "Meitnerium",     eng = "Meitnerium",     },  nil,  chem.elements.states.Solid,   true,   chem.elements.classes.TransitionMetal,  },
      [ "Ds"  ] =   { 110,  281,      { deu = "Darmstadtium",   eng = "Darmstadtium",   },  nil,  chem.elements.states.Solid,   true,   chem.elements.classes.TransitionMetal,  },
      [ "Rg"  ] =   { 111,  281,      { deu = "Roentgenium",    eng = "Roentgenium",    },  nil,  chem.elements.states.Solid,   true,   chem.elements.classes.TransitionMetal,  },
      [ "Cn"  ] =   { 112,  285,      { deu = "Copernicium",    eng = "Copernicium",    },  nil,  chem.elements.states.Unknown, true,   chem.elements.classes.TransitionMetal,  },
      [ "Nh"  ] =   { 113,  286,      { deu = "Nihonium",       eng = "Nihonium",       },  nil,  chem.elements.states.Unknown, true,   chem.elements.classes.Metal,            },
      [ "Fl"  ] =   { 114,  289,      { deu = "Flerovium",      eng = "Flerovium",      },  nil,  chem.elements.states.Unknown, true,   chem.elements.classes.Metal,            },
      [ "Mc"  ] =   { 115,  288,      { deu = "Moscovium",      eng = "Moscovium",      },  nil,  chem.elements.states.Unknown, true,   chem.elements.classes.Metal,            },
      [ "Lv"  ] =   { 116,  293,      { deu = "Livermorium",    eng = "Livermorium",    },  nil,  chem.elements.states.Unknown, true,   chem.elements.classes.Metal,            },
      [ "Ts"  ] =   { 117,  294,      { deu = "Tenness",        eng = "Tennessine",     },  nil,  chem.elements.states.Unknown, true,   chem.elements.classes.Metal,            },
      [ "Og"  ] =   { 118,  294,      { deu = "Oganesson",      eng = "Oganesson",      },  nil,  chem.elements.states.Unknown, true,   chem.elements.classes.NobleGas,         },
    }

local classColours
=   {
      "magenta",
      "red",
      "orange",
      "yellow",
      "green",
      "lime",
      "cyan",
      "blue",
      "purple",
    }

local stateShort
=   {
      "s",
      "l",
      "g",
      "?",
    }

local function initElements ( )
  for symbol, entry                     in  pairs ( elements  )
  do
    local deu                           =   ( entry [ 3 ].deu ):lower ( )
    local eng                           =   ( entry [ 3 ].eng ):lower ( )
    chem.elements.lookUp.deu  [ deu ]   =   symbol
    chem.elements.lookUp.eng  [ eng ]   =   symbol

    chem.elements.pse [ symbol  ]
    =   {
          number                        =   entry [ 1 ],
          mass                          =   entry [ 2 ],
          name                          =   entry [ 3 ],
          electronegativity             =   entry [ 4 ],
          state                         =   entry [ 5 ],
          radioactive                   =   entry [ 6 ],
          class                         =   entry [ 7 ],
        }
  end
end

--  ToDo: Language, calculate mass from formula
function chem.elements.printAnalysis  ( formula,  calculatedMass, gotThisMass )
  tex.print
  (
    "Elementaranalyse berechnet für "
    ..    chem.getSimple  ( formula )
    ..  ": "
    ..    tostring  ( calculatedMass  )
    ..  ", gefunden: "
    ..    tostring  ( gotThisMass     )
  )
end

function chem.elements.printEntry     ( symbol )
  local entry                           =   chem.elements.pse [ symbol  ]
  if entry
  then
    local radioactivity                 =   ""
    local electronegativity             =   entry.electronegativity
    if entry.radioactive
    then
      radioactivity                     =   "*"
    end
    if electronegativity
    then
      if electronegativity > 0
      then
        electronegativity               =   tostring(electronegativity)
      else
        electronegativity               =   "—"
      end
    else
      electronegativity                 =   "?"
    end
    local mass                          =   entry.mass
    if ( mass % 1 ) > 0
    then
      mass                              =   tostring  ( mass  )
    else
      mass                              =   "(" ..  tostring  ( mass  ) ..  ")"
    end
    tex.print
    (
      "\\relax\\cellcolor{"
      ..    classColours  [ entry.class ]
      ..  "!25}\\relax\\hypertarget{table:PSE_"
      ..    symbol
      ..  "}{"
      ..    tostring  ( entry.number  )
      ..  "}~\\hfill{"
      ..    mass
      .. "}\\newline\\textbf{\\small "
      ..    symbol
      ..    radioactivity
      ..  "}\\newline{\\mbox{\\fontsize{5}{6}\\selectfont "
      ..    entry.name.deu
      ..  "}}\\newline{"
      ..    electronegativity
      ..  "}~\\hfill{("
      ..    stateShort  [ entry.state ]
      ..  ")}"
    )
  else
    tex.print("??")
  end
end

function chem.elements.printColours   ( )
  tex.print
  (
    "\\textbf{Farben der Serien}"
    ..  "\\newline{\\color{" ..  classColours [ chem.elements.classes.AlkaliMetal       ] .. "}$\\blacksquare$}~Alkalimetalle"
    ..  "\\newline{\\color{" ..  classColours [ chem.elements.classes.AlkaliEarthMetal  ] .. "}$\\blacksquare$}~Erdalkalimetalle"
    ..  "\\newline{\\color{" ..  classColours [ chem.elements.classes.TransitionMetal   ] .. "}$\\blacksquare$}~Übergangsmetalle"
    ..  "\\newline{\\color{" ..  classColours [ chem.elements.classes.Metal             ] .. "}$\\blacksquare$}~Metalle"
    ..  "\\newline{\\color{" ..  classColours [ chem.elements.classes.Lanthanoids       ] .. "}$\\blacksquare$}~Lanthanoide"
    ..  "\\newline{\\color{" ..  classColours [ chem.elements.classes.Actinoids         ] .. "}$\\blacksquare$}~Actinoide"
    ..  "\\newline{\\color{" ..  classColours [ chem.elements.classes.Metalloid         ] .. "}$\\blacksquare$}~Halbmetalle"
    ..  "\\newline{\\color{" ..  classColours [ chem.elements.classes.NonMetal          ] .. "}$\\blacksquare$}~Nichtmetalle"
    ..  "\\newline{\\color{" ..  classColours [ chem.elements.classes.NobleGas          ] .. "}$\\blacksquare$}~Edelgase"
  )
end

function chem.elements.linkToPSE  ( symbol, text  )
  if chem.elements.enableLinks
  then
    return "\\protect\\hyperlink{table:PSE_"  ..  symbol ..  "}{"  ..  text  ..  "}"
  else
    return text
  end
end

initElements  ( )
