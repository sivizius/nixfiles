function ghsHazards ( ghs )
  local options                         =   ""
  if next( ghs.hazards)
  then
    for index, value                    in  ipairs(ghs.hazards)
    do
      if      type  ( value )   ==  "number"
      then
        value                           =   tostring  ( value     )
      elseif  type  ( value )   ==  "table"
      then
        if      value.organs    ~=  nil
        then
          options                       =   options ..  "organs="   ..  value.organs
        end
        if      value.effect    ~=  nil
        then
          options                       =   options ..  "effect="   ..  value.effect
        end
        if      value.exposure  ~=  nil
        then
          options                       =   options ..  "exposure=" ..  value.exposure
        end
        value                           =   tostring  ( value.id  )
      end
      if options == ""
      then
        tex.print("\\ghs{h}{"..value.."}")
      else
        tex.print("\\ghs["..options.."]{h}{"..value.."}")
      end
    end
    tex.print(tex.newline)
  end
end

local statements
=   {
      [ "deu" ]
      =   {

          },
      [ "eng" ]
      =   {
            [ "200" ]                   =   "Unstable explosive.",
            [ "201" ]                   =   "Explosive; mass explosion hazard.",
            [ "202" ]                   =   "Explosive; severe projection hazard.",
            [ "203" ]                   =   "Explosive; fire, blast or projection hazard.",
            [ "204" ]                   =   "Fire or projection hazard.",
            [ "205" ]                   =   "May mass explode in fire.",
            [ "206" ]                   =   "Fire, blast or projection hazard: increased risk of explosion if desensitizing agent is reduced.",
            [ "207" ]                   =   "Fire or projection hazard: increased risk of explosion if desensitizing agent is reduced.",
            [ "208" ]                   =   "Fire hazard: increased risk of explosion if desensitizing agent is reduced.",
            [ "220" ]                   =   "Extremely flammable gas.",
            [ "221" ]                   =   "Flammable gas.",
            [ "222" ]                   =   "Extremely flammable aerosol.",
            [ "223" ]                   =   "Flammable aerosol.",
            [ "224" ]                   =   "Extremely flammable liquid and vapour.",
            [ "225" ]                   =   "Highly flammable liquid and vapour.",
            [ "226" ]                   =   "Flammable liquid and vapour.",
            [ "227" ]                   =   "Combustible liquid.",
            [ "228" ]                   =   "Flammable solid.",
            [ "229" ]                   =   "Pressurized container: may burst if heated.",
            [ "230" ]                   =   "May react explosively even in the absence of air.",
            [ "231" ]                   =   "May react explosively even in the absence of air at elevated pressure and/or temperature.",
            [ "232" ]                   =   "May ignite spontaneously if exposed to air.",
            [ "240" ]                   =   "Heating may cause an explosion.",
            [ "241" ]                   =   "Heating may cause a fire or explosion.",
            [ "242" ]                   =   "Heating may cause a fire.",
            [ "250" ]                   =   "Catches fire spontaneously if exposed to air.",
            [ "251" ]                   =   "Self-heating; may catch fire.",
            [ "252" ]                   =   "Self-heating in large quantities; may catch fire.",
            [ "260" ]                   =   "In contact with water releases flammable gases which may ignite spontaneously.",
            [ "261" ]                   =   "In contact with water releases flammable gas.",
            [ "270" ]                   =   "May cause or intensify fire; oxidizer.",
            [ "271" ]                   =   "May cause fire or explosion; strong oxidizer.",
            [ "272" ]                   =   "May intensify fire; oxidizer.",
            [ "280" ]                   =   "Contains gas under pressure; may explode if heated.",
            [ "281" ]                   =   "Contains refrigerated gas; may cause cryogenic burns or injury.",
            [ "290" ]                   =   "May be corrosive to metals.",
          },
    }
