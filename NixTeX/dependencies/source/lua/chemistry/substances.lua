substances
=   {
      counter                           =   0,
      list                              =   { },
      extension                         =   "subs",
      noNumber                          =   false,
    }

local function texOrPDFstring                   ( label,  texString,  pdfString )
  local output
  =   "\\relax"
  ..      "\\texorpdfstring{"
  ..        "\\hyperref[substance:" ..  label ..  "]"
  ..      "{" ..  texString ..  "}}"
  ..      "{" ..  pdfString ..  "}"
  log.debug( "texOrPDFstring", output)
  return  output
end

local function getMass                          ( input,  identifier  )
  if  not input
  then
    log.warn
    (
      "getMass",
      "Substance »" ..  identifier  ..  "« does not have a mass."
    )
  end
  local mass                            =   tostring  ( input or  "???"  )
  if  type  ( input ) ==  "table"
  then
    mass                                =   ""
    for index, weight                   in  pairs ( input )
    do
      mass                              =   mass  ..  "+" ..  weight  ..  "·" ..  index
    end
    mass                                =   "(" ..  mass:sub(2)  ..  ")"
  end
  return "\\Physical[2]{" ..  mass  ..  "}{}{gram}{}\\Unit{mol}{-1}"
end

local function getNumberCode                    ( substance )
  if  substances.noNumber
  then
    log.error("getNumberCode", "This will print a number for »"..substance.identifier.."«")
  end
  if  substance.code.texString  ~=  ""
  then
    return  "\\textbf{" ..  tostring  ( substance.number  ) ..  "};~" ..  substance.code.texString,
            tostring  ( substance.number  ) ..  "; "  ..  substance.code.pdfString
  else
    return  "\\textbf{" ..  tostring  ( substance.number  ) ..  "}",
            tostring  ( substance.number  )
  end
end

local function sortByDefault  ( this, that  )
  local this                            =   substances.list [ this  ]
  local that                            =   substances.list [ that  ]
  if  this.sortedBy ~=  that.sortedBy
  then
    return  this.sortedBy   < that.sortedBy
  else
    return  this.identifier < that.identifier
  end
end

local function sortByNumber   ( this, that  )
  local this                            =   substances.list [ this  ]
  local that                            =   substances.list [ that  ]
  return  ( this.number or  this.oldNumber  or  -1  ) < ( that.number or  that.oldNumber  or  -1  )
end

function  substances.declare                    ( identifier, object  )
  if  type  ( identifier  ) ==  "string"
  and type  ( object      ) ==  "table"
  then
    local name                          =   { }
    local acronym                       =   object.acronym
    if  acronym
    then
      local entry                       =   acronyms.getEntry ( acronym )
      if  entry
      then
--        log.debug
--        (
--          "substances.declare",
--          "got: »"  ..  tostring  ( entry.long  [ 1 ] ) ..  "«"
--        )
        name
        =   {
              texString
              =   acronyms.getLink
                  (
                    acronym,
                    entry.long  [ 1 ]
                  ),
              pdfString                 =   entry.long  [ 2 ],
            }
      else
        log.fatal
        (
          { "substances", "declare",  },
          "cannot find acronym with identifier -»"  ..  acronym ..  "«!"
        )
      end
    else
      local texString, pdfString        =   chem.compounds.parse  ( object.name   or  ""  )
      name
      =   {
            texString                   =   texString,
            pdfString                   =   pdfString,
          }
    end

    local texString, pdfString, sortBy  =   chem.parseSimple      ( object.simple or  ""  )
    local simple
    =   {
          texString                     =   texString,
          pdfString                     =   pdfString,
        }

    local code                          =   object.code
    if  code
    then
      local texString, pdfString, sorty =   chem.parseSimple      ( code  or  ""  )
      code
      =   {
            texString                   =   texString,
            pdfString                   =   pdfString,
          }
      sortBy                            =   sorty
    else
      if object.acronym
      then
        local entry                     =   acronyms.getEntry ( object.acronym, true )
        if entry
        then
          code
          =   {
                texString               =   entry.short [ 1 ],
                pdfString               =   entry.short [ 2 ],
              }
          sortBy                        =   entry.sortedBy
        end
      else
        code                            =   simple
      end
    end

    local structure                     =   object.structure  or  { }
    if  type  ( structure ) ==  "table"
    then
      structure
      =   {
            figPart                     =   tostring  ( structure.figPart or  ""  ),
            movPart                     =   tostring  ( structure.movPart or  ""  ),
          }
    else
      structure
      =   {
            figPart                     =   tostring  ( structure ),
            movPart                     =   "",
          }
    end

