enumerations
=   {
      prefix                            =   "",
      counter                           =   0,
    }

local function replace  ( value )
  return  value
  :gsub ( "\\arabic %*",  "\\noexpand\\EnumArabic"  )
  :gsub ( "\\arabic",     "\\noexpand\\EnumArabic"  )
  :gsub ( "\\alph %*",    "\\noexpand\\EnumAlphaL"  )
  :gsub ( "\\alph",       "\\noexpand\\EnumAlphaL"  )
  :gsub ( "\\Alph %*",    "\\noexpand\\EnumAlphaU"  )
  :gsub ( "\\Alph",       "\\noexpand\\EnumAlphaU"  )
  :gsub ( "\\roman %*",   "\\noexpand\\EnumRomanL"  )
  :gsub ( "\\roman",      "\\noexpand\\EnumRomanL"  )
  :gsub ( "\\Roman %*",   "\\noexpand\\EnumRomanU"  )
  :gsub ( "\\Roman",      "\\noexpand\\EnumRomanU"  )
end

function enumerations.init  ( options,  prefix  )
  enumerations.counter                  =   0
  local result                          =   ""
  for option                            in  ( options ..  "," ):gmatch  ( "(.-)," )
  do
    local key, value                    =   option:match  ( "(.-)=(.*)" )
    if key  ==  "label"
    then
      result                            =   replace ( value )
      enumerations.prefix               =   ""
      break
    elseif key  ==  "label*"
    then
      result                            =   replace ( value )
      enumerations.prefix               =   prefix
      break
    end
  end
--  log.error
--  (
--    "enumerations.init",
--    "Result: »" ..  result  ..  "«"
--  )
  tex.print ( result  )
end

function enumerations.item        ( )
  enumerations.counter                  =   enumerations.counter  + 1
--  log.error
--  (
--    "enumerations.item",
--    "Counter After: " ..  tostring  ( enumerations.counter  )
--  )
end

function enumerations.arabic      ( )
  tex.print ( enumerations.prefix ..  tostring  ( enumerations.counter  ) )
end

function enumerations.romanLower  ( )
  tex.print ( enumerations.prefix ..  toroman   ( enumerations.counter  ):lower ( ) )
end

function enumerations.romanUpper  ( )
  tex.print ( enumerations.prefix ..  toroman   ( enumerations.counter  ) )
end

function enumerations.alphaLower  ( )
  --log.error
  --(
  --  "enumerations.alphaLower",
  --  "Counter: " ..  tostring  ( enumerations.counter  ),
  --  "ASCII:   " ..  tostring  ( 96  + enumerations.counter  ),
  --  "Char:    »" ..  string.char ( 96  + enumerations.counter  ) ..  "«"
  --)
  tex.print ( enumerations.prefix ..  string.char ( 96  + enumerations.counter  ) )
end

function enumerations.alphaUpper  ( )
  tex.print ( enumerations.prefix ..  string.char ( 64  + enumerations.counter  ) )
end
