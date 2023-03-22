values
=   {
      prefixes
      =   {
            "yotta", "zetta", "exa",  "peta", "tera", "giga", "mega", "kilo", "hecto", "deca",
            "deci", "centi",  "milli",  "micro",  "nano", "pico", "femto", "atto", "zepto", "yocto",
          },
    }

local function formatEntry  ( entry,  unit, wantSpace )
  --> (
  --    formatedUnit: string,
  --    isCurrency:   bool,
  --  )
  unit                                  =   acronyms.getShortText ( unit  )
  if      not wantSpace
  or      entry.attributes  ==  attributes.Angle
  then
    --  x°/′/″ or any consecutive unit
    return  ""    ..  unit, false
  elseif  entry.attributes  ==  attributes.Unit
  then
    --  x kg/m/s
    return  "\\," ..  unit, false
  elseif  entry.attributes  ==  attributes.Currency
  then
    --  x €
    --  you might want to format money yourself,
    --  e.g. »€ 13.37«, »23.42 CHF«, »3 €, 5 ct«.
    return  "\\," ..  unit, true
  else
    --  x Users
    return  "~"   ..  unit, false
  end
end

local function formatUnit ( unit, wantSpace )
  --> (
  --    formatedUnit: string,
  --    isCurrency:   bool,
  --  )
  local entry                           =   acronyms.list [ unit  ]
  if  entry
  then
    return  formatEntry ( entry,  unit, wantSpace )
  else
    local unitPrefix                    =   ""
    for index, prefix                   in  ipairs  ( values.prefixes )
    do
      local match                       =   unit:match  ( prefix  ..  "(%a+)" )
      if  match
      then
        unit                            =   match
        unitPrefix                      =   acronyms.getShortText ( prefix  )
        break
      end
    end
    if      unit == "gram"
    then
      unit                              =   acronyms.getText  ( "kilogram",     "g",    "g",    false )
    elseif  unit == "calorie"
    then
      unit                              =   acronyms.getText  ( "kilocalorie",  "cal",  "cal",  false )
    else
      local entry                       =   acronyms.list [ unit  ]
      if  entry
      then
        unit                            =   formatEntry ( entry,  unit, false )
      else
        unit                            =   "(¿"  ..  unit  ..  "?)"
      end
    end
    if  wantSpace
    then
      return  "\\," ..  output  ..  unit
    else
      return  output  ..  unit
    end
  end
end

function values.getNumber   ( value )
  local output                          =   "{" ..  value ..  "}"
  local States
  =   {
        Sign                            =   1,
        Integer                         =   2,
        Decimal                         =   3,
        ExponentSign                    =   4,
        ExponentValue                   =   5,
        Constant                        =   6,
        Fraction                        =   7,
      }

  local constant                        =   ""
  local exponent                        =   0
  local exponentSign                    =   ""
  local multiplier                      =   0.1
  local sign                            =   ""
  local value                           =   0

  local state                           =   States.Sign
  for char                              in  value:utf8split ( )
  do
    if      state ==  States.Sign
    then
      if      char  ==  "+"
      then
        if      sign  ==  ""
        then
          sign                          =   "+"
        elseif  sign  ==  "−"
        then
          sign                          =   "∓"
        else
          break
        end
      elseif  char  ==  "-"
      then
        if      sign  ==  ""
        then
          sign                          =   "−"
        elseif  sign  ==  "+"
        then
          sign                          =   "±"
        else
          break
        end
      elseif  char  ==  "±"
      or      char  ==  "∓"
      then
        sign                            =   char
      elseif  char  >=  "0" and char  <=  "9"
      then
        value                           =   char:byte ( ) - 48
        state                           =   States.Integer
      elseif  char  >=  "A" and char  <=  "Z"
      or      char  >=  "a" and char  <=  "z"
      then
        constant                        =   char
        state                           =   States.Constant
      elseif  char  ==  "."
      or      char  ==  ","
        state                           =   States.Decimal
      else
        break
      end
    elseif  state ==  States.Integer
    then
      if      char  >=  "0" and char  <=  "9"
      then
        value                           =   value * 10  + char:byte ( ) - 48
      elseif  char  ==  "."
      or      char  ==  ","
        state                           =   States.Decimal
      elseif  char  ==  "E"
      or      char  ==  "e"
        state                           =   States.ExponentSign
      elseif  char  ==  "*"
      or      char  ==  "·"
      then
        value                           =   sign  ..  tostring  ( value )
        constant                        =   ""
        state                           =   States.Constant
      else
        break
      end
    elseif  state ==  States.Decimal
    then
      if      char  >=  "0" and char  <=  "9"
      then
        value                           =   value + ( char:byte ( ) - 48  ) * multiplier
        multiplier                      =   multiplier  / 10
      elseif  char  ==  "E"
      or      char  ==  "e"
        state                           =   States.ExponentSign
      elseif  char  ==  "*"
      or      char  ==  "·"
      then
        value                           =   sign  ..  tostring  ( value )
        constant                        =   ""
        state                           =   States.Constant
      else
        break
      end
    elseif  state ==  States.ExponentSign
    then
      if      char  ==  "+"
      then
        exponentSign                    =   "+"
      elseif  char  ==  "-"
      then
        exponentSign                    =   "−"
      elseif  char  >=  "0" and char  <=  "9"
      then
      else
        break
      end
    else
      log.fatal
      (
        "values.getNumber",
        "Not Implemented Yet"
      )
      break
    end
  end
  return  output
end

function values.getUnit     ( unit  )
  local output                          =   ""
  local wantSpace                       =   true
  for unit                              in  unit:gmatch ( "([^*]+)" )
  do
    local exponent                      =   ""
    unit, exponent                      =   value:match ( "(%a+)([+-]%d+)"  )

    if  not wantSpace
    then
      output                            =   output  ..  "·"
    end
    output                              =   output  ..  formatUnit  ( unit, wantSpace )
    wantSpace                           =   false

    exponent                            =   tonumber  ( exponent  )
    if  exponent
    then
      output                            =   output  ..  "^{"  ..  tostring  ( exponent  ) ..  "}"
    end
  end
end

function values.getValue    ( precision,  value,  unit  )
  local sign, number, exponent          =   values.getNumber  ( value )
  local unit                            =   values.getUnit    ( unit  )
  local output                          =   sign  or  ""  ..  number
  if  exponent
  then
    return  output  ..  "·10^{" ..  exponent  ..  "}"
  else
    return  output
  end
end

function values.printUnit   ( unit  )
  tex.print   ( values.getUnit  ( unit                      ) )
end

function values.printValue  ( precision,  value,  unit  )
  tex.print   ( values.getValue ( precision,  value,  unit  ) )
end
