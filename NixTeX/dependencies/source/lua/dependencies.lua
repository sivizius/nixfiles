if  superclass  ~=  "beamer"
and superclass  ~=  "tucbrief"
then
  local temp                            =   ""
  if  headSepLine
  then
    temp                                =   ",headsepline"
  end
  local scrletter                       =   ""
  if  superclass  ==  "letter"
  then
    scrletter                           =   "\\usepackage[singlespacing=true]{scrletter}"
  end
  tex.print ( "\\usepackage[automark" ..  temp  ..  "]{scrlayer-scrpage}" ..  scrletter )
end
if  draftMode
then
  tex.print
  (
    "\\showboxbreadth=50" ..
    "\\showboxdepth=50"   ..
    "\\overfullrule=1mm"
  )
end
if  class ~=  "tucletter"
then
  tex.print
  (
    "\\usepackage{subcaption}"  ..
    "\\usepackage[figure,table]{totalcount}"
  )
end
