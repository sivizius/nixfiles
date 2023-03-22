includeCode ( "hazardous/ghs/euhazards"   )
includeCode ( "hazardous/ghs/hazards"     )
includeCode ( "hazardous/ghs/precautions" )
includeCode ( "hazardous/ghs/signals"     )

--  pictograms
ghsExplosive                            =   1
ghsFlame                                =   2
ghsOFlame                               =   3 --  roundflame
ghsBottle                               =   4
ghsAcid                                 =   5
ghsSkull                                =   6
ghsExclam                               =   7
ghsHealth                               =   8 --  silhouette
ghsPollu                                =   9 --  aqpol

--  signal words
ghsNone                                 =   1
ghsWarning                              =   2
ghsDanger                               =   3
ghsInvalid                              =   4

function ghsData  ( hazardousData )
  local result
  local name                            =   hazardousData.title
  if      hazardousData.ghs             ==  nil
  then
    log.warn
    (
      "gethazardousData",
      "please update ›" .. name .. "‹ to new format (ghs { hazards, euHazards, precautions, pictograms, signal})!"
    )
    result
    =   {
          hazards                       =   hazardousData.hazards,
          euHazards                     =   hazardousData.euHazards,
          precautions                   =   hazardousData.precautions,
          pictograms                    =   hazardousData.dangers,
          signal                        =   hazardousData.signal,
        }
  else
    result                              =   hazardousData.ghs
  end

  --  hazard statements
  if      result.hazards                ==  nil
  then
    result.hazards                      =   {}
  elseif  type  ( result.hazards  )     ==  "number"
  or      type  ( result.hazards  )     ==  "string"
  then
    result.hazards                      =   { tostring  ( result.hazards      ) }
  end

  --  eu-hazard statements
  if      result.euHazards              ==  nil
  then
    result.euHazards                    =   {}
  elseif  type  ( result.euHazards  )   ==  "number"
  or      type  ( result.euHazards  )   ==  "string"
  then
    result.euHazards                    =   { tostring  ( result.euHazards    ) }
  end

  --  precaution statements
  if      result.precautions            ==  nil
  then
    result.precautions                  =   {}
  elseif  type  ( result.precautions  ) ==  "number"
  or      type  ( result.precautions  ) ==  "string"
  then
    result.precautions                  =   { tostring  ( result.precautions  ) }
  end

  --  pictograms
  result.pictograms                     =   result.pictograms or  {}

  --  signal word
  if      result.signal                 ==  nil
  then
    result.signal                       =   ghsInvalid
  elseif  type  ( result.signal )       ~=  "number"
  or      result.signal                 >=  ghsInvalid
  or      result.signal                 <   ghsNone
  then
    log.warn
    (
      "gethazardousData",
      "›" .. name .. "‹ has invalid signal word!"
    )
    result.signal                       =   ghsInvalid
  end
  return result
end

function ghsPictograms  ( ghs, pictograms )
  for index, pictogram                  in  ipairs  ( ghs.pictograms  )
  do
    table.insert  ( pictograms, ghsSinglePictogram ( pictogram, ""  ) )
  end
end

function ghsNamedPictogram  ( inPictogram,  extra )
  pictogram                             =   inPictogram:lower ( )
  if      pictogram ==  "explosive"
  or      pictogram ==  "1"
  then
    return  ghsSinglePictogram  ( ghsExplosive, extra )
  elseif  pictogram ==  "flame"
  or      pictogram ==  "2"
  then
    return  ghsSinglePictogram  ( ghsFlame,     extra )
  elseif  pictogram ==  "oflame"
  or      pictogram ==  "roundflame"
  or      pictogram ==  "3"
  then
    return  ghsSinglePictogram  ( ghsOFlame,    extra )
  elseif  pictogram ==  "bottle"
  or      pictogram ==  "gas"
  or      pictogram ==  "4"
  then
    return  ghsSinglePictogram  ( ghsBottle,    extra )
  elseif  pictogram ==  "acid"
  or      pictogram ==  "corrosive"
  or      pictogram ==  "5"
  then
    return  ghsSinglePictogram  ( ghsAcid,      extra )
  elseif  pictogram ==  "skull"
  or      pictogram ==  "toxic"
  or      pictogram ==  "poisonous"
  or      pictogram ==  "6"
  then
    return  ghsSinglePictogram  ( ghsSkull,     extra )
  elseif  pictogram ==  "exclam"
  or      pictogram ==  "!"
  or      pictogram ==  "7"
  then
    return  ghsSinglePictogram  ( ghsExclam,    extra )
  elseif  pictogram ==  "health"
  or      pictogram ==  "silhouette"
  or      pictogram ==  "8"
  then
    return  ghsSinglePictogram  ( ghsHealth,    extra )
  elseif  pictogram ==  "pollu"
  or      pictogram ==  "aqpol"
  or      pictogram ==  "9"
  then
    return  ghsSinglePictogram  ( ghsPollu,     extra )
  else
    return  "Unknown Pictogram »" ..  inPictogram ..  "«!"
  end
end

function ghsSinglePictogram ( pictogram,  extra )
  return  "\\includegraphics[width=\\@HazardousPictogramSize"  ..  ( "," ..  extra or  ""  ) ..  "]"
          ..  ( "{"..source.."assets/pictograms/ghs/%02d.pdf}" ):format  ( pictogram )
end

function ghsStatements  ( ghs )
  if  not next  ( ghs.hazards     )
  and not next  ( ghs.euHazards   )
  and not next  ( ghs.precautions )
  then
    tex.print ( "H: —, P: —"  )
  else
    ghsHazards      ( ghs )
    ghsEUHazards    ( ghs )
    ghsPrecautions  ( ghs )
  end
end
