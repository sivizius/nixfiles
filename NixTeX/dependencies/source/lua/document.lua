document
=   {
      languages
      =   {
          },
    }

local function prepareLanguage  ( object, text  )
  local language                        =   document.languages  [ object.language ] or  {}
  return  {
            language                    =   object.language                           or  "",
            marks                       =   object.marks      or  language.marks      or  "",
            marksLeft                   =   object.marksLeft  or  language.marksLeft  or  "",
            marksRight                  =   object.marksRight or  language.marksRight or  "",
            right                       =                         language.right      or  false,
            prepare                     =                         language.prepare    or  false,
            font                        =                         language.font       or  "",
            type                        =                         language.type       or  "\\textit",
            text                        =                                                 text,
          }
end

function  document.parseQuote ( inputOptionList,  inputOriginalText,  inputTranscript, inputTranslatedText,  inputAuthor )
  --  parse options
  local original                        =   {}
  local translated                      =   {}
  for option                            in  inputOptionList:gmatch  ( "([^,]+)" )
  do
    opName, opValue                     =   option:match  ( "([^=]+)=(.+)"  )
    if  opName  and opValue
    then
      if      opName  ==  "originalMarks"
      then
        original.marks                  =   opValue
      elseif  opName  ==  "originalLeft"
      then
        original.marksLeft              =   opValue
      elseif  opName  ==  "originalRight"
      then
        original.marksRight             =   opValue
      elseif  opName  ==  "originalLanguage"
      then
        original.language               =   opValue
      elseif  opName  ==  "translatedMarks"
      then
        translated.marks                =   opValue
      elseif  opName  ==  "translatedLeft"
      then
        translated.marksLeft            =   opValue
      elseif  opName  ==  "translatedRight"
      then
        translated.marksRight           =   opValue
      elseif  opName  ==  "translatedLanguage"
      then
        translated.language             =   opValue
      end
    else
      -- flags
    end
  end

  --  construct quote-object
  document.quote
  =   {
        optionList                      =   inputOptionList,
        author                          =   inputAuthor,
        text                            =   false,
        original                        =   prepareLanguage ( original,   inputOriginalText   ),
        transcript                      =   inputTranscript,
        translated                      =   prepareLanguage ( translated, inputTranslatedText ),
      }

  local original                        =   document.quote.original
  local translated                      =   document.quote.translated

  --  Generate Original Quote
  if  original.text ~=  ""
  then
    if  type  ( original.prepare  ) ==  "function"
    then
      original.text                     =   original.prepare  ( original.text ) or  ""
    end

    --  Quotation Marks for Original Quote
    if  original.marks ==  ""
    then
      if  original.marksLeft  ==  ""
      and original.marksRight ==  ""
      then
        original.text                   =   "\\q{"  ..  original.text ..  "}"
      else
        original.text                   =   original.marksLeft  ..  original.text ..  original.marksRight
      end
    else
      original.text                     =   "\\"  ..  original.marks  ..  "{" ..  original.text ..  "}"
    end
    original.text                       =   "\\normalsize"  ..  original.type ..  original.font ..  "{" ..  original.text ..  "}"

    --  Transcript
    if  document.quote.transcript ~=  ""
    then
      original.text                     =   original.text ..  "\\linebreak\\tiny{[" ..  document.quote.transcript .. "]}"
    end
    if original.right
    then
      original.text                     =   "\\begin{flushright}{"  ..  original.text ..  "}\\end{flushright}"
    end

    --  Generate Translated Quote
    if  translated.text ~=  ""
    then
      if  type  ( translated.prepare  ) ==  "function"
      then
        translated.text                 =   translated.prepare  ( translated.text ) or  ""
      end

      --  Quotation Marks for Translated Quote
      if  translated.marks ==  ""
      then
        if  translated.marksLeft  ==  ""
        and translated.marksRight ==  ""
        then
          translated.text               =   "\\q{"  ..  translated.text ..  "}"
        else
          translated.text               =   translated.marksLeft  ..  translated.text ..  translated.marksRight
        end
      else
        translated.text                 =   "\\"  ..  translated.marks ..  "{" ..  translated.text ..  "}"
      end
      translated.text                   =   "\\footnotesize"  ..  translated.font ..  "(" ..  translated.type ..  "{" ..  translated.text ..  "})"
      if translated.right
      then
        translated.text                 =   "\\begin{flushright}{"  ..  translated.text ..  "}\\end{flushright}"
      end
      translated.text                   =   "\\par" ..  translated.text
    end

    if  document.quote.author ~=  ""
    then
      document.quote.author               =   "\\par{\\raggedleft\\footnotesize– " ..  document.quote.author ..  "}"
    end

    document.quote.text
    =   original.text
    ..  translated.text
    ..  document.quote.author

    log.debug("document.parseQuote", "Got Text: »"..document.quote.text.."«")
  end
end

function  document.printQuote ( )
  if document.quote.text
  then
    tex.print
    (
      "{~\\vfill\\hfill\\parbox[][][t]{0.618\\linewidth}{\\noWordBreaks "
      ..  document.quote.text
      ..  "\\newpage}{}}"
    )
  end
end
