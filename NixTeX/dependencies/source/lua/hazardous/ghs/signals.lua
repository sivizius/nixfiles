ghsWarnings                             =   {}
ghsWarnings["DE"]                       =   { "", "Achtung",  "Gefahr", }

function ghsSignal  ( ghs )
  return "\\textbf{" ..  ghsWarnings [ "DE"  ] [ ghs.signal  ] ..  "}"
end
