nfpaOthers
=   {
      "",
      "\\nfpaAsphyxiant",
      "\\nfpaNoWater",
      "\\nfpaOxidiser",
      "\\nfpaAcid",
      "\\nfpaAlkaline",
      "\\nfpaBioHazard",
      "\\nfpaCryogenic",
      "\\nfpaEcoHazard",
      "\\nfpaEtching",
      "\\nfpaExplosive",
      "\\nfpaHot",
      "\\nfpaRadioactive",
      "\\nfpaToxic",
    }

nfpaNone                                =   0x00
nfpaAsphyxiant                          =   0x01
nfpaNoWater                             =   0x02
nfpaOxidiser                            =   0x03
nfpaAcid                                =   0x04
nfpaAlkaline                            =   0x05
nfpaBioHazard                           =   0x06
nfpaCorrosive                           =   0x07
nfpaCryogenic                           =   0x08
nfpaEcoHazard                           =   0x09
nfpaExplosive                           =   0x0a
nfpaHot                                 =   0x0b
nfpaRadioactive                         =   0x0c
nfpaToxic                               =   0x0d

function nfpaData ( hazardousData )
  if  hazardousData.nfpa            ~=  nil
  and type  ( hazardousData.nfpa  ) ==  "table"
  then
    return  {
              fire                      =   hazardousData.nfpa.fire     or  0,
              health                    =   hazardousData.nfpa.health   or  0,
              reaction                  =   hazardousData.nfpa.reaction or  0,
              other                     =   nfpaOthers  [ hazardousData.nfpa.other  ] or  hazardousData.nfpa.other  or  "",
            }
  else
    return nil
  end
end

function nfpaPictograms ( nfpa, pictograms  )
  if  nfpa  ~=  nil
  then
    table.insert
    (
      pictograms,
      "\\nfpaDiamond[\\@HazardousPictogramSize]"
      ..  "{" ..  tostring  ( nfpa.fire     ) ..  "}"
      ..  "{" ..  tostring  ( nfpa.health   ) ..  "}"
      ..  "{" ..  tostring  ( nfpa.reaction ) ..  "}"
      ..  "{" ..  tostring  ( nfpa.other    ) ..  "}"
    )
  end
end