--    log.debug
--    (
--      "substances.declare",
--      "name:      »"  ..  name.texString    ..  "« | »" ..  name.pdfString    ..  "«",
--      "code:      »"  ..  code.texString    ..  "« | »" ..  code.pdfString    ..  "«",
--      "simple:    »"  ..  simple.texString  ..  "« | »" ..  simple.pdfString  ..  "«",
--      "structure: »"  ..  structure.figPart ..  "« | »" ..  structure.movPart ..  "«",
--      "mass:      »"  ..  tostring  ( object.mass  or  "???"  ) ..  "«"
--    )

    log.debug
    (
      "substances.declare",
      "Sort by: »"  ..  sortBy ..  "«"
    )

    substances.list [ identifier  ]
    =   {
          identifier                    =   identifier,
          name                          =   name,
          code                          =   code,
          simple                        =   simple,
          structure                     =   structure,
          mass                          =   object.mass,
          sortedBy                      =   sortBy,
          oldNumber                     =   tonumber  ( substances.list [ identifier  ] ),
        }
  else
    log.fatal
    (
      { "substances", "declare",  },
      "Invalid Input Types: string for identifier and table for object expected"
    )
  end
end

function  substances.getAs                      ( identifier, texString, pdfString )
  local substance, identifier           =   substances.use  ( "getAs",                      identifier, false,  false )
  log.info
  (
    "substance.getAs",
    "identifier: »"..identifier.."«",
    "tex: »"..texString.."«",
    "pdf: »"..pdfString.."«"
  )
  return  texOrPDFstring
          (
            identifier,
            texString,
            pdfString
          )
end

function  substances.getCode                    ( identifier  )
  local substance, identifier           =   substances.use  ( "getCode",                    identifier, false,  false )
  --log.info("substance.getCode", "pdf: »"..substance.simple.pdfString.."«")
  return  texOrPDFstring
          (
            identifier,
            substance.code.texString,
            substance.code.pdfString
          )
end

function  substances.getCodeID                  ( identifier  )
  local substance, identifier           =   substances.use  ( "getCodeID",                  identifier, false,  true )
  return  texOrPDFstring
          (
            identifier,
            substance.code.texString  ..  " (\\textbf{" ..  tostring  ( substance.number  ) ..  "})",
            substance.code.pdfString  ..  " ("  ..  tostring  ( substance.number  ) ..  ")"
          )
end

function  substances.getFull                    ( identifier )
  local substance, identifier           =   substances.use  ( "getFull",                    identifier, true,   true  )
  local texCode, pdfCode                =   getNumberCode ( substance )
  return  texOrPDFstring
          (
            identifier,
            substance.name.texString  ..  " ("  ..  texCode ..  ")",
            substance.name.pdfString  ..  " ("  ..  pdfCode ..  ")"
          )
end

function  substances.getLabel                   ( identifier  )
  local substance, identifier           =   substances.use  ( "getLabel",                   identifier, false,  false )
  return  "\\label{substance:"  ..  identifier  ..  "}"
end

