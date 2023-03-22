local sectionCounter                    =   0
local function section  ( class,  title )
  sectionCounter                        =   sectionCounter  + 1
  acronyms.sections [ sectionCounter  ]
  = {
      class                             =   class or  0,
      title                             =   title [ acronyms.language ] or  title.eng or  "",
    }
  return  sectionCounter
end

sections
=   {
      General
      =   section ( 1,  { deu = "",                                               eng = "",                                       } ),
      Analytical
      =   section ( 2,  { deu = "Analytik",                                       eng = "Analytic",                               } ),
      Substances
      =   section ( 2,  { deu = "Chemische Substanzen oder Gruppen",              eng = "Chemical Substances and Groups",         } ),
      Units
      =   section ( 2,  { deu = "Einheiten",                                      eng = "Units",                                  } ),
      Variables
      =   section ( 2,  { deu = "Formel\\-zeichen und Konstanten",                eng = "Common Symbols and Constants",           } ),
      Standards
      =   section ( 2,  { deu = "Normen, Standards und Organisationen",           eng = "Standards and Organisations",            } ),
      Prefixes
      =   section ( 2,  { deu = "Vorsätze für Maß\\-einheiten",                   eng = "Unit Prefixes",                          } ),
      Electronics
      =   section ( 2,  { deu = "Elektronik und elektrische Bau\\-elemente",      eng = "Electronics and Electronic Components",  } ),
      Quantum
      =   section ( 2,  { deu = "Quanten\\-physikalische Begriffe und Phänomene", eng = "Quantum Physical Terms and Phenomenons", } ),
      Miscellaneous
      =   section ( 3,  { deu = "Sonstiges",                                      eng = "Miscellaneous",                          } ),
    }
