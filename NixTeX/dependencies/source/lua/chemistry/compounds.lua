chem.compounds                          =   {}

---
chem.compounds.knownWords
=   {}

--- Common Errors, that shall be detected and a warning should be emitted.
--- All entries are lower case.
chem.compounds.knownErrors
=   {
      [ "etyl"                ]         =   "ethyl",
      [ "metyl"               ]         =   "methyl",
      [ "penyl"               ]         =   "phenyl",
    }

--- Parts of compounds with an entry in the list of acronyms.
--- All entries are lower case.
chem.compounds.knownAcronyms
=   {
      [ "acetyl"              ]         =   "acetyl",
      [ "bithiophen"          ]         =   "bithiophene",
      [ "dibenzylideneaceton" ]         =   "dibenzylideneacetone",
      [ "ethyl"               ]         =   "ethyl",
      [ "cyclopentadienyl"    ]         =   "cyclopentadienyl",
      [ "ferrocen"            ]         =   "ferrocenyl",
      [ "ferrocenyl"          ]         =   "ferrocenyl",
      [ "isopropyl"           ]         =   "isoPropyl",
      [ "mesyl"               ]         =   "mesyl",
      [ "mesylat"             ]         =   "mesyl",
      [ "tosyl"               ]         =   "tosyl",
      [ "tosylat"             ]         =   "tosyl",
      [ "triflyl"             ]         =   "triflyl",
      [ "triflat"             ]         =   "triflyl",
      [ "methyl"              ]         =   "methyl",
      [ "phenyl"              ]         =   "phenyl",
    }

--- Known Prefixes (…- or -…-) that should be formated.
--- All entries are case-sensitive.
chem.compounds.knownPrefixes
=   {
      [ "(+)"   ]                       =   { "(\\plus)",         "(+)",        },
      [ "(-)"   ]                       =   { "(\\minus)",        "(−)",        },
      [ "(D)"   ]                       =   { "\\textsc{D}",      "ᴅ",          },
      [ "(E)"   ]                       =   { "(\\textit{E})",    "(𝘌)",       },
      [ "(L)"   ]                       =   { "\\textsc{L}",      "ʟ",          },
      [ "(M)"   ]                       =   { "(\\textit{M})",    "(𝘔)",       },
      [ "(P)"   ]                       =   { "(\\textit{P})",    "(𝘗)",       },
      [ "(R)"   ]                       =   { "(\\textit{R})",    "(𝘙)",       },
      [ "(S)"   ]                       =   { "(\\textit{S})",    "(𝘚)",       },
      [ "(Z)"   ]                       =   { "(\\textit{Z})",    "(𝘡)",       },
      [ "a"     ]                       =   { "α",          "α",          },
      [ "alt"   ]                       =   { "\\textit{alt}",    "𝘢𝘭𝘵",     },
      [ "b"     ]                       =   { "β",           "β",          },
      [ "cis"   ]                       =   { "\\textit{cis}",    "𝘤𝘪𝘴",     },
      [ "d"     ]                       =   { "δ",          "δ",          },
      [ "e"     ]                       =   { "ε",        "ε",          },
      [ "fac"   ]                       =   { "\\textit{fac}",    "𝘧𝘢𝘤",     },
      [ "g"     ]                       =   { "γ",          "γ",          },
      [ "h"     ]                       =   { "η",            "η",          "super"},
      [ "i"     ]                       =   { "\\textit{i}",      "𝘪",         },
      [ "iso"   ]                       =   { "\\textit{iso}",    "𝘪𝘴𝘰",     },
      [ "ipso"  ]                       =   { "\\textit{ipso}",   "𝘪𝘱𝘴𝘰",   },
      [ "k"     ]                       =   { "κ",          "κ",          "super"},
      [ "l"     ]                       =   { "λ",         "λ",          },
      [ "m"     ]                       =   { "\\textit{m}",      "𝘮",         },
      [ "mer"   ]                       =   { "\\textit{mer}",    "𝘮𝘦𝘳",     },
      [ "meso"  ]                       =   { "\\textit{meso}",   "𝘮𝘦𝘴𝘰",   },
      [ "mu"    ]                       =   { "µ",             "μ",          "sub"},
      [ "n"     ]                       =   { "\\textit{n}",      "𝘯",         },
      [ "neo"   ]                       =   { "\\textit{neo}",    "𝘯𝘦𝘰",     },
      [ "o"     ]                       =   { "\\textit{o}",      "𝘰",         },
      [ "p"     ]                       =   { "\\textit{p}",      "𝘱",         },
      [ "sec"   ]                       =   { "\\textit{sec}",    "𝘴𝘦𝘤",     },
      [ "tert"  ]                       =   { "\\textit{tert}",   "𝘵𝘦𝘳𝘵",   },
      [ "trans" ]                       =   { "\\textit{trans}",  "𝘵𝘳𝘢𝘯𝘴", },
      [ "w"     ]                       =   { "ω",          "ω",          },
    }

