colour
=   {
      html
      =   {
            [ "white"             ]     =   "FFFFFF",
            [ "black"             ]     =   "000000",
            [ "darkgray"          ]     =   "333333",
            [ "gray"              ]     =   "5D5D5D",
            [ "lightgray"         ]     =   "999999",
            [ "green"             ]     =   "C2E15F",
            [ "orange"            ]     =   "FDA333",
            [ "purple"            ]     =   "D3A4F9",
            [ "red"               ]     =   "FB4485",
            [ "blue"              ]     =   "6CE0F1",
            [ "darktext"          ]     =   "414141",
            [ "awesome-emerald"   ]     =   "00A388",
            [ "awesome-skyblue"   ]     =   "0395DE",
            [ "awesome-red"       ]     =   "DC3522",
            [ "awesome-pink"      ]     =   "EF4089",
            [ "awesome-orange"    ]     =   "FF6138",
            [ "awesome-nephritis" ]     =   "27AE60",
            [ "awesome-concrete"  ]     =   "95A5A6",
            [ "awesome-darknight" ]     =   "131A28",
          }
    }

function colour.texDefineAll  ( )
  for name, value                       in  pairs ( colour.html )
  do
    tex.print("\\definecolor{"..name.."}{HTML}{"..value.."}")
  end
end
