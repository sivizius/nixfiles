function ghsEUHazards ( ghs )
  local options                         =   ""
  if next ( ghs.euHazards )
  then
    for index, value                    in  ipairs  ( ghs.euHazards )
    do
      if      type  ( value )   ==  "number"
      then
        if value < 100
        then
          value                         =   "0" ..  tostring  ( value     )
        else
          value                         =   tostring  ( value     )
        end
      elseif  type  ( value )   ==  "table"
      then
        if      value.substance ~=  nil
        then
          options                       =   options ..  "substance="   ..  value.organs
        end
        value                           =   tostring  ( value.id  )
      end
      if options == ""
      then
        tex.print("\\ghs{euh}{"..value.."}")
      else
        tex.print("\\ghs["..options.."]{euh}{"..value.."}")
      end
    end
    tex.print(tex.newline)
  end
end
