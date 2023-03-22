local unitPrefixes
=   {
      "yotta", "zetta", "exa",  "peta", "tera", "giga", "mega", "kilo", "hecto", "deca",
      "deci", "centi",  "milli",  "micro",  "nano", "pico", "femto", "atto", "zepto", "yocto",
    }
function unit2string ( unit, space )
  local entry                           =   acronyms.getEntry ( unit, true )
  if  entry
  then
    if      not space
    or      entry.data  [ 1 ] ==  acronyms.types.Angle
    then
      --  x°/′/″
      return  "\\acrshort{"..unit .."}"
    elseif  entry.data  [ 1 ] ==  acronyms.types.Unit
    then
      --  x kg/m/s
      return  "\\,\\acrshort{"..unit .."}"
    elseif  entry.data  [ 1 ] ==  acronyms.types.Currency
    then
      --  x € or $ x or x CHF
      return  "\\,\\acrshort{"..unit .."}"
    else
      --  x Users
      return  "~\\acrshort{"..unit .."}"
    end
  else
    local output                        =   ""
    for index, prefix                   in  ipairs  ( unitPrefixes  )
    do
      local match                        =   unit:match  ( prefix  ..  "(%a+)" )
      if  match
      then
        unit                            =   match
        output                          =   "\\acrshort{" ..  prefix  ..  "}"
        break
      end
    end
    if      unit == "gram"
    then
      if space
      then
        return  "\\," ..  output  ..  "\\acrtext[kilogram]{g}"
      else
        return  output  ..  "\\acrtext[kilogram]{g}"
      end
    elseif  unit == "calorie"
    then
      if space
      then
        return  "\\,"..output.."\\acrtext[kilocalorie]{kcal}"
      else
        return  output.."\\acrtext[kilocalorie]{kcal}"
      end
    else
      local entry                         =   acronyms.getEntry ( unit  )
      if  entry
      then
        if      not space
        or      entry.data  [ 1 ] ==  acronyms.types.Angle
        then
          --°, ′, ″
          return  output.."\\acrshort{"..unit.."}"
        elseif  entry.data  [ 1 ] ==  acronyms.types.Unit
        then
          --kg, m, s
          return  "\\,"..output.."\\acrshort{"..unit.."}"
        else
          --Einwohner
          return  "~"..output.."\\acrshort{"..unit.."}"
        end
      elseif    not space
      then
        return output.."<\\acrshort{"..unit.."}>"
      else
        return "\\,"..output.."<\\acrshort{"..unit.."}>"
      end
    end
  end
end

function unit ( inUnit, inExponent, cdot )
  if cdot
  then
    cdot                                =   "\\cdot"
  else
    cdot                                =   ""
  end
  local output
  =   "\\ensuremath{" ..  cdot
  ..  "\\text{" ..  unit2string ( inUnit, true  ) ..  "}"
  sign                                  =   inExponent:gsub ( " ",  ""  ):utf8char  ( )
  exponent                              =   load("return ("..inExponent..")")
  if    exponent                    ~=  nil
  and   exponent  ( )               ~=  nil
  and   tonumber  ( exponent  ( ) ) ~=  nil
  then
    if      exponent ( ) < 0
    then
      exponent                        =   -exponent ( )
      sign                            =   "-"
    elseif  sign  ==  "+"
    then
      exponent                        =   exponent  ( )
    else
      exponent                        =   exponent  ( )
      sign                            =   ""
    end
    output                            =   output.."^{"..sign.."\\text{"..exponent.."}}}"
  else
    if sign == "+"
    then
      sign                            =   "\\plus"
    elseif sign == "-"
    then
      sign                            =   "\\minus"
    elseif sign == "±"
    then
      sign                            =   "\\pm"
    elseif sign == "∓"
    then
      sign                            =   "\\mp"
    else
      sign                            =   ""
    end
    output                            =   output.."^{"..sign..inExponent.."}}"
  end
  --log.debug("unit",output)
  tex.print(output)
end

