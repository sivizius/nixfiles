glossary                                =   { }

function  glossary.load             ( this  )
  local glossaryFile                    =   buildFiles.open ( this.extension  )
  if  glossaryFile
  then
    local identifierList                =   { }
    for identifier                      in  glossaryFile:lines  ( )
    do
      if  identifier  ~=  ""
      then
        table.insert  ( identifierList, identifier )
      end
    end
    glossaryFile:close  ( )

    for index, value                    in  ipairs  ( identifierList  )
    do
      --log.info("glossary.load", "value: »"..value.."«")
      local entry                       =   this.getEntry ( value )
      if  entry
      then
        table.insert  ( this.table, entry )
        --log.trace("glossary.load","entry: »"..value.."«")
      else
        log.error
        (
          "glossary.load",
          "Unknown entry »" ..  value ..  "«."
        )
      end
    end

    os.setlocale  ( os.setlocale  ( nil,"ctype" ),  "collate" )
    table.sort    ( this.table, this.sort )
  else
    log.warn
    (
      "glossary.load",
      "Cannot Open File: »" ..  buildFiles.name ( this.extension  ) ..  "«"
    )
  end
end

function glossary.loadAll ( )
  glossary.load ( acronyms  )
  glossary.load ( people    )
end

function  glossary.save             ( this, name  )
  local hasChanged                      =   false
  local output                          =   ""
  for index, value                      in  pairs ( this.mind )
  do
    local entry                         =   this.getEntry ( index )
    if  not entry
    then
      log.error
      (
        "glossary.save",
        "I was told " ..  name  ..  " »"  ..  index ..  "« does exist, but was not declared yet, but I could not find it."
      )
    else
      entry.uses                        =   entry.uses + 1
--      log.info
--      (
--        "acronyms.save",
--        "I was told " ..  name  ..  " »"  ..  index ..  "« does exist and I found it."
--      )
    end
  end
  for index, value                      in  pairs ( this.list )
  do
    if  value.uses
    and value.uses  > 0
    then
      local thisIsKnown                 =   hasChanged  or  containsExact ( this.table, index )
      hasChanged                        =   hasChanged  or  ( not thisIsKnown )
      output                            =   output  ..  index ..  "\n"
    end
  end
  if  hasChanged
  then
    local glossaryFile                  =   buildFiles.create ( this.extension  )
    glossaryFile:write  ( output  )
    glossaryFile:close  ( )
  end
end

function  glossary.saveAll  ( )
  glossary.save ( acronyms, "acronym" )
  glossary.save ( people,   "person"  )
end

--  Definitions
includeCode   ( "glossaries/acronyms" )
includeCode   ( "glossaries/people"   )
includeCode   ( "glossaries/sections" )
includeCode   ( "glossaries/styles"   )
includeCode   ( "glossaries/taxa"     )

dofile(source.."/"..acronymFile)

--  Frontend
function  acronyms.printChemical    ( acronym, noLink )
  tex.print ( acronyms.getChemical    ( acronym, noLink                           ) )
end

function  acronyms.printDescription ( acronym, noLink )
  tex.print ( acronyms.getDescription ( acronym, noLink                           ) )
end

function  acronyms.printExplanation ( acronym )
  tex.print ( acronyms.getExplanation ( acronym                                   ) )
end

function  acronyms.printFullText    ( acronym, noLink )
  tex.print ( acronyms.getFullText    ( acronym, noLink                           ) )
end

function  acronyms.printLongText    ( acronym, noLink )
  tex.print ( acronyms.getLongText    ( acronym, noLink                           ) )
end

function  acronyms.printShortText   ( acronym, noLink )
  tex.print ( acronyms.getShortText   ( acronym, noLink                           ) )
end

function  acronyms.printText        ( acronym,  texString,  pdfString,  noLink  )
  tex.print ( acronyms.getText        ( acronym,  texString,  pdfString,  noLink  ) )
end

function acronyms.printList         ( style )
  glossary.printSection ( acronyms, style,  "acronym"  )
end

function people.printList           ( style )
  glossary.printSection ( people,   style,  "person"    )
end

function  glossary.printSection     ( this, style,  name  )
  local result = glossaryStyles.getSection ( style,  this, name  )
  --log.warn ( "glossary.printSection", result )
  tex.print ( result )
end

glossary.loadAll  ( )