for index, element in ipairs({
  "H",  "D",  "T",                                                                                      "He",
  "Li", "Be",                                                             "B",  "C",  "N",  "O",  "F",  "Ne",
  "Na", "Mg",                                                             "Al", "Si", "P",  "S",  "Cl", "Ar",
  "K",  "Ca", "Sc", "Ti", "V",  "Cr", "Mn", "Fe", "Co", "Ni", "Cu", "Zn", "Ga", "Ge", "As", "Se", "Br", "Kr",
  "Rb", "Sr", "Y",  "Zr", "Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd", "In", "Sn", "Sb", "Te", "I",  "Xe",
  "Cs", "Ba", "La", "Hf", "Ta", "W",  "Re", "Os", "Ir", "Pt", "Au", "Hg", "Tl", "Pb", "Bi", "Po", "At", "Rn"
})
do
  chem.compounds.knownPrefixes[element] =   { "\\textit{"..element.."}", element }
end

chem.compounds.someOptionals
=   {
      [ "gruppe"  ]                     =   "Group",
    }

local function parsePrefixes  ( prefixes, detailed, replaceOptionals )
  local texStringOuter                  =   ""
  local pdfStringOuter                  =   ""

  --  iterate over prefixes »a-b-c-«
  for prefix                            in  prefixes:gmatch ( "([^-]*)-"      )
  do
    log.debug("parsePrefixes", "outer: "..prefix)
    local preprefix                     =   ""
    if  prefix:sub  ( 1, 2 ) ==  "§"
    then
      prefix                            =   prefix:sub  ( 3  )
      if  detailed
      then
        preprefix                       =   "}"
        detailed                        =   false
      else
        preprefix                       =   "\\detailed{"
        detailed                        =   true
      end
    end
    local suffix                        =   ""
    if  prefix:sub  ( -2  ) ==  "§"
    then
      prefix                            =   prefix:sub  ( 1,  -3  )
      if  detailed
      then
        suffix                          =   "}"
        detailed                        =   false
      else
        suffix                          =   "\\detailed{"
        detailed                        =   true
      end
    end

    local texStringInner                =   ""
    local pdfStringInner                =   ""
    for prefix                          in  prefix:gmatch   ( "([^,]*)"       )
    do
      log.debug("parsePrefixes", "inner: "..prefix)
      local realPrefix, primes          =   prefix:match    ( "([^']+)([']+)" )
      if  primes
      then
        local length                    =   #primes
        primes                          =   ( "⁗" ):rep ( math.floor  ( length  / 4 ) )
        length                          =   length % 4
        primes                          =   primes  ..  ( "‴" ):rep ( math.floor  ( length  / 3 ) )
        length                          =   length % 3
        primes                          =   primes  ..  ( "″" ):rep ( math.floor  ( length  / 2 ) )
        length                          =   length % 2
        primes                          =   primes  ..  ( "′" ):rep ( length                      )
      else
        primes                          =   ""
      end

      local texPrefix                   =   ""
      local pdfPrefix                   =   ""
      realPrefix                        =   realPrefix  or  prefix
      local head, foot                  =   realPrefix:match ( "([^|]+)|([^|]+)"     )
      if  foot
      then
        texPrefix                       =   head
        pdfPrefix                       =   head
        realPrefix                      =   foot
      end

      local position, atom              =   realPrefix:match  ( "^(%d*)([A-Z][a-z]?)$"  )
      if  position
      then
        if atom == "E" or atom == "Z"
        then
          pdfPrefix                     =   pdfPrefix ..  "(" .. position  ..  atom .. ")"
          texPrefix                     =   texPrefix .. "\\textit{(" .. position .. atom .. ")}"
        else
          pdfPrefix                     =   pdfPrefix ..  position  ..  atom
          texPrefix                     =   texPrefix ..  position  ..  "\\textit{" ..  atom  ..  "}"
        end
      else
        local acronym                   =   chem.compounds.knownAcronyms [ realPrefix:lower ( ) ]
        if      acronym
        then
          if  acronyms.list [ acronym ]
          then
            log.info
            (
              "parsePrefixes",
              "Acronym: »"..tostring(acronym).."«",
              "Foot:    »"..tostring(realPrefix).."«"
            )
            texPrefix                   =   texPrefix ..  acronyms.getLink          ( acronym,  realPrefix  )
          else
            texPrefix                   =   texPrefix ..  acronyms.getLinkUnchecked ( acronym,  realPrefix  )
            acronyms.mind [ acronym ]   =   true
          end
        elseif  chem.compounds.knownErrors   [ realPrefix:lower ( ) ]
        then
          texPrefix                     =   texPrefix ..  realPrefix
          log.error
          (
            "parsePrefixes",
            "Found known error »" ..  realPrefix:lower  ( ) ..  "«, did you mean »"
            ..  compounds.knownErrors [ realPrefix:lower  ( ) ] ..  "«?"
          )
        else
          local first = true
          for realPrefix                in  realPrefix:gmatch   ( "([^:]*)"       )
          do
            if not first
            then
              texPrefix                 =   texPrefix .. ":"
              pdfPrefix                 =   pdfPrefix .. ":"
            end
            first                       =   false
            local prefix, number        =   realPrefix:match  ( "^(.+)([0-9]+)$"  )
            local replace               =   nil
            if number
            then
              replace                   =   chem.compounds.knownPrefixes  [ prefix  ]
            else
              replace                   =   chem.compounds.knownPrefixes  [ realPrefix  ]
            end
            if  replace
            then
              if number
              then
                texPrefix               =   texPrefix ..  replace [ 1 ] .. "\\text" .. replace [ 3 ] .. "script{" .. number .. "}"
                pdfPrefix               =   pdfPrefix ..  replace [ 2 ] .. number
              else
                texPrefix               =   texPrefix ..  replace [ 1 ]
                pdfPrefix               =   pdfPrefix ..  replace [ 2 ]
              end
            else
              texPrefix                 =   texPrefix ..  realPrefix
              pdfPrefix                 =   pdfPrefix ..  realPrefix
            end
          end
        end
      end

      texStringInner                    =   texStringInner  ..  "," ..  texPrefix ..  primes
      pdfStringInner                    =   pdfStringInner  ..  "," ..  pdfPrefix ..  primes
    end
    texStringOuter                      =   texStringOuter ..  preprefix  ..  texStringInner:sub  ( 2 ) ..   suffix  ..  "-"
    --texStringOuter                      =   texStringOuter ..  preprefix  ..  texStringInner:sub  ( 2 ) ..   suffix  ..  "-\\penalty0\\hskip0pt\\relax{}"
    pdfStringOuter                      =   pdfStringOuter ..  pdfStringInner:sub  ( 2 ) ..  "-"
  end

  return  texStringOuter, pdfStringOuter, detailed
