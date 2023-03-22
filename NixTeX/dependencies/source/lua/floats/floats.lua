tblNotes      = 0
tblNamedNotes = {}
tblNoteText   = ""
tblSmall      = false
unlabeledTab  = 0
unlabeledFig  = 0
bookmarkcounter = 0

function tableNote(identifier, text)
  tblNotes = tblNotes + 1
  tex.print( "\\textsuperscript{("..string.char(96+tblNotes)..")}" )
  if not ( tblNoteText == "" )
  then
    tblNoteText=tblNoteText.."; "
  end
  tblNoteText = tblNoteText.."()"..string.char(96+tblNotes)..") "..text
  if not ( identifier == "" )
  then
    tblNamedNotes[ identifier ] = tblNotes
  end
end

function theNote(identifier)
  if tblNamedNotes[ identifier ]
  then
    text = string.char(96+tblNamedNotes[ identifier ])
  else
    text = identifier.."?"
  end
  tex.print( "\\textsuperscript{("..text..")}" )
end

colourSchemes                           =   {}
numColourSchemes                        =   0
function newColourScheme ( name, colour, mark, fill, line )
  colourSchemes [ numColourSchemes ]    =
  {
    name                                =   name,
    colour                              =   colour,
    mark                                =   mark,
    fill                                =   fill,
    line                                =   line
  }
  numColourSchemes                      =   numColourSchemes + 1
end

newColourScheme ( "blue",   "0.00,0.45,0.70", "*",          "white", "solid"  )
newColourScheme ( "red",    "0.80,0.40,0.00", "triangle*",  "white", "dashed" )
newColourScheme ( "orange", "0.90,0.60,0.00", "square*",    "white", "dotted" )
newColourScheme ( "green",  "0.00,0.60,0.50", "diamond*",   "white", ""       )
newColourScheme ( "cyan",   "0.35,0.70,0.90", "pentagon*",  "white", ""       )
newColourScheme ( "yellow", "0.95,0.90,0.25", "otimes*",    "white", ""       )
newColourScheme ( "purple", "0.80,0.60,0.70", "star*",      "white", ""       )
newColourScheme ( "black",  "0.00,0.00,0.00", "rtrianble*", "white", ""       )
