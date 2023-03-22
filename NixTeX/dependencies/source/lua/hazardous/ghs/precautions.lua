function ghsPrecautions ( ghs )
  local options                         =   ""
  if next(hazardousData.ghs.precautions)
  then
    for index, value                    in  ipairs(ghs.precautions)
    do
      if      type  ( value ) ==  "number"
      then
        value                           =   tostring  ( value     )
      elseif  type  ( value ) ==  "table"
      then
        if      value.text    ~=  nil
        then
          options                       =   options ..  "text="           ..  value.text
        end
        if      value.dots    ~=  nil
        then
          options                       =   options ..  "dots="           ..  value.dots
        end
        if      value.tempC   ~=  nil
        then
          options                       =   options ..  "C-termperature=" ..  value.tempC
        elseif  value.tempF   ~=  nil
        then
          options                       =   options ..  "F-termperature=" ..  value.tempF
        end
        if      value.massKG  ~=  nil
        then
          options                       =   options ..  "kg-mass="        ..  value.massKG
        elseif  value.massLBS ~=  nil
        then
          options                       =   options ..  "lbs-mass="       ..  value.massLBS
        end
        value                           =   tostring  ( value.id  )
      end
      if options == ""
      then
        tex.print("\\ghs{p}{"..value.."}")
      else
        tex.print("\\ghs["..options.."]{p}{"..value.."}")
      end
    end
  end
end