function  substances.getList                    ( byNumber    )
  local identifiers                     =   { }
  for identifier, entry                 in  pairs ( substances.list )
  do
    table.insert  ( identifiers,  identifier  )
  end

  local config                          =   "l@{\\quad}X"
  if  byNumber
  then
    table.sort  ( identifiers,  sortByNumber  )
    config                              =   "c@{\\quad}" ..  config
  else
    table.sort  ( identifiers,  sortByDefault )
  end

  local output                          =   ""
  for index,  identifier                in  ipairs  ( identifiers )
  do
    local entry                         =   substances.list [ identifier  ]
    if  entry.number
    or  entry.oldNumber
    then
      if  byNumber
      then
        output
        =   output  ..  "\\textbf{" ..  tostring  ( entry.oldNumber  ) ..  "} & "  ..  entry.code.texString  ..  " & " ..  entry.name.texString  ..  "\\\\"
      else
        output
        =   output  ..  entry.code.texString  ..  " & " ..  entry.name.texString  ..  "\\\\"
      end
    end
  end

  local header = "Kürzel & Name \\\\"
  if byNumber
  then
    header = "\\# & "..header
  end

  result =  "\\begin{longtabu}{"  ..  config  ..  "}"
  ..      output
  ..      "\\end{longtabu}"
  ..      "\\addtocounter{table}{-1}"

  log.warn("substance", "Result: "..result)

  return result
end

function  substances.getMass                    ( identifier, monomer )
  local substance, identifier           =   substances.use  ( "getMass",                    identifier, true,   false )
  if  monomer
  and monomer ~=  ""
  then
    if  substance.mass
    and type  ( substance.mass  ) ==  "table"
    then
      return  getMass ( substance.mass  [ monomer ],  identifier  )
    else
      log.error
      (
        "substances.getMass",
        "Substance does not have a monomere with index »" ..  monomer ..  "«"
      )
      return  getMass ( "¿¿"  ..  monomer ..  "??",   identifier  )
    end
  else
    return  getMass ( substance.mass, identifier  )
  end
end

function  substances.getMolecule                ( identifier )
  local substance, identifier           =   substances.use  ( "getMolecule",                identifier, false,  false )
  if  substance.structure.movPart ~=  ""
  then
    return  "\\relax"
            ..  "\\chemfig{"  .. substance.structure.figPart  .. "}"
            ..  "\\chemmove{" .. substance.structure.movPart  .. "}"
  else
    return  "\\relax"
            ..  "\\chemfig{"  .. substance.structure.figPart  .. "}"
  end
end

function  substances.getMoleculeWithCode        ( identifier  )
  local substance, identifier           =   substances.use  ( "getMoleculeWithCode",        identifier, false,  false )
  local text
  =   "\\relax"
  ..    "\\chemname{\\chemfig{"
  ..      substance.structure.figPart
  ..    "}}{\\tiny"
  ..      ( ( substance.code or { texString = "?????" } ).texString or "???" )
  ..    "}"
  if  substance.structure.movPart ~=  ""
  then
    return  text  ..  "\\chemmove{" .. substance.structure.movPart  .. "}"
  else
    return  text
  end
end

function  substances.getMoleculeWithMass        ( identifier  )
  local substance, identifier           =   substances.use  ( "getMoleculeWithMass",        identifier, false,  false )
  local text
  =   "\\relax"
  ..    "\\chemname{\\chemfig{"
  ..      substance.structure.figPart
  ..    "}}{\\tiny"
  ..      getMass ( substance.mass, identifier  )
  ..    "}"
  if  substance.structure.movPart ~=  ""
  then
    return  text  ..  "\\chemmove{" .. substance.structure.movPart  .. "}"
  else
    return  text
  end
end

function  substances.getMoleculeWithNumber  ( identifier  )
  local substance, identifier           =   substances.use  ( "getMoleculeWithNumber",  identifier, false,  false )
  local text
  =   "\\relax"
  ..    "\\chemname{\\chemfig{"
  ..      substance.structure.figPart
  ..    "}}{\\tiny"
  ..      "\\textbf{"..tostring(substance.number).."}"
  ..    "}"
  log.info("substances.getMoleculeWithNumber", text)
  if  substance.structure.movPart ~=  ""
  then
    return  text  ..  "\\chemmove{" .. substance.structure.movPart  .. "}"
  else
    return  text
  end
end

