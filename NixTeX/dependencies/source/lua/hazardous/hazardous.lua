includeCode ( "hazardous/iso7010" )

hazardousADR                            =   false
hazardousADRplate                       =   false
hazardousGHS                            =   true
hazardousISO7010                        =   false
hazardousNFPA704                        =   false

hazardous                               =   { }
hazardous [ "blueprint" ]
=   {
      name                              =
      {
        deu                             =   "",
        eng                             =   "",
      },
      --  empty values like "" and {} are all optional and should be either removed or filled
      label                             =   "",
      physical
      =   {
            formula                     =   {}, --  Formula
            density                     =   0,  --  g·ml⁻¹
            nD20                        =   0,  --
            melting                     =   0,  --  °C
            boiling                     =   0,  --  °C
            decompose                   =   0,  --  °C
          },
      ghs
      =   {
            hazards                     =   {},
            euHazards                   =   {},
            precautions                 =   {},
            pictograms                  =   { ghsExplosive, ghsFlame, ghsOFlame, ghsBottle, ghsAcid, ghsSkull, ghsExclam, ghsHealth, ghsPollu, },
            --  not optional:
            signal                      =   ghsDanger,
          },
      iso7010
      =   {
            warnings                    =   { 10, },
          },
      nfpa
      =   {
            fire                        =   0,
            health                      =   0,
            reaction                    =   0,
            other                       =   nfpaNone,
          },
      ecNumber                          =   "",                                 --  either  European Community number
      ufIdentifier                      =   "XXXX-XXXX-XXXX-XXXX",              --  or      Unique Formula Identifier
      casNumber                         =   "",                                 --  and     Chemical Abstracts Service identifier
      --  Accord européen relatif au transport international des marchandises Dangereuses par Route (ADR)
      --  Règlement concernant le transport international ferroviaire de marchandises Dangereuses (RID)
      unNumber                          =   1337,
      kemler                            =   -123,
      hazardClass
      =   {
            {
              class                     =   hazardClassExplosive,
              subClass                  =   1,                                  --  only if applicable, e.g. not 3 or 8
              compatibility             =   hazardCompatibilityX,               --  compatibility group, only for explosives
              contents                  =   "",                                 --  material,         only radioactive material
              activity                  =   0,                                  --  Bq·kg⁻¹,          only radioactive material, use \hazardousMassAndIndex
              index                     =   0,                                  --  transport index,  only radioactive material, use \hazardousMassAndIndex
            },
          },
      source                            =   "gestis",                           -- replace with actual source or list of sources: { "one", "two", … }
      update                            =   "2020-02-17",
    }

function getHazardous ( name )
  local result
  =   hazardous [ name  ]
  or  {
        name                            =
        {
          deu                           =   "Unbekannter Gefahrenstoff: »"..name.."«",
          eng                           =   "Unknown Hazardous Substance: »"..name.."«",
        },
        ghs                             =   {},
        iso7010                         =   {},
        nfpa                            =   {},
        source                          =   {},
        update                          =   "never",
        unknown                         =   true
      }

  --  name
  if      result.name                     ~=  nil
  and     result.name.deu                 ~=  nil
  and     result.name.deu                 ~=  ""
  then
    result.title                        =   result.name.deu
  elseif  result.name                     ~=  nil
  and     result.name.eng                 ~=  nil
  and     result.name.eng                 ~=  ""
  then
    result.title                        =   result.name.eng
  else
    result.title                        =   "Unnamed Hazardous Substance"
  end

  result.label                          =   result.label    or  ""
  result.physical                       =   result.physical or  {}

  if      result.ufIdentifier             ==  nil
  or      result.ufIdentifier             ==  ""
  then
    --  European Community number
    if      result.ecNumber               ==  nil
    or      result.ecNumber               ==  ""
    then
      result.ecNumber                   =   "—"
    end
    --  Chemical Abstracts Service identifier
    if      result.casNumber              ==  nil
    or      result.casNumber              ==  ""
    then
      result.casNumber                  =   "—"
    end
  end

  --  source
  if      result.source                   ==  nil
  then
    log.warn
    (
      "gethazardousData",
      "›" .. result.name .. "‹ does not have a source!"
    )
    result.source                       =   {}
  end

  --  date of last update
  if      result.update                   ==  nil
  then
    log.warn
    (
      "gethazardousData",
      "please update ›" .. result.name .. "‹!"
    )
    result.update                       =   "never"
  end

  result                                =   adrData     ( result  )
  result.ghs                            =   ghsData     ( result  )
  result.iso7010                        =   iso7010data ( result  )
  result.nfpa                           =   nfpaData    ( result  )

  return result
end

