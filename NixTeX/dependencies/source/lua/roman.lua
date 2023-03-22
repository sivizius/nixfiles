local numbers                           =   { 1000, 500, 100, 50, 10, 5, 1 }
local chars                             =   { "M", "D", "C", "L", "X", "V", "I" }

local function convertToRoman ( value )
  local result                          =   ""
  for index, number                     in  ipairs  ( numbers )
  do
    local times                         =   math.floor  ( value / number  )
--    print
--    (
--      "Value: "..tostring(value)
--      ..", index|number: "..tostring(index).."|"..tostring(number)
--      ..", times: "..tostring(times)
--    )
    result                              =   result  ..  chars [ index ]:rep ( times )
    value                               =   value % number
    for inner                           =   #numbers, index + 1, -1
    do
      local aux                         =   numbers [ inner ]
      local temp                        =   number  - aux
--      print
--      (
--        "inner: "..tostring(inner)
--        ..", value: "..tostring(value)
--        ..", aux: "..tostring(aux)
--        ..", temp: "..tostring(temp)
--      )
      if  value - temp  >=  0
      and value < number
      and value > 0
      and temp  ~=  aux
      then
--        print ( "!" ..  chars [ inner ] ..  chars [ index ] )
        result                          =   result  ..  chars [ inner ] ..  chars [ index ]
        value                           =   value - temp
        break
      end
    end
  end
  return result
end

function toroman  ( value )
  local value                           =   tonumber  ( value )
  if  not value
  or  value ~=  value
  then
    error("Input not a number")
  elseif  value   ==  math.huge
  or      -value  ==  math.huge
  then
    error("Input too large")
  else
    local value                         =   math.floor  ( value )
    if  value ==  0
    then
      return "0"
    elseif  value < 0
    then
      return  "-" ..  convertToRoman  ( -value  )
    else
      return  convertToRoman  ( value  )
    end
  end
end

if false
then
  print("9876", toroman(9876), "MMMMMMMMMDCCCLXXVI")
  print("944", toroman(944), "CMXLIV")
  print("1", toroman(1), "I")
  print("4", toroman(4), "IV")
  print("5", toroman(5), "V")
  print("6", toroman(6), "VI")
  print("9", toroman(9), "IX")
  print("501", toroman(501), "DI")
  print("1024", toroman(1024), "MXXIV")
  print("369", toroman(369), "CCCLXIX")
  if false
  then
    print(3999999, toroman(3999999)) -- these two nuke the horizontal scroll bar...
    print(4000000, toroman(4000000))
    print(math.huge, toroman(math.huge)) -- fails, which is good.
  end
  print(0, toroman(0), "0")
  print(2012, toroman(2012), "MMXII")
  print(99, toroman(99), "XCIX")
  print(999, toroman(999), "CMXCIX")
  print(1001, toroman(1001), "MI")
  print(-2012, toroman(-2012), "-MMXII")
end
