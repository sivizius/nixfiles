hazardClassExplosive                    =   1
hazardClassGas                          =   2
hazardClassFlammableLiquid              =   3
hazardClassFlammableSolid               =   4
hazardClassOxidiser                     =   5
hazardClassOxidizer                     =   hazardClassOxidiser
hazardClassPoison                       =   6
hazardClassToxic                        =   hazardClassPoison
hazardClassInfectious                   =   hazardClassPoison
hazardClassRadioactive                  =   7
hazardClassCorrosive                    =   8
hazardClassMiscellaneous                =   9
hazardClassOther                        =   hazardClassMiscellaneous

function adrData  ( hazardousData )
  local result                          =   hazardousData
  if  result.unNumber               ~=  nil
  then
    result.unNumber                     =   tostring  ( result.unNumber )
  else
    result.unNumber                     =   ""
  end
  if  result.kemler                 ~=  nil
  then
    if      type  ( result.kemler ) ==  "number"
    then
      if result.kemler  < 0
      then
        result.kemler                   =   "X" ..  tostring  ( -result.kemler  )
      else
        result.kemler                   =   tostring  ( result.kemler )
      end
    elseif  type  ( result.kemler ) ~=  "string"
    then
      result.kemler                     =   "???"
    end
  else
    result.kemler                       =   ""
  end
  return result
end