function hazardousMolar ( list  )
  local formula                         =   ""
  local mass                            =   0
  local previous                        =   0
  for index, value                      in  ipairs  ( list )
  do
    if      type  ( value ) ==  "number"
    then
      formula                           =   formula ..  tostring  ( value )
      if  previous  ~=  0
      then
        mass                            =   mass  + previous  * value
        previous                        =   0
      end
    elseif  type  ( value ) ==  "string"
    then
      mass                              =   mass  + previous
      if  chemicalElements  [ value ] ~=  nil
      then
        formula                         =   formula ..  value
        previous                        =   chemicalElements  [ value ].mass
      elseif  value ==  "."
      or      value ==  "-"
      then
        formula                         =   formula ..  value
        previous                        =   0
      else
        log.error
        (
          "hazardousMolar",
          "Unknown Chemical Element ›"  ..  value ..  "‹"
        )
      end
    elseif  type  ( value ) ==  "table"
    then
      mass                              =   mass  + previous
      local resultFormula, resultMass   =   hazardousMolar(value)
      formula                           =   formula ..  "(" ..  resultFormula ..  ")"
      previous                          =   resultMass
    else
      log.error
      (
        "hazardousMolar",
        "Unexpected value ›"  ..  tostring  ( value ) ..  "‹ of type ›" ..  type  ( value ) ..  "‹"
      )
    end
  end
  return formula, mass + previous
end

function hazardousPhysicals(hazPurity, hazardousData)
  local result                          =   ""
  if  hazPurity
  then
    result                              =   ", "
  end
  if  hazardousData.physical.formula            ~=  nil
  and type  ( hazardousData.physical.formula  ) ==  "table"
  and #hazardousData.physical.formula           >   0
  then
    local formula, mass                 =   hazardousMolar(hazardousData.physical.formula)
    result                              =   result  ..  "\\ch{"..formula.."}, "
    result                              =   result  ..  "\\Physical[2]{"..tostring(mass).."}{}{gram}{}"
    result                              =   result  ..  "\\Unit{mol}{-1}"
  end
  if  hazardousData.physical.density            ~=  nil
  then
    if  result                ~=  ""
    then
      result                            =   result  ..  ", "
    end
    result                              =   result  ..  "\\Physical[2]{"..tostring(hazardousData.physical.density).."}{}{gram}{}"
    result                              =   result  ..  "\\Unit{millilitre}{-1}"
  end
  if  hazardousData.physical.nD20               ~=  nil
  then
    if  result                ~=  ""
    then
      result                            =   result  ..  ", "
    end
    result                              =   result  ..  "\\acrshort{nD20}~"
    result                              =   result  ..  "\\Physical[4]{"..tostring(hazardousData.physical.nD20).."}{}{}{}"
  end
  if  hazardousData.physical.pH                 ~=  nil
  and   tostring(hazardousData.physical.pH) ~= nil
  then
    if  result                ~=  ""
    then
      result                            =   result  ..  ", "
    end
    result                              =   result  ..  "pH~"
    result                              =   result  ..  "\\Physical[2]{"..tostring(hazardousData.physical.pH).."}{}{}{}"
  end
  if  hazardousData.physical.melting            ~=  nil
  then
    if  result                ~=  ""
    then
      result                            =   result  ..  ", "
    end
    result                              =   result  ..  "\\acrshort{meltingTemperature}~"
    result                              =   result  ..  "\\Physical[0]{"..tostring(hazardousData.physical.melting).."}{}{celsius}{}"
  end
  if  hazardousData.physical.boiling            ~=  nil
  then
    if  result                ~=  ""
    then
      result                            =   result  ..  ", "
    end
    result                              =   result  ..  "\\acrshort{boilingTemperature}~"
    result                              =   result  ..  "\\Physical[0]{"..tostring(hazardousData.physical.boiling).."}{}{celsius}{}"
  end
  if  hazardousData.physical.decompose          ~=  nil
  then
    if  result                ~=  ""
    then
      result                            =   result  ..  ", "
    end
    result                              =   result  ..  "\\acrshort{decompositionTemperature}~"
    result                              =   result  ..  "\\Physical[0]{"..tostring(hazardousData.physical.decompose).."}{}{celsius}{}"
  end
  if  result                ~=  ""
  then
    log.trace
    (
      "hazardousPhysicals",
      "Result: "  ..  result
    )
    tex.print(result)
  end
end