function  substances.getMoleculeWithNumberYield  ( identifier, yield  )
  local substance, identifier           =   substances.use  ( "getMoleculeWithNumberYield",  identifier, false,  false )
  local text
  =   "\\relax"
  ..    "\\chemname{\\chemfig{"
  ..      substance.structure.figPart
  ..    "}}{\\tiny"
  ..      "\\textbf{"..tostring(substance.number)..", \\Physical{"..yield.."}{}{percent}{}}"
  ..    "}"
  if  substance.structure.movPart ~=  ""
  then
    return  text  ..  "\\chemmove{" .. substance.structure.movPart  .. "}"
  else
    return  text
  end
end

function  substances.getMoleculeWithNumberCode  ( identifier  )
  local substance, identifier           =   substances.use  ( "getMoleculeWithNumberCode",  identifier, false,  false )
  local texCode, pdfCode                =   getNumberCode ( substance )
  local text
  =   "\\relax"
  ..    "\\chemname{\\chemfig{"
  ..      substance.structure.figPart
  ..    "}}{\\tiny"
  ..      texCode
  ..    "}"
  if  substance.structure.movPart ~=  ""
  then
    return  text  ..  "\\chemmove{" .. substance.structure.movPart  .. "}"
  else
    return  text
  end
end

function  substances.getName                    ( identifier  )
  local substance, identifier           =   substances.use  ( "getName",                    identifier, true,   false )
  return  texOrPDFstring
          (
            identifier,
            substance.name.texString,
            substance.name.pdfString
          )
end

function  substances.getNumber                  ( identifier  )
  local substance, identifier           =   substances.use  ( "getNumber",                  identifier, false,  true  )
  if  substances.noNumber
  then
    log.error("substance.getNumber", "This will print a number for »"..substance.identifier.."«")
  end
  return  texOrPDFstring
          (
            identifier,
            "\\textbf{" ..  tostring  ( substance.number  ) ..  "}",
            tostring  ( substance.number  )
          )
end

function  substances.getSimple                  ( identifier  )
  local substance, identifier           =   substances.use  ( "getSimple",                  identifier, false,  false )
  return  texOrPDFstring
          (
            identifier,
            substance.simple.texString,
            substance.simple.pdfString
          )
end

function  substances.getWithID                  ( identifier  )
  local substance, identifier           =   substances.use  ( "getWithCode",                identifier, true,   true )
  if  substances.noNumber
  then
    log.error("substance.getWithID", "This will print a number for »"..substance.identifier.."«")
  end
  return  texOrPDFstring
          (
            identifier,
            substance.name.texString  ..  " (\\textbf{" ..  tostring  ( substance.number  ) ..  "})",
            substance.name.pdfString  ..  " (\\textbf{" ..  tostring  ( substance.number  ) ..  "})"
          )
end

function  substances.getWithCode                ( identifier  )
  local substance, identifier           =   substances.use  ( "getWithCode",                identifier, false,  true )
  --log.info("substance.getCode", "pdf: »"..substance.simple.pdfString.."«")
  if  substances.noNumber
  then
    log.error("substance.getWithCode", "This will print a number for »"..substance.identifier.."«")
  end
  return  texOrPDFstring
          (
            identifier,
            "\\textbf{" ..  tostring  ( substance.number  ) ..  "} (" ..  substance.simple.texString  ..  ")",
            tostring  ( substance.number  ) ..  " (" ..  substance.simple.pdfString ..  ")"
          )
end

function substances.init                        ( )
  local file                            =   buildFiles.open ( substances.extension  )
  if  file
  then
    local counter                       =   0
    for identifier                      in  file:lines  ( )
    do
      if  identifier  ~=  ""
      then
        counter                         =   counter + 1
        substances.list [ identifier  ] =   substances.list [ identifier  ] or  counter
      end
    end
    file:close  ( )
  end
end

function substances.load                        ( path  )
  loadLuaFile ( path  )
end

function substances.printAs                     ( identifier, texString, pdfString  )
  tex.print ( substances.getAs                      ( identifier, texString, pdfString ) )
end

function substances.printCode                   ( identifier          )
  tex.print ( substances.getCode                    ( identifier          ) )
end