function physical ( inDecimals, inValue, inExponent, inUnit, unitExponent )
  if  inUnit:match        ( "[(),.;:)]"   )
  or  unitExponent:match  ( "[(),.;:)%a]" )
  then
    log.error
    (
      "physical",
      "Physical takes one Optional and four Mandatory Arguments:",
      "  [decimals] value value-exponent unit unit-exponent",
      "Perhabs you forgot one or two {} somewhere? Have a look:",
      "decimals:        »"  ..  inDecimals    ..  "«",
      "value:           »"  ..  inValue       ..  "«",
      "value-exponent:  »"  ..  inExponent    ..  "«",
      "unit:            »"  ..  inUnit        ..  "«",
      "unit-exponent:   »"  ..  unitExponent  ..  "«"
    )
  end
  if inValue == ""
  then
    log.error
    (
      "physical",
      "Got no value.",
      "Do you forgot it or do you mean \\Newunit or \\Unit?"
    )
  end
  value                                 =   load("return ("..inValue..")")
  output                                =   ""
  if value and value() and tonumber(value())
  then
    sign                                =   inValue:gsub(" ", ""):utf8char  ( )
    if value()<0
    then
      value                             =   -value()
      sign                              =   "-"
    else
      value                             =   value()
    end
    if sign == "+"
    then
      output                            =   output.."\\plus"
    elseif sign == "-"
    then
      output                            =   output.."\\minus"
    elseif sign == "±"
    then
      output                            =   output.."\\pm"
    elseif sign == "∓"
    then
      output                            =   output.."\\mp"
    end
    decimals                            =   load("return ("..inDecimals..")")
    if value == false
    then
    elseif decimals and decimals() and tonumber(decimals())
    then
      if decimals() >= 0
      then
        output                          =   output..string.format(percent.."."..decimals().."f", value)
      else
        uncertainty                     =   -decimals()
        if      ( uncertainty < 1 )
        then
          decimals                      =   0
          while ( uncertainty < 1 )
          do
            decimals                    =   decimals + 1
            uncertainty                 =   uncertainty * 10
          end
          uncertainty                   =   math.floor(uncertainty+0.5)
          if ( uncertainty == 10 )
          then
            decimals                    =   decimals - 1
            uncertainty                 =   "(1)"
          else
            uncertainty                 =   "("..uncertainty..")"
          end
          output                        =   output..string.format(percent.."."..decimals.."f", value).."\\,"..uncertainty
        else
          decimals                      =   1
          while ( uncertainty > 10 )
          do
            decimals                    =   decimals * 10
            uncertainty                 =   uncertainty / 10
          end
          output                        =   (math.floor(value / decimals + 0.5) * decimals).."\\,("..(math.floor(uncertainty+0.5) * decimals)..")"
        end
      end
    else
      output                            =   output..value
    end
  elseif inValue == ""
  then
    value                               =   false
  else
    output                              =   output.."\\noexpand"..inValue
  end
  output                                =   "\\ensuremath{\\text{"..output.."}"
  exponent                              =   load("return ("..inExponent..")")
  if exponent and exponent() and tonumber(exponent())
  then
    sign                                =   inExponent:gsub(" ", ""):utf8char  ( )
    if exponent()<0
    then
      exponent                          =   -exponent()
      sign                              =   "-"
    else
      exponent                          =   exponent()
    end
    if sign == "+"
    then
      sign                              =   "\\plus"
    elseif sign == "-"
    then
      sign                              =   "\\minus"
    elseif sign == "±"
    then
      sign                              =   "\\pm"
    elseif sign == "∓"
    then
      sign                              =   "\\mp"
    else
      sign                              =   ""
    end
    if value ~= false
    then
      output                            =   output.."\\text{·}"
    end
    output                              =   output.."\\text{10}^{"..sign.."\\text{"..exponent.."}}"
  end
  if not ( inUnit == "" )
  then
    output                              =   output.."\\text{"..unit2string ( inUnit, true ).."}"
    exponent                            =   load("return ("..unitExponent..")")
    if exponent and exponent() and tonumber(exponent())
    then
      sign                              =   unitExponent:gsub(" ", ""):utf8char  ( )
      if exponent()<0
      then
        exponent                        =   -exponent()
        sign                            =   "-"
      else
        exponent                        =   exponent()
      end
      if sign == "+"
      then
        sign                            =   "\\plus"
      elseif sign == "-"
      then
        sign                            =   "\\minus"
      elseif sign == "±"
      then
        sign                            =   "\\pm"
      elseif sign == "∓"
      then
        sign                            =   "\\mp"
      else
        sign                            =   ""
      end
      output                            =   output.."^{"..sign.."\\text{"..exponent.."}}"
    end
  end
  output                                =   "{" ..  output.."}}"
  tex.print(output)
end