function hazardousPictograms  ( hazardousData, width )
  local result                          =   ""
  local width                           =   tonumber  ( width ) or  0
  local pictograms                      =   {}
  if  hazardousGHS
  then
    ghsPictograms       ( hazardousData.ghs,      pictograms  )
  end
  if  hazardousNFPA704
  then
    nfpaPictograms      ( hazardousData.nfpa,     pictograms  )
  end
  if  hazardousADR
  then
    adrPlate                            =   adrPictograms ( hazardousData,  pictograms  )
  end
  if  hazardousISO7010
  then
    iso7010Pictrograms  ( hazardousData.iso7010,  pictograms  )
  end
  if      width       ==  1.5
  and     #pictograms >=  1
  and     #pictograms <=  16
  then
    result                              =   pictograms  [ 1 ]
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 2   )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 3   )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 4   )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 5   )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 6   )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 7   )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 8   )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 9   )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 10  )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 11  )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 12  )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 13  )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 14  )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 15  )
    if  ( #pictograms % 2 ) ==  1
    then
      result
      =   result
      ..  "\\hspace{.5\\@HazardousPictogramSep}"
      ..  "\\hspace{.5\\@HazardousPictogramSize}"
      ..  "\\mbox{}"
    end
  elseif  width       ==  2.0
  and     #pictograms >=  1
  and     #pictograms <=  15
  then
    result                              =   pictograms  [ 1 ]
    if  ( #pictograms % 3 ) ~=  1
    then
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 2   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 3   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 4   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 5   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 6   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 7   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 8   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 9   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 10  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 11  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 12  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 13  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 14  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 15  )
    else
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 2   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 3   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 4   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 5   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 6   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 7   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 8   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 9   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 10  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 11  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 12  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 13  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 14  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 15  )
    end
  elseif  width       ==  2.5
  and     #pictograms >=  1
  and     #pictograms <=  15
  then
    result                              =   pictograms  [ 1 ]
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 2   )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 3   )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 4   )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 5   )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 6   )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 7   )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 8   )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 9   )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 10  )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 11  )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 12  )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 13  )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 14  )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 15  )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 16  )
    result
    =   result
    ..  "\\hspace{.5\\@HazardousPictogramSep}"
    ..  "\\hspace{.5\\@HazardousPictogramSize}"
    ..  "\\mbox{}"
    if  ( #pictograms % 2 ) ==  1
    then
      result
      =   result
      ..  "\\hspace{.5\\@HazardousPictogramSep}"
      ..  "\\hspace{.5\\@HazardousPictogramSize}"
      ..  "\\mbox{}"
    end
  elseif  width       ==  3.0
  and     #pictograms >=  1
  and     #pictograms <=  15
  then
    result                              =   pictograms  [ 1 ]
    local rest                          =   ( #pictograms % 5 )
    if  rest  ==  2
    then
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 2   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 3   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 4   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 5   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 6   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 7   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 8   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 9   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 10  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 11  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 12  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 13  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 14  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 15  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 16  )
    elseif  rest  ==  4
    then
      result
      =   result
      ..  "\\hspace{\\@HazardousPictogramSep}"
      ..  "\\hspace{\\@HazardousPictogramSize}"
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 2   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 3   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 4   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 5   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 6   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 7   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 8   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 9   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 10  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 11  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 12  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 13  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 14  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 15  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 16  )
    else
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 2   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 3   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 4   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 5   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 6   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 7   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 8   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 9   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 10  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 11  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 12  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 13  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 14  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 15  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 16  )
    end
  elseif  width       ==  3.5
  and     #pictograms >=  1
  and     #pictograms <=  15
  then
    result                              =   pictograms  [ 1 ]
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 2   )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 3   )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 4   )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 5   )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 6   )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 7   )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 8   )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 9   )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 10  )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 11  )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 12  )
    result                              =   result  ..  hazardousPictogramsSkip ( pictograms, 13  )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 14  )
    result                              =   result  ..  hazardousPictogramsStep ( pictograms, 15  )
    result                              =   result  ..  hazardousPictogramsFill ( pictograms, 16  )
    result
    =   result
    ..  "\\hspace{.5\\@HazardousPictogramSep}"
    ..  "\\hspace{.5\\@HazardousPictogramSize}"
    ..  "\\mbox{}"
    if  ( #pictograms % 3 ) ==  1
    then
      result
      =   result
      ..  "\\hspace{1.5\\@HazardousPictogramSep}"
      ..  "\\hspace{1.5\\@HazardousPictogramSize}"
      ..  "\\mbox{}"
    end
  elseif  width       ==  4.0
  and     #pictograms >=  1
  and     #pictograms <=  15
  then
    local rest                          =   ( #pictograms % 7 )
    if  rest  ==  1
    then
      result                            =   pictograms  [ 1 ]
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 2   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 3   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 4   )
      result
      =   result
      ..  "\\hspace{2\\@HazardousPictogramSep}"
      ..  "\\hspace{2\\@HazardousPictogramSize}"
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 5   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 6   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 7   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 8   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 9   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 10  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 11  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 12  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 13  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 14  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 15  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 16  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 17  )
    elseif  rest  ==  3
    then
      result                            =   pictograms  [ 1 ]
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 2   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 3   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 4   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 5   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 6   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 7   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 8   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 9   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 10  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 11  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 12  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 13  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 14  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 15  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 16  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 17  )
    elseif  rest  ==  5
    then
      result
      =   result
      ..  "\\hspace{\\@HazardousPictogramSep}"
      ..  "\\hspace{\\@HazardousPictogramSize}"
      result                            =   pictograms  [ 1 ]
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 2   )
      result
      =   result
      ..  "\\hspace{\\@HazardousPictogramSep}"
      ..  "\\hspace{\\@HazardousPictogramSize}"
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 3   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 4   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 5   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 6   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 7   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 8   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 9   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 10  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 11  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 12  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 13  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 14  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 15  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 16  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 17  )
    else
      result                            =   pictograms  [ 1 ]
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 2   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 3   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 4   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 5   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 6   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 7   )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 8   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 9   )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 10  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 11  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 12  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 13  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 14  )
      result                            =   result  ..  hazardousPictogramsSkip ( pictograms, 15  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 16  )
      result                            =   result  ..  hazardousPictogramsStep ( pictograms, 17  )
    end
  else
    for index, pictogram                in  ipairs  ( pictograms  )
    do
      result
      =   result .. pictogram ..  "\\hspace{\\@HazardousPictogramSep}"
    end
  end
  if  hazardousADRplate
  then
    result                              =   result  ..  adrPlate
  end
  result                                =   "\\makeatletter"  ..  result  ..  "\\makeatother"
  log.info
  (
    "hazardousPictograms",
    "result: »" ..  result  ..  "«"
  )
  tex.print ( result  )
