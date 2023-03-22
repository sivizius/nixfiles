chem.xray                               =   { }

function chem.xray.details ( file )
  local counter, length, verbindung
  loadLuaFile ( file  )
--  tex.print ( "{\\setlength{\\textheight}{1.1\\textheight}" )
  tex.print ( "\\clearpage{\\newgeometry{bottom=4cm}"  )

  for index1, value1 in ipairs(xtable)
  do
    length                              =   0
    for index2, value2                  in  ipairs(value1)
    do
      length                            =   length + 1
    end
    if  length  ==  1
    then
      verbindung                        =   "Verbindung"
    else
      verbindung                        =   "Verbindungen"
    end
    tex.print("\\clearpage")
    tex.print("\\expandafter\\belowpdfbookmark{\\nolink{"..verbindung.." ")
    counter                             =   0
    for index2, value2                  in  ipairs(value1)
    do
      counter = counter + 1
      if  counter == 1
      then
        if  value2  ~=  ""
        then
          tex.print("\\substance{"..value2.."}")
        end
      elseif  counter ==  length
      then
        if  value2  ~=  ""
        then
          tex.print(" und \\substance{"..value2.."}")
        end
      else
        if  value2  ~=  ""
        then
          tex.print(", \\substance{"..  value2.."}, ")
        end
      end
    end
    tex.print("}}{page:\\thepage}")
    tex.print("\\htable{p{.4\\linewidth}*{"..tostring(length).."}{|c}}{")
    tex.print("Verbindung")
    for index2, value2                  in  ipairs(value1)
    do
      if  value2  ~=  ""
      then
        tex.print("& \\substance{"..value2.."}")
      else
        tex.print("& \\hspace{4em}")
      end
    end
    tex.print(tex.newline)
    tex.print("\\midrule")

    tex.print("Summenformel")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& \\ch{"..xray[value2][1].."}" )
    end
    tex.print(tex.newline)

    tex.print("Molare Masse / \\Newunit{gram}{}\\Unit{mol}{-1}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][2] )
    end
    tex.print(tex.newline)

    tex.print("Temperatur / \\Newunit{kelvin}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][3] )
    end
    tex.print(tex.newline)

    tex.print("Wellenlänge / \\Newunit{angstroem}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][4] )
    end
    tex.print(tex.newline)

    tex.print("Kristallsystem")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][5] )
    end
    tex.print(tex.newline)

    tex.print("Raumgruppe")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& $"..xray[value2][6].."$" )
    end
    tex.print(tex.newline)

    tex.print("a / \\Newunit{angstroem}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][7] )
    end
    tex.print(tex.newline)

    tex.print("b / \\Newunit{angstroem}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][8] )
    end
    tex.print(tex.newline)

    tex.print("c / \\Newunit{angstroem}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][9] )
    end
    tex.print(tex.newline)

    tex.print("α / \\Newunit{degree}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][10] )
    end
    tex.print(tex.newline)

    tex.print("β / \\Newunit{degree}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][11] )
    end
    tex.print(tex.newline)

    tex.print("γ / \\Newunit{degree}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][12] )
    end
    tex.print(tex.newline)

    tex.print("Volumen / \\Newunit{angstroem}{3}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][13] )
    end
    tex.print(tex.newline)

    tex.print("ρ / \\Newunit{kilogram}{}\\Unit{litre}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][14] )
    end
    tex.print(tex.newline)

    tex.print("$F(000)$")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][15] )
    end
    tex.print(tex.newline)

    tex.print("Kristallgröße / \\Newunit{millimetre}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][16] )
    end
    tex.print(tex.newline)

    tex.print("Z")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][17] )
    end
    tex.print(tex.newline)

    tex.print("Max. Transmission")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][18] )
    end
    tex.print(tex.newline)

    tex.print("Min. Transmission")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][19] )
    end
    tex.print(tex.newline)

    tex.print("μ / \\Newunit{millimetre}{-1}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][20] )
    end
    tex.print(tex.newline)

    tex.print("Θ-Bereich / \\Newunit{degree}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][21] )
    end
    tex.print(tex.newline)

    tex.print("Limiting Indices")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][22] )
    end
    tex.print(tex.newline)
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][23] )
    end
    tex.print(tex.newline)
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][24] )
    end
    tex.print(tex.newline)

    tex.print("Reflektionen \\mbox{gesammelt/einzigartig}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][25] )
    end
    tex.print(tex.newline)

    tex.print("Vollständigkeit zu Θ\\textsubscript{max} / \\Newunit{percent}{}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][26] )
    end
    tex.print(tex.newline)

    tex.print("Beschränkungen / Parameter")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][27] )
    end
    tex.print(tex.newline)

    tex.print("$R_{int}$")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][28] )
    end
    tex.print(tex.newline)
    tex.print("$R_1, \\omega R_2\\ [I\\leq 2\\cdot\\sigma(I)]$")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][29] )
    end
    tex.print(tex.newline)

    tex.print("$R_1, \\omega R_2$ (alle Daten)")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][30] )
    end
    tex.print(tex.newline)

    tex.print("Anpassungsgüte $S$")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][31] )
    end
    tex.print(tex.newline)
    tex.print("Δρ / e\\textsuperscript{$-$}\\Unit{angstroem}{-3}")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][32] )
    end
    tex.print(tex.newline)

    tex.print("Absoluter Strukturparameter")
    for index2, value2                  in  ipairs(value1)
    do
      tex.print("& "..xray[value2][33] )
    end
    tex.print(tex.newline)

    tex.print("}{Kristall-, Sammlungs- und Verfeinerungsdetails von Verbindung \\mbox{")
    counter                             =   0
    for index2, value2                  in  ipairs  ( value1  )
    do
      counter                           =   counter + 1
      if  counter ==  1
      then
        if  value2  ~=  ""
        then
          if  counter ==  length
          then
            tex.print("\\substance{"..value2.."}.")
          else
            tex.print("\\substance{"..value2.."}")
          end
        end
      elseif  counter ==  length
      then
        if  value2  ~=  ""
        then
          tex.print(" und \\substance{"..value2.."}.")
        end
      else
        if  value2  ~=  ""
        then
          tex.print(", \\substance{"..value2.."}, ")
        end
      end
    end
    tex.print("}}{}")
  end
  tex.print("\\restoregeometry}")
end
