superclasses                            =   {}
superclasses  [ "application" ]         =   "letter"
superclasses  [ "slides"      ]         =   "beamer"
superclasses  [ "letter"      ]         =   "letter"
superclasses  [ "meeting"     ]         =   "article"
superclasses  [ "plain"       ]         =   "plain"
superclasses  [ "experiment"  ]         =   "thesis"
superclasses  [ "thesis"      ]         =   "thesis"
superclasses  [ "book"        ]         =   "book"
superclasses  [ "tucletter"   ]         =   "tucbrief"

achromatopsia                           =   false
if      class         ==  nil
then
  assert(false, "no class given")
else
  superclass                            =   superclasses [ class ]
  if    superclass    ==  nil
  then
    assert(false, "unknown class: ›"..class.."‹" )
  end
end
documentTitle                           =   ""
if      draftMode     ==  nil
then
  draftMode                             =   false
end
dyslexia                                =   false
if      fontSize      ==  nil
then
  fontSize                              =   "12pt"
end
if      fullPage      ==  nil
then
  fullPage                              =   0
elseif  fullPage      ==  true
then
  fullPage                              =   1
end
hazDualScreen                           =   false
hazHandout                              =   false
hazLink                                 =   true
hazNotesOnly                            =   false
if      headSepLine   ==  nil
then
  headSepLine                           =   false
end
neverRotatePages                        =   "false"
noAppendix                              =   "false"
if      noCitations   ==  nil
then
  noCitations                           =   false
end
if      noChapters    ==  nil
then
  noChapters                            =   false
end
noMainMatter                            =   "false"
if      openLeft      ==  nil
then
  openLeft                              =   false
end
if      pageFormat    ==  nil
then
  pageFormat                            =   "a4paper"
end
if      twoSided      ==  nil
then
  twoSided                              =   false
end
