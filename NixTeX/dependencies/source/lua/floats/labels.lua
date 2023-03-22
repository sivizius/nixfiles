labels
=   {
      conjunction                       =   " und ",
      appendices
      =   {
            name                        =   "Appendix",
            singular                    =   "Anhang",
            plural                      =   "Anhänge",
            prefix                      =   "appendix",
            list                        =   {},
          },
      chapters
      =   {
            name                        =   "Chapter",
            singular                    =   "Kapitel",
            plural                      =   "Kapitel",
            prefix                      =   "chapter",
            list                        =   {},
          },
      equations
      =   {
            name                        =   "Equation",
            singular                    =   "Gleichung",
            plural                      =   "Gleichungen",
            prefix                      =   "equation",
            list                        =   {},
          },
      figures
      =   {
            name                        =   "Figure",
            singular                    =   "Abbildung",
            plural                      =   "Abbildungen",
            prefix                      =   "figure",
            list                        =   {},
          },
      listings
      =   {
            name                        =   "Listing",
            singular                    =   "Quelltext",
            plural                      =   "Quelltexte",
            prefix                      =   "listing",
            list                        =   {},
          },
      paragraphs
      =   {
            name                        =   "Paragraph",
            singular                    =   "Absatz",
            plural                      =   "Absätze",
            prefix                      =   "paragraph",
            list                        =   {},
          },
      parts
      =   {
            name                        =   "Part",
            singular                    =   "Teil",
            plural                      =   "Teile",
            prefix                      =   "part",
            list                        =   {},
          },
      schemes
      =   {
            name                        =   "Scheme",
            singular                    =   "Schema",
            plural                      =   "Schemata",
            prefix                      =   "scheme",
            list                        =   {},
          },
      sections
      =   {
            name                        =   "Section",
            singular                    =   "Abschnitt",
            plural                      =   "Abschnitte",
            prefix                      =   "section",
            list                        =   {},
          },
      sentences
      =   {
            name                        =   "Sentence",
            singular                    =   "Satz",
            plural                      =   "Sätze",
            prefix                      =   "sentence",
            list                        =   {},
          },
      subparagraphs
      =   {
            name                        =   "Subparagraph",
            singular                    =   "Unterabsatz",
            plural                      =   "Unterabsätze",
            prefix                      =   "subparagraph",
            list                        =   {},
          },
      subsections
      =   {
            name                        =   "Subsection",
            singular                    =   "Unterabschnitt",
            plural                      =   "Unterabschnitte",
            prefix                      =   "subsection",
            list                        =   {},
          },
      subsubsections
      =   {
            name                        =   "Subsubsection",
            singular                    =   "Unterunterabschnitt",
            plural                      =   "Unterunterabschnitte",
            prefix                      =   "subsubsection",
            list                        =   {},
          },
      tables
      =   {
            name                        =   "Table",
            singular                    =   "Tabelle",
            plural                      =   "Tabellen",
            prefix                      =   "table",
            list                        =   {},
          },
    }

local function getReferenceName ( object, label )
  log.info("getReferenceName", "Use "..object.name.."-Label »"..label.."«")
  if object.list  [ label ]
  then
    object.list [ label ].uses        =   object.list [ label ].uses  + 1
  else
    object.list [ label ]
    =   {
          declared                    =   0,
          uses                        =   1,
        }
  end
  return object.prefix ..  ":" ..  label
end

local function getReference ( object, label )
  return "\\ref{" ..  getReferenceName ( object, label ) ..  "}"
end

function  labels.declare  ( object, label, allowDeclarationTwice  )
  local tries                           =   1
  --  Equation does weird stuff and this function is invoked twice
  if  allowDeclarationTwice
  then
    tries                               =   2
  end
  if  label ==  ""
  then
    log.error
    (
      "labels.declare",
      "Label for "  ..  object.name ..  " empty!",
      "Use \\label" ..  object.name ..  "{<Name of Label>}"
    )
  else
    if  object.list [ label ]
    and object.list [ label ].declared
    and object.list [ label ].declared >  tries
    then
      log.error
      (
        "labels.declare",
        "Label for "  ..  object.name ..  " »"  ..  label ..  "« already declared!"
      )
    else
      if  object.list [ label ]
      then
        object.list [ label ].declared  =   object.list [ label ].declared  + 1
      else
        object.list [ label ]
        =   {
              declared                  =   1,
              uses                      =   0,
            }
      end
      tex.print ( "\\label{"  ..  object.prefix ..  ":" ..  label ..  "}" )
    end
  end
end

function  labels.hyperlink  ( object, name  )
  return "\\hyperlink{" ..  getReferenceName ( object, name )  ..  "}"
end

function  labels.reference  ( object, list  )
  --  Parse Labels
  local listOfLabels                    =   list:split("|")

  --  Generate Output
  local output                          =   object.singular  ..  "~"
  local length                          =   #listOfLabels
  if      length  ==  0
  then
    output                              =   output  ..  "\\todo{Insert Label For "  ..  object.name ..  "}"
  elseif  length  ==  1
  then
    output                              =   output  ..  getReference  ( object, listOfLabels  [ 1 ] )
  else
    output                              =   object.plural ..  "~"
    local final                         =   listOfLabels  [ length  ]
    table.remove  ( listOfLabels, length  )
    for index,  entry                   in  ipairs  ( listOfLabels  )
    do
      listOfLabels  [ index ]           =   getReference  ( object, entry )
    end
    output                              =   output  ..   table.concat ( listOfLabels, ", "  )  ..  labels.conjunction  ..  getReference  ( object, final )
  end
  tex.print ( output  )
end

local function check  ( object  )
  log.info({"labels.check", "check"}, "Check "..object.name.."-Labels")
  for label, entry                      in  pairs ( object.list )
  do
    if  entry.declared
    then
      if  entry.uses == 0
      then
        log.warn
        (
          { "labels.check", "check("  ..  object.name ..  ")" },
          "Unused Label »" ..  label ..  "«!"
        )
      else
        log.debug
        (
          { "labels.check", "check("  ..  object.name ..  ")" },
          "Label »" ..  label ..  "« was declared and used."
        )
      end
    else
      log.error
      (
        { "labels.check", "check("  ..  object.name ..  ")" },
        "Label »" ..  label ..  "« used, but not declared!"
      )
    end
  end
end

function  labels.check  ( )
  log.info("labels.check", "Start checking labels…")
  check ( labels.appendices )
  check ( labels.equations  )
  check ( labels.figures    )
  check ( labels.listings   )
  check ( labels.schemes    )
  check ( labels.tables     )
  log.info("labels.check", "Check Labels done")
end
