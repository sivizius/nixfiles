thesis
=   {
      logo                              =   "",
      defaults
      =   {
            logoColour                  =   "",
            logoMonochrome              =   "",
          },
    }

function  thesis.parseInstituteOptions ( options )
  --log.debug
  --(
  --  "thesisInstitute",
  --  "Parse Institute Options: ("  ..  options ..  ")"
  --)
  thesis.logo                           =   thesis.defaults.logoColour
  for option                            in  options:gmatch  ( "([^,]+)"       )
  do
    opName, opValue                     =   option:match    ( "([^=]+)=(.+)"  )
    --log.debug
    --(
    --  "thesisInstitute",
    --  "Name: »" ..  opName:tostring ( ) ..  "«, Value: »" ..  opValue:tostring  ( ) ..  "«"
    --)
    if not  ( opName and opValue  )
    then
      if  option  ==  "monochrome"
      then
        thesis.logo                     =   thesis.defaults.logoMonochrome
      end
    end
  end
end
