acronyms
=   {
      deprecated
      =   {
            [ "AcOEt"   ]               =   "EtOAc",
            [ "bzw"     ]               =   "beziehungsweise",
            [ "CHCl3"   ]               =   "trichlormethane",
            [ "dcm"     ]               =   "dichlormethane",
            [ "zB"      ]               =   "forExample",
            [ "zT"      ]               =   "partially",
            [ "ua"      ]               =   "unterAnderem",
            [ "zumTeil" ]               =   "partially",
          },
      extension                         =   "glsa",
      language                          =   "deu",
      list                              =   { },
      mind                              =   { },
      sections                          =   { },
      table                             =   { },
      types
      =   {
            Default                     =   0x00,
            Math                        =   0x01,
            Unit                        =   0x02,
            Angle                       =   0x03,
            Currency                    =   0x04,
            Chemical                    =   0x05,
          },
      underline                         =   false,
    }

local function  fail                ( acronym, source )
  log.error
  (
    { source, "acrfail",  },
    "cannot find acronym with identifier -»"  ..  tostring  ( acronym ) ..  "«!"
  )
  return  "¿¿"  ..  acronym ..  "??"
end

local function  getTextUnchecked    ( entry,  acronym,  texString,  pdfString,  noLink  )
  entry.uses                            =   entry.uses + 1
  if  hazLink ==  true
  and noLink  ~=  true
  then
    texString                           =   acronyms.getLinkUnchecked ( acronym,  texString )
  end
  if acronyms.underline
  then
    texString                           =   "\\underLine{"  ..  texString ..  "}"
  end
  return  "{\\texorpdfstring{"  ..  texString ..  "}{"  ..  pdfString ..  "}}"
end

function  acronyms.getChemical      ( acronym, noLink )
  local entry                           =   acronyms.getEntry ( acronym )
  if  entry
  then
    entry.uses                          =   entry.uses + 1
    return  "<" ..  identifier  ..  ">"
  else
    return  fail  ( acronym,  "acrchem" )
  end
end

function  acronyms.getDescription   ( acronym, noLink )
  local entry                           =   acronyms.getEntry ( acronym )
  if  entry
  then
    return  getTextUnchecked
            (
              entry,
              acronym,
              entry.description.native,
              entry.description.native,
              noLink
            )
  else
    return  fail  ( acronym,  "acrdesc" )
  end
end

function acronyms.use ( acronym )
  local entry                           =   acronyms.getEntry ( acronym )
  if  entry
  then
    entry.uses                          =   entry.uses + 1
  else
    return  fail  ( acronym,  "acruse" )
  end
end

function acronyms.getEntry          ( acronym, mightFail )
  log.info("acronyms.getEntry", "Try »"..acronym.."«")
  local entry                           =   acronyms.list [ acronym ]
  if entry
  then
    if  not entry.uses
    then
      local oldDebug                    =   log.stepping
      log.stepping                      =   log.stepping  or  entry.debug or  false
      local text                        =   entry.text  [ acronyms.language ] or  entry.text.eng  or  ""
      local longTEX                     =   text
      local longPDF                     =   text
      if  type  ( text  ) ==  "table"
      then
        longTEX                         =   text  [ 1 ]
        longPDF                         =   text  [ 2 ]
      end
      local shortTEX                    =   ""
      local shortPDF                    =   ""
      if  type  ( entry.data  ) ==  "table"
      then
        local kind                      =   entry.data  [ 1 ]
        local data                      =   entry.data  [ 2 ]
        if  type ( data  ) ==  "table"
        and ( not data  [ 1 ] or not  data  [ 2 ] )
        then
          data                          =   data  [ acronyms.language ] or  data.eng  or  ""
        end
        if  type ( data  ) ==  "table"
        then
          shortTEX                      =   data  [ 1 ]
          shortPDF                      =   data  [ 2 ]
        else
          shortTEX                      =   data
          shortPDF                      =   data
        end
        if      kind  ==  acronyms.types.Default
        or      kind  ==  acronyms.types.Unit
        or      kind  ==  acronyms.types.Angle
        or      kind  ==  acronyms.types.Currency
        then
          --  ok
        elseif  kind  ==  acronyms.types.Math
        then
          shortTEX                      =   "\\ensuremath{" ..  shortTEX ..  "}"
        elseif  kind  ==  acronyms.types.Chemical
        then
          shortTEX, shortPDF, sortedBy  =   chem.parseSimple  ( shortTEX  )
          entry.sortedBy                =   entry.sortedBy or sortedBy
        else
          log.fatal
          (
            "acronyms.getEntry",
            "Invalid Data-Type: " ..  tostring  ( kind  )
          )
        end
      else
        log.fatal
        (
          "acronyms.getEntry",
          "Table expected, got: " ..  tostring  ( entry.data  ) ..  " ("  ..  type  ( entry.data  ) ..  ")"
        )
      end
      entry.uses                        =   0
      entry.identifier                  =   acronym
      entry.title                       =   longTEX
      entry.short                       =   { shortTEX, shortPDF, }
      entry.long                        =   { longTEX,  longPDF,  }
      if  entry.bookmarkAs
      then
        if  type  ( entry.bookmarkAs  ) ==  "table"
        then
          entry.bookmarkAs              =   entry.bookmarkAs  [ acronyms.language ] or  entry.bookmarkAs.eng  or ""
        else
          entry.bookmarkAs              =   tostring  ( entry.bookmarkAs  )
        end
      else
        entry.bookmarkAs                =   shortTEX
      end
      if  entry.sortedBy
      then
        if  type  ( entry.sortedBy      ) ==  "table"
        then
          entry.sortedBy                =   entry.sortedBy  [ acronyms.language ] or  entry.sortedBy.eng  or ""
        else
          --log.warn("sortedBy", tostring  ( entry.sortedBy  ))
          entry.sortedBy                =   entry.sortedBy
        end
      else
        entry.sortedBy                  =   shortPDF
      end
      if  entry.description
      then
        entry.description.native        =   entry.description [ acronyms.language ] or  entry.description.eng or ""
      else
        entry.description               =   { native  = ""  }
      end