end

function hazardousPictogramsFill  ( pictograms, level )
  if  #pictograms >=  level
  then
    return  "\\hspace{\\@HazardousPictogramSep}"
        ..  "\\hspace{.5\\@HazardousPictogramSize}"
        ..  "\\mbox{}"
        ..  tex.newline ..  "[-3\\normalbaselineskip]"
        ..  "\\hspace{.5\\@HazardousPictogramSize}"
        ..  "\\mbox{}"
        ..  pictograms  [ level ]
  else
    return  ""
  end
end

function hazardousPictogramsSkip  ( pictograms, level )
  if  #pictograms >=  level
  then
    return  tex.newline ..  "[-3\\normalbaselineskip]" ..  pictograms  [ level ]
  else
    return  ""
  end
end

function hazardousPictogramsStep  ( pictograms, level )
  if  #pictograms >=  level
  then
    return  "\\hspace{\\@HazardousPictogramSep}" ..  pictograms  [ level ]
  else
    return  ""
  end
end

function hazardousSignal      ( hazardousData )
  tex.print ( ghsSignal     ( hazardousData.ghs ) )
end
function hazardousStatements  ( hazardousData )
  ghsStatements ( hazardousData.ghs )
end

function hazardousTitle ( hazardousData )
  local sources                         =   ""
  if citations == true
  then
    for index, source                   in  ipairs  ( hazardousData.sources )
    do
      sources                           =   sources ..  "\\cite{" ..  tostring  ( source  ) ..  "}"
    end
  end
  local result                          =   hazardousData.title ..  sources
  if  hazardousData.label ~=  ""
  then
    result                              =   hypertarget ( hazardousData.label ) ..  result
  end
  tex.print ( result  )
end

function hazardousUFIorCASident ( hazardousData )
  if      hazardousData.ufIdentifier  ==  nil
  or      hazardousData.ufIdentifier  ==  ""
  then
    tex.print ( hazardousData.casNumber )
  end
end

function hazardousUFIorCAStitle ( hazardousData )
  if      hazardousData.ufIdentifier  ==  nil
  or      hazardousData.ufIdentifier  ==  ""
  then
    --  EG is german, EC is english, …
    tex.print ( "CAS:~" )
  else
    tex.print ( ""      )
  end
end

function hazardousUFIorECident  ( hazardousData )
  if      hazardousData.ufIdentifier  ==  nil
  or      hazardousData.ufIdentifier  ==  ""
  then
    tex.print ( hazardousData.ecNumber      )
  else
    tex.print ( hazardousData.ufIdentifier  )
  end
end

function hazardousUFIorECtitle  ( hazardousData )
  if      hazardousData.ufIdentifier  ==  nil
  or      hazardousData.ufIdentifier  ==  ""
  then
    --  EG is german, EC is english, …
    tex.print ( "EG-Nr:~" )
  else
    tex.print ( "UFI:~"   )
  end
end