end

function splitString(input, delimiter)
  print(input)
  print(delimiter)
  log.debug("string:split", "Input: »"..input.."« ("..delimiter..")")
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( input, delimiter, from  )
  while delim_from do
    local substring = string.sub( input, from , delim_from-1 )
    log.trace("string:split", "Add: »"..substring.."«")
    table.insert( result, substring )
    from  = delim_to + 1
    delim_from, delim_to = string.find( input, delimiter, from  )
  end
  local substring = string.sub( input, from  )
  log.trace("string:split", "Add': »"..substring.."«")
  table.insert( result, substring )
  return result
end

function  chem.compounds.parse  ( name, replaceOptionals )
  log.debug("chem.compounds.parse", "Input: »"..name.."«")
  local texStringOuter                  =   { }
  local pdfStringOuter                  =   { }
  local name
  =   name
  :gsub ( "([({])",       "|%1|"  )
  :gsub ( "([})])",       "|%1||" )
  :gsub ( "([%[])",       "|["    )
  :gsub ( "([%]])",       "]||"   )
  :gsub ( "([|][|][-])",  "|-"    )
  local detailed                        =   false

  for index,part                        in  ipairs(splitString(name, "[|][|]"))
  do
    log.trace("chem.compounds.parse", "part: »"..part.."«")
    local texStringInner                =   { }
    local pdfStringInner                =   { }
    for index, component                in  ipairs(splitString(part, "[|]"))
    do
      local attribute                   =   component:match ( "^%[(.-)%]$"          )
      if attribute
      then
        log.trace("chem.compounds.parse", "attribute: »"..attribute.."«")
        local texAttribute              =   ""
        local pdfAttribute              =   ""
        local letter                    =   ""
        local primes                    =   0
        for character                   in  attribute:utf8split ( )
        do
          if  character ==  "'"
          then
            if  letter  ~=  ""
            then
              texAttribute              =   texAttribute  ..  "\\textit{" ..  letter  ..  "}"
              letter                    =   ""
            end
            primes                      =   primes  + 1
          else
            if  primes  > 0
            then
              local aux                 =   ""
              aux                       =   ( "⁗" ):rep ( math.floor  ( primes  / 4 ) )
              primes                    =   primes % 4
              aux                       =   aux ..  ( "‴" ):rep ( math.floor  ( primes  / 3 ) )
              primes                    =   primes % 3
              aux                       =   aux ..  ( "″" ):rep ( math.floor  ( primes  / 2 ) )
              primes                    =   primes % 2
              aux                       =   aux ..  ( "′" ):rep ( primes                      )
              primes                    =   0
              texAttribute              =   texAttribute  ..  aux
              pdfAttribute              =   pdfAttribute  ..  aux
            end
            if  ( character >=  "A" and character <=  "Z" )
            or  ( character >=  "a" and character <=  "z" )
            then
              letter                    =   letter ..  character
              pdfAttribute              =   pdfAttribute  ..  character
            else
              if  letter  ~=  ""
              then
                texAttribute            =   texAttribute  ..  "\\textit{" ..  letter  ..  "}"
                letter                  =   ""
              end
              texAttribute              =   texAttribute  ..  character
              pdfAttribute              =   pdfAttribute  ..  character
            end
          end
        end
        if  primes  > 0
        then
          local aux                     =   ""
          aux                           =   ( "⁗" ):rep ( math.floor  ( primes  / 4 ) )
          primes                        =   primes % 4
          aux                           =   aux ..  ( "‴" ):rep ( math.floor  ( primes  / 3 ) )
          primes                        =   primes % 3
          aux                           =   aux ..  ( "″" ):rep ( math.floor  ( primes  / 2 ) )
          primes                        =   primes % 2
          aux                           =   aux ..  ( "′" ):rep ( primes                      )
          primes                        =   0
          texAttribute                  =   texAttribute  ..  aux
          pdfAttribute                  =   pdfAttribute  ..  aux
        elseif  letter  ~=  ""
        then
          texAttribute                  =   texAttribute  ..  "\\textit{" ..  letter  ..  "}"
          letter                        =   ""
        end

        table.insert
        (
          texStringInner,
          "[" ..  texAttribute  ..  "]"
        )

        table.insert
        (
          pdfStringInner,
          "[" ..  pdfAttribute  ..  "]"
        )
      else
        local texPrefixes               =   ""
        local pdfPrefixes               =   ""
        local prefixes, rest            =   component:match ( "^(.+-)([^-]*)$"      )
        if      rest
        then
          log.trace("chem.compounds.parse", "prefixes: »"..prefixes.."«", "rest: »"..rest.."«")
          component                     =   rest
          texPrefixes,  pdfPrefixes,  detailed
          =   parsePrefixes ( prefixes, detailed, replaceOptionals )
        end

        log.trace("chem.compounds.parse", "component before: »"..component.."«")
        if  component:sub  ( 1, 2 ) ==  "§"
        then
          component                     =   component:sub  ( 3  )
          if  detailed
          then
            texPrefixes                 =   texPrefixes ..  "}"
            detailed                    =   false
          else
            texPrefixes                 =   texPrefixes ..  "\\detailed{"
            detailed                    =   true
          end
        end
        local texSuffix                 =   ""
        if  component:sub  ( -2  ) ==  "§"
        then
          component                     =   component:sub  ( 1,  -3  )
          if  detailed
          then
            texSuffix                   =   "}"
            detailed                    =   false
          else
            texSuffix                   =   "\\detailed{"
            detailed                    =   true
          end
        end
        log.trace("chem.compounds.parse", "component after: »"..component.."«")

        local texComponent              =   component
        local pdfComponent              =   component
        local component                 =   component:lower ( )
        local acronym                   =   chem.compounds.knownAcronyms [ component  ]
        if      acronym
        then
          if  acronyms.list [ acronym ]
          then
            texComponent                =   acronyms.getLink          ( acronym,  pdfComponent  )
          else
            texComponent                =   acronyms.getLinkUnchecked ( acronym,  pdfComponent  )
            acronyms.mind [ acronym ]   =   true
          end
        elseif  chem.compounds.knownErrors   [ component  ]
        then
          log.error
          (
            "printCompound",
            "Found known error »" ..  pdfComponent ..  "«, did you mean »" ..  compounds.knownErrors [ component ] ..  "«?"
          )
        elseif  true
        and     replaceOptionals
        and     chem.compounds.someOptionals [ component ]
        then
          texComponent
          =   "\\AcrOptional{"
          ..  chem.compounds.someOptionals [ component ]
          ..  "}"
          pdfComponent                  =   texComponent
        elseif true
        then
          local element                 =   chem.elements.lookUp.deu  [ component ]
          if element
          then
            texComponent                =   chem.elements.linkToPSE ( element,  pdfComponent  )
          end
        end
        log.trace("chem.compounds.parse", "Insert Inner TEX »"..texPrefixes.."«..»"..texComponent.."«..»"..texSuffix.."«")
        table.insert
        (
          texStringInner,
          texPrefixes ..  texComponent  ..  texSuffix
        )

        log.trace("chem.compounds.parse", "Insert Inner PDF »"..pdfPrefixes.."«..»"..pdfComponent.."«")
        table.insert
        (
          pdfStringInner,
          pdfPrefixes ..  pdfComponent
        )
      end
    end

    table.insert
    (
      texStringOuter,
      table.concat  ( texStringInner )
    )

    table.insert
    (
      pdfStringOuter,
      table.concat  ( pdfStringInner )
    )
  end

  local texString                       =   table.concat  ( texStringOuter,  "\\-" )
  local pdfString                       =   table.concat  ( pdfStringOuter )
  if texString == ""
  or pdfString == ""
  then
    log.error("chem.compounds.print", "Empty String!")
  else
    log.debug
    (
      "chem.compounds.print",
      "texOutput: »"  ..  texString ..  "«",
      "pdfOutput: »"  ..  pdfString ..  "«"
    )
  end
  if  detailed
  then
    log.fatal
    (
      "chem.compounds.parse",
      "Uneven number of §",
      texString
    )
  end
  return  texString,  pdfString
end

function  chem.compounds.print  ( name, replaceOptionals )
  local texString, pdfString            =   chem.compounds.parse  ( name, replaceOptionals )
  log.warn("chem.compounds.print", texString)
  tex.print ( "\\relax\\texorpdfstring{"  ..  texString ..  "}{"  ..  pdfString ..  "}" )
end

function  chem.compounds.texPrint  ( name )
  chem.compounds.print  ( name )
end