--      log.debug
--      (
--        "acronyms.getEntry",
--        "Got:",
--        entry.identifier  ..  ": "  ..  entry.description.native,
--        entry.short [ 1 ] ..  ": "  ..  entry.short [ 2 ],
--        entry.long  [ 1 ] ..  ": "  ..  entry.long  [ 2 ],
--        entry.bookmarkAs  ..  ": "  ..  entry.sortedBy
--      )
      log.stepping                      =   oldDebug
    end
  elseif  acronyms.deprecated [ acronym ]
  then
    log.warn
    (
      "acronyms.getEntry",
      "Acronym »" ..  tostring  ( acronym ) ..  "« is depricated",
      "I think,  you mean »"  ..  acronyms.deprecated [ acronym ] ..  "«…"
    )
    entry                               =   acronyms.getEntry ( acronyms.deprecated [ acronym ] )
  elseif  mightFail ~=  true
  then
    log.warn
    (
      "acronyms.getEntry",
      "Unknown Acronym »" .. tostring(acronym) ..  "«"
    )
  end
  return  entry
end

function  acronyms.getExplanation   ( acronym )
  local entry                           =   acronyms.getEntry ( acronym )
  if  entry
  then
    entry.uses                          =   entry.uses + 1
    if acronyms.underline
    then
      return  "\\underLine{"  ..  entry.short [ 1 ] ..  ": "
      ..      entry.long  [ 1 ] ..  "}"
    else
      return  entry.short [ 1 ] ..  ": "
      ..      entry.long  [ 1 ]
    end
  else
    return  fail  ( acronym,  "getExplanation"  )
  end
end

function  acronyms.getFullText      ( acronym, noLink )
  local entry                           =   acronyms.getEntry ( acronym )
  if  entry
  then
    log.info
    (
      "acronyms.getFullText",
      "Long: "..entry.long  [ 1 ]
    )
    return  getTextUnchecked
            (
              entry,
              acronym,
              entry.long  [ 1 ] ..  " ("  ..  entry.short [ 1 ] ..  ")",
              entry.long  [ 2 ] ..  " ("  ..  entry.short [ 2 ] ..  ")",
              noLink
            )
  else
    return  fail  ( acronym,  "acrfull" )
  end
end

function  acronyms.getLink          ( acronym, text )
  local entry                           =   acronyms.getEntry ( acronym )
  if  entry
  then
    entry.uses                          =   entry.uses + 1
    return  acronyms.getLinkUnchecked(acronym, text)
  else
    return  fail  ( acronym,  "acrlink" )
  end
end

function  acronyms.getLinkUnchecked ( acronym, text )
  --log.info("acronym.getLink", "reference link: »" ..  acronym .. "«")
  return  "\\protect\\hyperlink{acronym:"  ..  acronym ..  "}{"  ..  text  ..  "}"
end

function  acronyms.getLongText      ( acronym, noLink )
  local entry                           =   acronyms.getEntry ( acronym )
  if  entry
  then
    return  getTextUnchecked
            (
              entry,
              acronym,
              entry.long  [ 1 ],
              entry.long  [ 2 ],
              noLink
            )
  else
    return  fail  ( acronym,  "acrlong" )
  end
end

function  acronyms.getShortText     ( acronym, noLink )
  local entry                           =   acronyms.getEntry  ( acronym  )
  if  entry
  then
    return  getTextUnchecked  ( entry,  acronym,  entry.short [ 1 ],  entry.short [ 2 ],  noLink  )
  else
    return  fail  ( acronym,  "acrshort"  )
  end
end

function  acronyms.getText          ( acronym,  texString,  pdfString,  noLink  )
  local entry                           =   acronyms.getEntry ( acronym )
  if  entry
  then
    return  getTextUnchecked  ( entry,  acronym,  texString,          pdfString or "",          noLink  )
  else
    return  fail  ( acronym,  "acrtext" )
  end
end

function  acronyms.sort        ( this,  that )
  local a                               =   acronyms.sections [ this.section  ]
  local b                               =   acronyms.sections [ that.section  ]
  if      a.class                 ==  b.class
  then
    if    a.title:lower ( )       ==  b.title:lower ( )
    then
      if  type  ( this.sortedBy ) ==  "number"
      and type  ( that.sortedBy ) ==  "number"
      then
        --log.info("acronyms.sort", "sortedBy: "..tostring(this.sortedBy).." > "..tostring(that.sortedBy))
        return  this.sortedBy     > that.sortedBy
      else
        a                               =   tostring(this.sortedBy)
        b                               =   tostring(that.sortedBy)
        if  a:lower ( )           ==  b:lower ( )
        then
          --log.info("acronyms.sort", "identifier: »"..this.identifier.."« < »"..that.identifier.."«")
          return  this.identifier < that.identifier
        else
          --log.info("acronyms.sort", "sortedBy: »"..a.."« < »"..b.."«")
          return  a:lower()       < b:lower()
        end
      end
    else
      --log.info("acronyms.sort", "title: »"..a.title:lower().."« < »"..b.title:lower().."«")
      return    a.title:lower ( ) < b.title:lower ( )
    end
  else
    --log.info("acronyms.sort", "class: "..tostring(a.class).." < "..tostring(b.class))
    return      a.class           < b.class
  end
end