function substances.printCodeID                 ( identifier          )
  tex.print ( substances.getCodeID                  ( identifier          ) )
end

function substances.printFull                   ( identifier          )
  tex.print ( substances.getFull                    ( identifier          ) )
end

function substances.printLabel                  ( identifier          )
  tex.print ( substances.getLabel                   ( identifier          ) )
end

function substances.printList                   ( byNumber            )
  tex.print ( substances.getList                    ( byNumber            ) )
end

function substances.printMass                   ( identifier, monomer )
  tex.print ( substances.getMass                    ( identifier, monomer ) )
end

function substances.printMolecule               ( identifier      )
  tex.print ( substances.getMolecule                ( identifier          ) )
end

function substances.printMoleculeWithCode       ( identifier          )
  tex.print ( substances.getMolecule                ( identifier          ) )
end

function substances.printMoleculeWithMass       ( identifier          )
  tex.print ( substances.getMoleculeWithMass        ( identifier          ) )
end

function substances.printMoleculeWithNumberCode ( identifier          )
  tex.print ( substances.getMoleculeWithNumberCode  ( identifier          ) )
end

function substances.printMoleculeWithNumber ( identifier          )
  tex.print ( substances.getMoleculeWithNumber  ( identifier          ) )
end

function substances.printMoleculeWithNumberYield ( identifier, yield          )
  tex.print ( substances.getMoleculeWithNumberYield  ( identifier, yield          ) )
end

function substances.printName                   ( identifier          )
  tex.print ( substances.getName                    ( identifier          ) )
end

function substances.printNumber                 ( identifier          )
  tex.print ( substances.getNumber                  ( identifier          ) )
end

function substances.printSimple                 ( identifier          )
  tex.print ( substances.getSimple                  ( identifier          ) )
end

function substances.printWithCode               ( identifier          )
  tex.print ( substances.getWithCode                ( identifier          ) )
end

function substances.printWithID                 ( identifier          )
  tex.print ( substances.getWithID                  ( identifier          ) )
end

function substances.save                        (                     )
  local identifiers                     =   { }
  for identifier, entry                 in  pairs ( substances.list )
  do
    table.insert  ( identifiers,  identifier  )
  end
  table.sort  ( identifiers,  sortByNumber  )

  local file                            =   buildFiles.create ( substances.extension  )
  if  file
  then
    for index,  identifier              in  ipairs  ( identifiers )
    do
      if  substances.list [ identifier  ].number
      then
        file:write  ( identifier  ..  "\n"  )
      end
    end
    file:close  ( )
  else
    log.error
    (
      "substances.save",
      "Could not save Substances!",
      "Listing substances might result in unexpected output."
    )
  end
end

function substances.useIt ( identifier)
  local substance, identifier           =   substances.use  ( "useIt", identifier, true, true )
end

function substances.use           ( source, identifier, withName, withNumber )
  local entry                           =   substances.list [ identifier  ]
  if  entry
  then
    --log.info({ source, "useSubstance", }, "Use Subtance with Identifier »" ..  identifier  ..  "«")
    if  entry.number  ==  nil
    then
      substances.counter                =   substances.counter + 1
      entry.number                      =   substances.counter
    end
    entry.nameUsed                      =   entry.nameUsed    or  withName
    entry.numberUsed                    =   entry.numberUsed  or  withNumber
    if  not entry.nameUsed
    then
      log.warn
      (
        { source, "useSubstance", },
        "Substance was used, but not the Name.",
        "Consider to use \\substanceFull{"..identifier.."}"
        .." to tell the reader the Name of the substance before refering to it"
      )
    end
    if  not entry.numberUsed
    and not noNumber
    then
      log.warn
      (
        { source, "useSubstance", },
        "Substance was used, but not the Number.",
        "Consider to use \\substanceFull{"..identifier.."}"
        .." to tell the reader the Name of the substance before refering to it"
      )
    end
  else
    log.fatal
    (
      { source, "useSubstance", },
      "Unknown Substance with Identifier »" ..  identifier  ..  "«"
    )
  end
  return entry, tostring  ( identifier  )
end

substances.init ( )
