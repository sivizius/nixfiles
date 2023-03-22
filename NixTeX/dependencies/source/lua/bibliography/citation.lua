citations
=   {
      remembered                        =   "",
    }
function  citations.load ( directory,  list, auto )
  if  directory
  and directory ~= ""
  then
    directory                                 =   "references/" ..  directory ..  "/"
  else
    directory                                 =   "references/"
  end

--  local references                      =   {}
--  if  auto
--  then
--    for file                            in  io.popen  ( "ls '"  ..  directory ..  "'"):lines()
--    do
--      if file:sub(-4) == ".bib"
--      then
--        print("»"..file:sub(1,-5).."«")
--      end
--    end
--  end

  for index, reference                  in  ipairs  ( list:split  ( ) )
  do
    reference                           =   reference:gsub  ( "%s+",  ""  )
    if  reference  ~=  ""
    then
      local fileName                    =   directory ..  reference ..  ".bib"
      markFileAsUsed  ( fileName  )
      tex.print ( "\\addbibresource{" ..  fileName  ..  "}" )
    end
  end
end

function citations.claim ( references, next )
  local short                           =   next:gsub ( "%s", ""  )
  if  short ==  ","
  or  short ==  ";"
  or  short ==  "."
  or  short ==  ":"
  or  short ==  "?"
  or  short ==  "!"
  then
    tex.print(short.."\\citeHere{"..references.."} ")
  else
    tex.print("\\citeHere{"..references.."} "..next)
  end
end

function citations.remember ( citation  )
  citations.remembered                  =   citations.remembered  ..  "," ..  citation
end

function citations.clear  ( other )
  local references                      =   ( other or  ""  ) ..  citations.remembered
  if  references  ~=  ""
  then
    if  references:sub  ( 1,  1 ) ==  ","
    then
      references                        =   references:sub  ( 2 )
    end
    tex.print ( "\\makeatletter\\@citeInstant{" ..  references  ..  "}\\makeatother"  )
  end
  citations.remembered                  =   ""
end
