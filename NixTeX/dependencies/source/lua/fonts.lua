function fonts.textLS ( strInput, spacing )
  local lenInput                        =   string.len ( strInput )
  local lstOutput                       =   { "" }
  local ctrOutput                       =   1
  local posInput                        =   1
  while ( posInput <= lenInput )
  do
    local char                          =   utf8split ( strInput, posInput )
    while (
            string.byte ( char )  >=  48
          and
            string.byte ( char )  <=  57
          )
      or  char  ==  "."
      or  char  ==  "‚"
      or  char  ==  "‘"
      or  char  ==  "„"
      or  char  ==  "“"
      or  char  ==  "»"
      or  char  ==  "«"
      or  char  ==  "›"
      or  char  ==  "‹"
      or  char  ==  "°"
    do
      lstOutput [ ctrOutput ]           =   lstOutput [ ctrOutput ] .. char
      posInput                          =   posInput + string.len ( char )
      char                              =   utf8split ( strInput, posInput )
    end

    if lstOutput [ ctrOutput ]  ~=  ""
    then
      ctrOutput                         =   ctrOutput + 1
    end

    if      string.sub ( strInput, posInput, posInput + 1 ) == "Ch"
    then
      lstOutput [ ctrOutput ]           =   "Ch"
      posInput                          =   posInput  + 1
    elseif  string.sub ( strInput, posInput, posInput + 1 ) == "ch"
    then
      lstOutput [ ctrOutput ]           =   "ch"
      posInput                          =   posInput  + 1
    elseif  string.sub ( strInput, posInput, posInput + 1 ) == "Ck"
    then
      lstOutput [ ctrOutput ]           =   "Ck"
      posInput                          =   posInput  + 1
    elseif  string.sub ( strInput, posInput, posInput + 1 ) == "ck"
    then
      lstOutput [ ctrOutput ]           =   "ck"
      posInput                          =   posInput  + 1
    elseif  string.sub ( strInput, posInput, posInput + 1 ) == "St"
    then
      lstOutput [ ctrOutput ]           =   "St"
      posInput                          =   posInput  + 1
    elseif  string.sub ( strInput, posInput, posInput + 1 ) == "st"
    then
      lstOutput [ ctrOutput ]           =   "st"
      posInput                          =   posInput  + 1
    elseif  string.sub ( strInput, posInput, posInput + 1 ) == "Tz"
    then
      lstOutput [ ctrOutput ]           =   "Tz"
      posInput                          =   posInput  + 1
    elseif  string.sub ( strInput, posInput, posInput + 1 ) == "tz"
    then
      lstOutput [ ctrOutput ]           =   "tz"
      posInput                          =   posInput  + 1
    elseif  char                                            == " "
    then
      lstOutput [ ctrOutput ]           =   " "
      ctrOutput                         =   ctrOutput + 1
      lstOutput [ ctrOutput ]           =   ""
    else
      lstOutput [ ctrOutput ]           =   char
    end
    posInput                            =   posInput  + string.len ( char )
  end

  for _, item                           in  pairs ( lstOutput )
  do
    if item == " "
    then
      tex.print ( "\\kern " ..  tostring  ( 2*spacing ) ..  "em" )
    else
      tex.print ( item .. "\\kern " ..  tostring  ( spacing ) ..  "em" )
    end
  end
end