function adrPictograms  ( hazardousData,  pictograms  )
  if  hazardousData.hazardClass           ~=  nil
  and type  ( hazardousData.hazardClass ) ==  "table"
  then
    for index, class                    in  pairs ( hazardousData.hazardClass )
    do
      if      type  ( class ) ==  "number"
      then
        if  class ==  3 --  flammable liquids
        or  class ==  8 --  corrosive substancees
        or  class ==  9 --  miscellaneous hazards
        then
          log.error
          (
            "adrPictograms",
            "Only Class 3 (Flammable Liquids) and 8 (Corrosive Substances) do not need further specification"
          )
        end
      elseif  type  ( class ) ==  "table"
      then
        if  class.class           ~=  nil
        and type  ( class.class ) ==  "number"
        then
          if      class.class               ==  hazardClassExplosive
          and     class.subClass            ~=  nil
          and     type  ( class.subClass  ) ==  "number"
          then
            --  explosives
            if      class.compatibility           ==  nil
            then
              class.compatibility       =   ""
            elseif  type  ( class.compatibility ) ==  "number"
            then
              class.compatibility       =   "A"
            end
            if      class.subClass  > 0
            and     class.subClass  < 4
            then
              --  with pictogram
              table.insert
              (
                pictograms,
                "\\adrExplosive"
                ..  "[\\@HazardousPictogramSize]"
                ..  "{" ..  class.subClass      ..  "}"
                ..  "{" ..  class.compatibility ..  "}"
              )
            elseif  class.subClass  < 7
            then
              --  with subclass
              table.insert
              (
                pictograms,
                "\\adrLessExplosive"
                ..  "[\\@HazardousPictogramSize]"
                ..  "{" ..  class.subClass      ..  "}"
                ..  "{" ..  class.compatibility ..  "}"
              )
            else
              log.error
              (
                { "adrPictograms",  "explosives", },
                "Invalid Subclass: " ..  tostring  ( class.subClass  )
              )
            end
          elseif  class.class               ==  hazardClassGas
          and     class.subClass            ~=  nil
          and     type  ( class.subClass  ) ==  "number"
          then
            --  gases
            if      class.subClass  ==  1
            then
              table.insert
              (
                pictograms,
                "\\adrFlammableGas"
                ..  "[\\@HazardousPictogramSize]"
              )
            elseif  class.subClass  ==  2
            then
              table.insert
              (
                pictograms,
                "\\adrNonFlammableGas"
                ..  "[\\@HazardousPictogramSize]"
              )
            elseif  class.subClass  ==  3
            then
              table.insert
              (
                pictograms,
                "\\adrPoisonGas"
                ..  "[\\@HazardousPictogramSize]"
              )
            else
              log.error
              (
                { "adrPictograms", "gases", },
                "Invalid Subclass: " ..  tostring  ( class.subClass  )
              )
            end
          elseif  class.class               ==  hazardClassFlammableLiquid
          then
            table.insert
            (
              pictograms,
              "\\adrFlammableLiquid"
              ..  "[\\@HazardousPictogramSize]"
            )
          elseif  class.class               ==  hazardClassFlammableSolid
          and     class.subClass            ~=  nil
          and     type  ( class.subClass  ) ==  "number"
          then
            --  flammable solids
            if      class.subClass  ==  1
            then
              table.insert
              (
                pictograms,
                "\\adrFlammableSolid"
                ..  "[\\@HazardousPictogramSize]"
              )
            elseif  class.subClass  ==  2
            then
              table.insert
              (
                pictograms,
                "\\adrSpontaneouslyCombustible"
                ..  "[\\@HazardousPictogramSize]"
              )
            elseif  class.subClass  ==  3
            then
              table.insert
              (
                pictograms,
                "\\adrDangerousWhenWet"
                ..  "[\\@HazardousPictogramSize]"
              )
            else
              log.error
              (
                { "adrPictograms",  "flammable solids", },
                "Invalid Subclass: " ..  tostring  ( class.subClass  )
                "error"
              )
            end
          elseif  class.class               ==  hazardClassOxidiser
          and     class.subClass            ~=  nil
          and     type  ( class.subClass  ) ==  "number"
          then
            --  oxidising substances and organic peroxides
            if      class.subClass  ==  1
            then
              table.insert
              (
                pictograms,
                "\\adrOxidiser"
                ..  "[\\@HazardousPictogramSize]"
              )
            elseif  class.subClass  ==  2
            then
              table.insert
              (
                pictograms,
                "\\adrPeroxide"
                ..  "[\\@HazardousPictogramSize]"
              )
            else
              log.error
              (
                { "adrPictograms",  "oxidising substances and organic peroxides", },
                "Invalid Subclass: " ..  tostring  ( class.subClass  )
              )
            end
          elseif  class.class               ==  hazardClassPoison
          and     class.subClass            ~=  nil
          and     type  ( class.subClass  ) ==  "number"
          then
            --  toxic, poisonous and infectious substances
            if      class.subClass  ==  1
            then
              table.insert
              (
                pictograms,
                "\\adrToxic"
                ..  "[\\@HazardousPictogramSize]"
              )
            elseif  class.subClass  ==  2
            then
              table.insert
              (
                pictograms,
                "\\adrInfectious"
                ..  "[\\@HazardousPictogramSize]"
              )
            else
              log.error
              (
                { "adrPictograms",  "toxic, poisonous and infectious substances", },
                "Invalid Subclass: " ..  tostring  ( class.subClass  )
              )
            end
          elseif  class.class               ==  hazardClassRadioactive
          and     class.subClass            ~=  nil
          and     type  ( class.subClass  ) ==  "number"
          then
            --  radioactive and fissile material
            if      class.subClass  ==  1
            then
              if  class.activity            ~=  nil
              and type  ( class.activity  ) ==  "number"
              then
                local exponent            =   math.floor  ( math.log  ( class.activity, 10  ) )
                local decimal             =   tostring  ( class.activity  * 10  ^ -exponent )
                if  exponent  ==  0
                then
                  exponent                =   ""
                else
                  exponent                =   tostring  ( exponent  )
                end
                table.insert
                (
                  pictograms,
                  "\\adrRadioactiveI"
                  ..  "[\\@HazardousPictogramSize]"
                  ..  "{" ..  ( class.contents  or  ""  ) ..  "}"
                  ..  "{{"  ..  decimal ..  "}{"  ..  exponent ..  "}{becquerel}{}\\Unit{kilogram}{-1}}"
                )
              else
                log.error
                (
                  { "adrPictograms",  "radioactive and fissile material", "RadioactiveI", },
                  "No Valid Activity Given."
                )
              end
            elseif  class.subClass  ==  2
            or      class.subClass  ==  3
            then
              local macro               =   ""
              if  class.subClass  ==  2
              then
                macro                   =   "adrRadioactiveII"
              else
                macro                   =   "adrRadioactiveIII"
              end
              if  class.activity            ~=  nil
              and type  ( class.activity  ) ==  "number"
              and class.index               ~=  nil
              and tostring  ( class.index ) ~=  nil
              then
                local exponent            =   math.floor  ( math.log  ( class.activity, 10  ) )
                local decimal             =   tostring  ( class.activity  * 10  ^ -exponent )
                if  exponent  ==  0
                then
                  exponent                =   ""
                else
                  exponent                =   tostring  ( exponent  )
                end
                table.insert
                (
                  pictograms,
                  bs  ..  macro
                  ..  "[\\@HazardousPictogramSize]"
                  ..  "{" ..  ( class.contents  or  ""  ) ..  "}"
                  ..  "{{"  ..  decimal ..  "}{"  ..  exponent ..  "}{becquerel}{}\\Unit{kilogram}{-1}}"
                  ..  "{" ..  tostring  ( class.index ) ..  "}"
                )
              else
                log.error
                (
                  { "adrPictograms",  "radioactive and fissile material", macro,  },
                  "No Valid Activity and/or Index Given."
                )
              end
            elseif  class.subClass  ==  5
            then
              if  class.index               ~=  nil
              and tostring  ( class.index ) ~=  nil
              then
                table.insert
                (
                  pictograms,
                  "\\adrFissile"
                  ..  "[\\@HazardousPictogramSize]"
                  ..  "{" ..  tostring  ( class.index ) ..  "}"
                )
              else
                log.error
                (
                  { "adrPictograms",  "radioactive and fissile material", "Fissile",  },
                  "No Valid Index Given."
                )
              end
            else
              log.error
              (
                { "adrPictograms",  "radioactive and fissile material", },
                "Invalid Subclass: " ..  tostring  ( class.subClass  )
              )
            end
          elseif  class.class               ==  hazardClassCorrosive
          then
            --  corrosive substances
            table.insert
            (
              pictograms,
              "\\adrCorrosive"
              ..  "[\\@HazardousPictogramSize]"
            )
          elseif  class.class               ==  hazardClassMiscellaneous
          then
            --  lithium ion cells, miscellaneous
            if  class.subClass  ==  "A"
            then
              table.insert
              (
                pictograms,
                "\\adrLithiumCells"
                ..  "[\\@HazardousPictogramSize]"
              )
            else
              table.insert
              (
                pictograms,
                "\\adrOther"
                ..  "[\\@HazardousPictogramSize]"
              )
            end
          elseif  class.class               >=  1
          and     class.class               <=  9
          then
            log.error
            (
              "adrPictograms",
              "SubClass must be specified as a number"
            )
          else
            log.error
            (
              "adrPictograms",
              "Class must be between 1 and 9"
            )
          end
        else
          log.error
          (
            "adrPictograms",
            "Class must be specified as a number between 1 and 9"
          )
        end
      else
        log.error
        (
          "adrPictograms",
          "Class must be of of type number or table, not ›" ..  type  ( class ) ..  "‹"
        )
      end
    end
  end
  if  hazardousData.unNumber              ~=  ""
  or  hazardousData.kemler                ~=  ""
  then
    return  tex.newline
        ..  "\\adrPlate[0.07]{" ..  hazardousData.kemler  ..  "}{"  ..  hazardousData.unNumber  ..  "}"
        ..  "\\hspace{\\@HazardousPictogramSep}"
  else
    return  ""
  end
end
