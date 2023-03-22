utils                                   =   {}
function utils.reverseText(text)
  local output                          =   ""
  log.trace("reverseText", "text: »"..text.."«")
  for char                              in  text:utf8split()
  do
    log.trace("reverseText", "char: »"..char.."«")
    output                              =   char  ..  output
  end
  log.trace("reverseText", "output: »"..output.."«")
  return output
end

function utils.printReverseText(text)
  tex.print(utils.reverseText(text))
end

function utils.prepareRTL(text)
  local output                          =   ""
  for word                              in  text:gmatch("([^%s]+)")
  do
    local temp                          =   ""
    for char                            in  word:utf8split()
    do
      temp                              =   char  ..  temp
    end
    output                              =   " " .. temp  ..  output
  end
  return output
end

function utils.printRTL(text)
  tex.print(utils.prepareRTL(text))
end

function contains (tab, val)
  for index, value                      in  ipairs(tab)
  do
    if value:lower() == val:lower()
    then
      return true
    end
  end
  return false
end

function containsExact (tab, val)
  for index, value                      in  ipairs(tab)
  do
    if value == val
    then
      return true
    end
  end
  return false
end

function containsWhere (tab, val)
  for index, value                      in  ipairs(tab)
  do
    if value == val
    then
      return index
    end
  end
  return 0
end

function table.reduce (list, fn)
  local acc
  for k, v                              in  ipairs(list)
  do
    if 1 == k then
      acc                               =   v
    else
      acc                               =   fn(acc, v)
    end
  end
  return acc
end

function sum ( a, b )
  return a + b
end

function round(exact, quantum)
  local quant,frac = math.modf(exact/quantum)
  return quantum * (quant + (frac > 0.5 and 1 or 0))
end


function eval(text)
  value                                 =   load  ( "return ("  ..  text  ..  ")" )
  if  value
  and value()
  and tonumber(value())
  then
    return  tonumber(value())
  else
    return  nil
  end
end

function hypertarget  ( label )
  return "\\vadjust pre{\\hypertarget{"  .. label ..  "}{}}"  --..  percent
end

function string:split ( sep )
 local sep                              =   sep or ","
 local fields                           =   {}
 local pattern                          =   string.format ( "([^%s]+)", sep )
 self:gsub  ( pattern, function(c) fields[#fields+1] = c end  )
 return fields
end


function  utils.printNames ( names, prefix, suffix )
  for name in string.gmatch(names, "[^;]+")
  do
    tex.print((prefix or  "&" )..name..( suffix  or  tex.newline))
  end
end
