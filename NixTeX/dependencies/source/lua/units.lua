units
=   {
      [ ""    ]                         =       1,
      [ "bp"  ]                         =     352.77777777778,
      [ "cc"  ]                         =    4512,
      [ "cm"  ]                         =   10000,
      [ "dd"  ]                         =     376,
      [ "in"  ]                         =   25400,
      [ "mm"  ]                         =    1000,
      [ "nc"  ]                         =    4500,
      [ "nd"  ]                         =     375,
      [ "pc"  ]                         =    4218,
      [ "pt"  ]                         =     351.46,
      [ "sp"  ]                         =       0.00536,
    }

function  convert   ( value,  toUnit, mul,  add )
  local fromUnit
  if ( not mul )
  then
    mul                                 =   1
  end
  if ( not add )
  then
    add                                 =   0
  end
  value, fromUnit                       =   value:match  ( "([0-9e+-.]+)(.*)"  )
  value                                 =   tonumber  ( value )
  if  value
  and fromUnit
  and units [ fromUnit  ]
  and units [ toUnit    ]
  then
    local mul                           =   tonumber  ( mul )
    local add                           =   tonumber  ( add )
    local factor                        =   units [ fromUnit  ] / units [ toUnit  ]
    local length                        =   tostring  ( ( value * mul + add ) * factor  ) ..  toUnit
    log.debug
    (
      "convert",
      "Conversion Parameters:",
      "  factor: "  ..  tostring  ( factor  ),
      "  input:  "  ..  tostring  ( value   ),
      "  length: "  ..  length
    )
    return length
  else
    log.fatal
    (
      "convert",
      "Cannot Parse Length:",
      "  value:     »" ..  tostring  ( value    ) ..  "«",
      "  fromUnit:  "  ..  tostring  ( fromUnit ),
      "  fromUnit:  "  ..  tostring  ( units[fromUnit] ),
      "  toUnit:    "  ..  tostring  ( toUnit   ),
      "  toUnit:    "  ..  tostring  ( units[toUnit]   ),
      "  mul:       "  ..  tostring  ( mul      ),
      "  add:       "  ..  tostring  ( add      )
    )
  end
end
