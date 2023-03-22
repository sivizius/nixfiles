local NewSentence
=   {
      No                                =   0,
      Maybe                             =   1,
      Yes                               =   2,
      Hyphen                            =   3,
    }

local function sentence ( newSentence )
  if      newSentence ==  NewSentence.No
  then
    return  "No"
  elseif  newSentence ==  NewSentence.Maybe
  then
    return  "Maybe"
  elseif  newSentence ==  NewSentence.Yes
  then
    return  "Yes"
  elseif  newSentence ==  NewSentence.Hyphen
  then
    return  "Hyphen"
  else
    return  "???"
  end
end

local NewSentenceAfterCommand
=   {
      [ "," ]                           =   NewSentence.No,
      [ ";" ]                           =   NewSentence.Maybe,
      [ "." ]                           =   NewSentence.Yes,
      [ "-" ]                           =   NewSentence.Hyphen,
      [ "?" ]                           =   false,
      [ "!" ]                           =   false,
    }

spellChecker
=   {
      colours
      =   {
            [ "typo"  ]                 =   "red",
          },
      logFile                           =   buildFiles.create ( "spell" ),
      dictionaries                      =   { },
      --  These command should be inside environments I do not touch.
      --  Otherwise fail, because these commands have weird argument encodings like \cmd+<…>(…){}[…]+;
      --  Parsing these command would bloat the code.
      --  However, I will try to parse other commands,
      --    that should only occur inside environments I do not touch.
      failCommands
      =   {
            [ "arrow"                 ] =   true,
            [ "draw"                  ] =   true,
            [ "makebraces"            ] =   true,
            [ "Makebraces"            ] =   true,
          },
      knownCommands
      =   {
            --  If the command is not known,
            --    optional arguments will be ignored and
            --      mandatory arguments will be checked.
            --  Otherwise while parsing the arguments,
            --    the provided pattern will be used.
            --  Note that weird command that take arguments in a form like \foo+(){}[]{}+
            --    cannot be parsed,
            --      but they should occure only in special, ignored contexts anyway.
            --  Nevertheless such commands should have the pattern "!" to tell the parser
            --    to raise an exception.
            --  If such commands are in not-ignored contexts, escape them with \correct.
            --  String pattern are in the form of "([chi]*[,.][|])?[chi]*[-,;.?!]":
            --    * c for caption:
            --        this argument starts at the beginning of a sentence,
            --          even if the macro is called in the middle of a sentence.
            --    * h for here:
            --        this argument will be placed here
            --    * i for ignore:
            --        this argument will be ignored
            --    * , means:
            --        text after this command is in the middle of a sentence
            --    * . means:
            --        text after this command is at the beginning of a sentence
            --    * - means:
            --        text after this command is after an hyphen
            --    * ; means:
            --        text after this command might be a new sentence
            --    * ? means:
            --        whether the text after this command is in the middle of a new sentence or not
            --          depends on the last character of the last argument or on the context before.
            --    * ! means:
            --        raise an exception, this cannot be parsed
            --  If the pattern is in the form of …|…,
            --    the first part is for optionals and the second for mandatory arguments.
            --  Otherwise optional arguments will be ignored and the pattern is for mandatory arguments.
            [ "acrchem"                 ] =   "!",
            [ "acrdesc"                 ] =   "i.",
            [ "acrfull"                 ] =   "i,",
            [ "acrlong"                 ] =   "i,",
            [ "acrshort"                ] =   "i,",
            [ "acrtext"                 ] =   "i|i?",
            [ "assign"                  ] =   "i|ii!",
            [ "assignVar"               ] =   "ii!",
            [ "cchem"                   ] =   "i|ihi?",
            [ "cfigure"                 ] =   "i|iici?",
            [ "cFigure"                 ] =   "i|iici?",
            [ "cgnuplot"                ] =   "i|iiici?",
            [ "ch"                      ] =   "i,",
            [ "chapter"                 ] =   "i|cc?",
            [ "charge"                  ] =   "ii,",
            [ "chem"                    ] =   "i|ii!",
            [ "chemabove"               ] =   "ii!",
            [ "chembelow"               ] =   "ii!",
            [ "cheme"                   ] =   "i|ii!",
            [ "ctable"                  ] =   "i|iici?",
            [ "chemfig"                 ] =   "i!",
            [ "chemmove"                ] =   "i!",
            [ "chemname"                ] =   "ii!",
            [ "cite"                    ] =   "i|i?",
            [ "claim"                   ] =   "hi?",
            [ "Claim"                   ] =   "hi?",
            [ "compound"                ] =   "i|i,",
            [ "Compound"                ] =   "i|i,",
            [ "correct"                 ] =   "i,",
            [ "defineVar"               ] =   "ih!",
            [ "equations"               ] =   "i?",
            [ "explainVar"              ] =   "i!",
            [ "frac"                    ] =   "ii!",
            [ "footnote"                ] =   "i|c,",
            [ "hchem"                   ] =   "i|ici?",
            [ "hfigure"                 ] =   "i|iici?",
            [ "hFigure"                 ] =   "i|iici?",
            [ "hgnuplot"                ] =   "i|iiici?",
            [ "htable"                  ] =   "i|iici?",
            [ "lchem"                   ] =   "i|ici?",
            [ "left"                    ] =   "i!",
            [ "MayRefchem"              ] =   "i,",
            [ "MayWrapchem"             ] =   "i|icic?",
            [ "Newunit"                 ] =   "ii,",
            [ "nmrH"                    ] =   "i|ii.",
            [ "nmrC"                    ] =   "i|ii.",
            [ "nmrCH"                   ] =   "i|ii.",
            [ "nmrP"                    ] =   "i|ii.",
            [ "nmrPH"                   ] =   "i|ii.",
            [ "parcite"                 ] =   "i?",
            [ "person"                  ] =   "i|i,",
            [ "phantom"                 ] =   "i!",
            [ "Physical"                ] =   "i|iiii,",
            [ "refEquation"             ] =   "i,",
            [ "refFigure"               ] =   "i,",
            [ "refScheme"               ] =   "i,",
            [ "refTable"                ] =   "i,",
            [ "review"                  ] =   "i|ih?",
            [ "reviewBlock"             ] =   "i|i?",
            [ "reviewSide"              ] =   "i|i?",
            [ "right"                   ] =   "i!",
            [ "section"                 ] =   "i|cc?",
            [ "sqrt"                    ] =   "i|i!",
            [ "subfig"                  ] =   "i|iic?",
            [ "Subfig"                  ] =   "i|iic?",
            [ "SubFig"                  ] =   "i|iic?",
            [ "subsection"              ] =   "i|cc?",
            [ "subsubsection"           ] =   "i|cc?",
            [ "subsubsubsection"        ] =   "i|cc?",
            [ "substance"               ] =   "i|i,",
            [ "substanceAbout"          ] =   "i|icc?",
            [ "SubstanceAbout"          ] =   "i|icc?",
            [ "substanceAboutUnwrapped" ] =   "i|icc?",
            [ "substanceAboutUnwrapped" ] =   "i|icc?",
            [ "substanceAboutWrapped"   ] =   "i|icc?",
            [ "SubstanceAboutWrapped"   ] =   "i|icc?",
            [ "substanceAs"             ] =   "i|ii,",
            [ "substanceCode"           ] =   "i|i,",
            [ "SubstanceCode"           ] =   "i|i,",
            [ "substanceFull"           ] =   "i|i,",
            [ "substanceLabel"          ] =   "i?",
            [ "substanceMass"           ] =   "i|i,",
            [ "substanceName"           ] =   "i,",
            [ "substanceSimple"         ] =   "i,",
            [ "substanceWithCode"       ] =   "i|i,",
            [ "Unit"                    ] =   "ii,",
          },
      macros                            =   { },
    }

local State
=   {
      Beginning                         =   0x00,
      Inner                             =   0x01,
      EndSentence                       =   0x02,
      Space                             =   0x03,
      EndWord                           =   0x04,
      Macro                             =   0x10,
      IgnoreArgument                    =   0x11,
      Number                            =   0x12,
      OpenMath                          =   0x20,
      LineMath                          =   0x21,
      LongMath                          =   0x22,
      StopMath                          =   0x23,
      FailSafe                          =   0xee,
      Escape                            =   0xff,
    }

local StateAfterCommand
=   {
      [ "," ]                           =   NewSentence.EndWord,
      [ ";" ]                           =   NewSentence,
      [ "." ]                           =   NewSentence.Beginning,
      [ "-" ]                           =   NewSentence.Hyphen,
      [ "?" ]                           =   false,
      [ "!" ]                           =   false,
    }

local function tostate ( state )
  if      state ==  State.Beginning
  then
    return  "Beginning"
  elseif  state ==  State.Inner
  then
    return  "Inner"
  elseif  state ==  State.EndSentence
  then
    return  "EndSentence"
  elseif  state ==  State.Space
  then
    return  "Space"
  elseif  state ==  State.EndWord
  then
    return  "EndWord"
  elseif  state ==  State.Macro
  then
    return  "Macro"
  elseif  state ==  State.IgnoreArgument
  then
    return  "IgnoreArgument"
  elseif  state ==  State.Number
  then
    return  "Number"
  elseif  state ==  State.OpenMath
  then
    return  "OpenMath"
  elseif  state ==  State.LineMath
  then
    return  "LineMath"
  elseif  state ==  State.LongMath
  then
    return  "LongMath"
  elseif  state ==  State.StopMath
  then
    return  "StopMath"
  elseif  state ==  State.FailSafe
  then
    return  "FailSafe"
  elseif  state ==  State.Escape
  then
    return  "Escape"
  else
    return  "???"
  end
end

local function isSpace  ( char  )
  return  char  ==  " "
  or      char  ==  "~"
  or      char  ==  "\t"
  or      char  ==  "\n"
  or      char  ==  "\r"
end

local function isQuote  ( char  )
  return  char  ==  "»"
  or      char  ==  "«"
  or      char  ==  "›"
  or      char  ==  "‹"
  or      char  ==  "„“"
  or      char  ==  "“"
  or      char  ==  "”"
  or      char  ==  "‚‘"
  or      char  ==  "‘"
  or      char  ==  "’"
end

local Error
=   {
      --- Unknown word, presumably a typo.
      Unknown                           =   0,
      --- Known typo.
      Typo                              =   1,
      --- Word is known, but usually in another case.
      Case                              =   2,
      --- Orthography is fine, but grammar is not.
      Grammar                           =   3,
      --- Unexpected Character.
      Char                              =   4,
    }

local function mark ( error,  comment,  text  )
  local prefix                          =   "\\PDFmarkupComment{"  ..  comment ..  "}{"  ..  text  ..  "}"
  if      error ==  Error.Unknown
  then
    return  prefix  ..  "{Unknown Word}"  ..  "{red}"
  elseif  error ==  Error.Typo
  then
    return  prefix  ..  "{Typo}"          ..  "{red}"
  elseif  error ==  Error.Case
  then
    return  prefix  ..  "{Wrong Case}"    ..  "{orange}"
  elseif  error ==  Error.Grammar
  then
    return  prefix  ..  "{Grammar}"       ..  "{green}"
  elseif  error ==  Error.Char
  then
    return  prefix  ..  "{Character}"     ..  "{blue}"
  else
    log.error
    (
      { "spellChecker.check", "mark"  },
      "Unknown Error: #" ..  tostring ( error ),
      "Text: »" ..  text  ..  "«"
    )
    return  prefix  ..  "{???}"           ..  "{red}"
  end
end

function  spellChecker.check  ( language,   text  )
  log.debug
  (
    "spellChecker.check",
    "Check with »"  ..  language  ..  "«:",
    text
  )
  --  function generates this output, where errors are somehow marked
  local texOutput                       =   ""
  local mdOutput                        =   ""
  --  use this dictionary as reference
  local dictionary                      =   spellChecker.dictionaries [ language  ]
  --  argument stack, might be implemented later
  local argStack                        =   {}
  local ctrStack                        =   0   --  increases with {[ and decreases with ]}
  local theStack                        =   0   --  base for ignoring arguments
  local command                         =   ""
  local optionals                       =   ""
  local arguments                       =   ""
  local onlyCurly                       =   false
  --  state and substate
  local state                           =   State.Beginning
  local escape                          =   State.Escape
  local newSentence                     =   NewSentence.Yes
  --  word or command of interest
  local cWord                           =   ""  --  command word
  local lWord                           =   ""  --  lowercase word
  local tWord                           =   ""  --  unmodified word (the word)
  local uWord                           =   ""  --  uppercase word

  local function leaveMandatory ( )
    command                             =   argStack  [ ctrStack  ].command
    optionals                           =   argStack  [ ctrStack  ].optionals
    arguments                           =   argStack  [ ctrStack  ].arguments
    newSentence                         =   argStack  [ ctrStack  ].newSentence
    spellChecker.logFile:write ( ( "  "  ):rep ( ctrStack  ) ..  "leave mandatory: »"..arguments.."« ("..tostring(ctrStack)..")\n"  )
    ctrStack                            =   ctrStack  - 1
    state                               =   State.EndWord
    if  #arguments  ==  1
    then
      newSentence                       =   NewSentenceAfterCommand [ arguments ] or  newSentence
      if      arguments ==  "!"
      then
        log.fatal ( { "spellChecker.check", "leaveMandatory", },  "Cannot parse special command »"  ..  command ..  "«"  )
      end
      arguments                         =   ""
    end
  end

  local function enterMandatory ( )
    ctrStack                            =   ctrStack  + 1
    spellChecker.logFile:write ( ( "  "  ):rep ( ctrStack  ) ..  "enter mandatory: »"..arguments.."« ("..tostring(ctrStack)..")\n"  )
    optionals                           =   ""
    local this                          =   arguments:sub(1,1)
    arguments                           =   arguments:sub(2)    argStack  [ ctrStack  ]
    =   {
          command                       =   command,
          optionals                     =   optionals,
          arguments                     =   arguments,
          newSentence                   =   newSentence,
        }
    if  this  ==  "c"
    then
      newSentence                       =   NewSentence.Yes
      state                             =   State.Beginning
    elseif  this  ==  "i"
    then
      theStack                          =   ctrStack
      onlyCurly                         =   true
      state                             =   State.IgnoreArgument
    elseif  this  ==  "h"
    or      this  ==  ""
    then
      state                             =   State.Beginning
    elseif  this  ==  "!"
    then
      log.fatal ( { "spellChecker.check", "enterMandatory", },  "Cannot parse special command »"  ..  command ..  "«"  )
    elseif  this  ==  "-"
    or      this  ==  ","
    or      this  ==  ";"
    or      this  ==  "."
    or      this  ==  "?"
    then
      spellChecker.logFile:write ( ( ">>"  ):rep ( ctrStack  ) ..  "should not be mandatory\n"  )
      arguments                         =   this
      leaveMandatory  ( )
    else
      log.fatal
      (
        { "spellChecker.check", "enterMandatory", },
        "Unexpected Character »"  ..  this  ..  "« in pattern »"  ..  ( spellChecker.knownCommands  [ command ] or  ""  ) ..  "« of command »" ..  command ..  "«"
      )
    end
  end

  local function leaveOptional ( )
    command                             =   argStack  [ ctrStack  ].command
    optionals                           =   argStack  [ ctrStack  ].optionals
    arguments                           =   argStack  [ ctrStack  ].arguments
    newSentence                         =   argStack  [ ctrStack  ].newSentence
    spellChecker.logFile:write ( ( "  "  ):rep ( ctrStack  ) ..  "leave optional: »"..optionals.."« ("..tostring(ctrStack)..")\n"  )
    ctrStack                            =   ctrStack  - 1
    state                               =   State.EndWord
  end

  local function enterOptional  ( )
    ctrStack                            =   ctrStack  + 1
    spellChecker.logFile:write ( ( "  "  ):rep ( ctrStack  ) ..  "enter optional: »"..optionals.."« ("..tostring(ctrStack)..")\n"  )
    local this                          =   optionals:sub(1,1)
    optionals                           =   optionals:sub(2)
    argStack  [ ctrStack  ]
    =   {
          command                       =   command,
          optionals                     =   optionals,
          arguments                     =   arguments,
          newSentence                   =   newSentence,
        }
    if  this  ==  "c"
    then
      newSentence                       =   NewSentence.Yes
      state                             =   State.Beginning
    elseif  this  ==  "i"
    or      this  ==  ""
    then
      theStack                          =   ctrStack
      state                             =   State.IgnoreArgument
    elseif  this  ==  "h"
    then
      state                             =   State.Beginning
    elseif  this  ==  "-"
    or      this  ==  ","
    or      this  ==  ";"
    or      this  ==  "."
    or      this  ==  "?"
    then
      spellChecker.logFile:write ( ( ">>"  ):rep ( ctrStack  ) ..  "should not be optional\n"  )
      optionals                         =   this
      leaveOptional ( )
    else
      log.fatal
      (
        { "spellChecker.check", "enterOptional",  },
        "Unexpected Character »"  ..  this  ..  "« in pattern »"  ..  ( spellChecker.knownCommands  [ command ] or  ""  ) ..  "« of command »" ..  command ..  "«"
      )
    end
  end

  spellChecker.logFile:write ( "\n\nInput:\n" ..  text  ..  "\n\n"  )
  if  dictionary
  then
    --  for each utf8-character (does not check, if valid)
    local chars                         =   { }
    for char                            in  text:gmatch("([%z\1-\127\194-\244][\128-\191]*)")
    do
      table.insert  ( chars,  char  )
    end
    local  charsLength                  =   #chars

    for index, char                     in  ipairs  ( chars )
    do
      spellChecker.logFile:write ( ( "  "  ):rep ( ctrStack  ) ..  tostate(state)..": »"..char.."«(" ..  sentence(newSentence)  ..  ")\n"  )
      if      state ==  State.Beginning
      then
        if      containsExact ( dictionary._upper,  char  )
        then
          arguments                     =   ""
          optionals                     =   ""
          lWord                         =   dictionary._lower [ containsWhere ( dictionary._upper,  char  ) ]
          tWord                         =   char
          uWord                         =   char
          state                         =   State.Inner
        elseif  containsExact ( dictionary._lower,  char  )
        then
          arguments                     =   ""
          optionals                     =   ""
          lWord                         =   char
          tWord                         =   char
          uWord                         =   dictionary._upper [ containsWhere ( dictionary._lower,  char  ) ]
          state                         =   State.Inner
        else
          texOutput                     =   texOutput ..  char
          if      char  ==  "\\"
          then
            cWord                       =   ""
            state                       =   State.Macro
          elseif  char  ==  "{"
          then
            enterMandatory  ( )
          elseif  char  ==  "}"
          then
            leaveMandatory  ( )
          elseif  char  ==  "["
          then
            enterOptional   ( )
          elseif  char  ==  "]"
          then
            leaveOptional   ( )
          elseif  char  ==  "$"
          then
            state                       =   State.OpenMath
          elseif  char  ==  "-"
          then
            newSentence                 =   NewSentence.No
          elseif  char  >=  "0"
          and     char  <=  "9"
          then
            arguments                   =   ""
            optionals                   =   ""
            state                       =   State.Number
          elseif  isSpace ( char  )
          or      isQuote ( char  )
          or      char  ==  "("
          or      char  ==  ")" --  (Koordinations-)Chemie
          then
            --  just ignore
          else
            --  should fail?
            spellChecker.logFile:write ( ( ">>"  ):rep ( ctrStack  ) ..  "unexpected character »"..char.."« in Beginning\n" )
            state                       =   State.FailSafe
          end
        end
      elseif  state ==  State.Inner
      then
        if      containsExact ( dictionary._lower,  char  )
        then
          lWord                         =   lWord ..  char
          tWord                         =   tWord ..  char
          uWord                         =   uWord ..  char
        else
          spellChecker.logFile:write  ( ( "  "  ):rep ( ctrStack  ) ..  "check »"..tWord.."« ("..sentence(newSentence)..")\n" )
          if      dictionary  [ tWord ]
          then
            if  newSentence == NewSentence.Yes
            and tWord == lWord
            then
              --  word is usually in lower case, but at beginning of sentences, it has to be uppercase
              spellChecker.logFile:write ( "\n" ..  ( "!!"  ):rep ( ctrStack  ) ..  tWord ..  " (upper case at new sentence expected)\n"  )
              texOutput                 =   texOutput ..  mark  ( Error.Case,     "Upper Case at new sentence expected",  tWord )
            else
              texOutput                 =   texOutput ..  tWord
            end
          elseif  dictionary  [ lWord ]
          then
            if newSentence == NewSentence.No
            then
              --  word is usually lower case, but it is written in upper case here
              spellChecker.logFile:write ( "\n"  ..  ( "!!"  ):rep ( ctrStack  ) ..  tWord ..  " (lower case expected)\n"  )
              texOutput                 =   texOutput ..   mark  ( Error.Case,    "Lower Case expected",                  tWord )
            else
              --  word is usually lower case, but this might be a new sentence
              texOutput                 =   texOutput ..  tWord
            end
          elseif  dictionary  [ uWord ]
          then
            --  word is usually upper case, but it is written in lower case here
            if  newSentence ==  NewSentence.Hyphen
            or  ( ( index + 2 ) <=  charsLength and chars [ index ] ==  "\\"  and chars [ index + 1 ] ==  "-" )
            then
              --  because it is inside another word, e.g. due to Neu\-jahrs\-anfang.
              texOutput                 =   texOutput ..  tWord
            else
              spellChecker.logFile:write ( "\n"  ..  ( "!!"  ):rep ( ctrStack  ) ..  "chars: "  ..  chars [ index ] ..  chars [ index + 1 ] ..  "\n"  )
              spellChecker.logFile:write ( "\n"  ..  ( "!!"  ):rep ( ctrStack  ) ..  tWord ..  " (upper case expected)\n"  )
              texOutput                 =   texOutput ..  mark  ( Error.Case,     "Upper Case expected",                  tWord )
            end
          elseif  newSentence ==  NewSentence.Hyphen
          and     containsExact ( dictionary._ending, lWord )
          then
            newSentence                 =   NewSentence.No
          else
            spellChecker.logFile:write ( "\n"  ..  ( "  "  ):rep ( ctrStack  ) ..  tWord ..  "\n"  )
            texOutput                   =   texOutput ..  mark  ( Error.Unknown,  "Unknown Word",                         tWord )
          end
          if      char  ==  "\\"
          then
            cWord                       =   ""
            state                       =   State.Macro
            newSentence                 =   NewSentence.No
          elseif  char  ==  "{"
          then
            enterMandatory  ( )
          elseif  char  ==  "}"
          then
            leaveMandatory  ( )
          elseif  char  ==  "["
          then
            enterOptional   ( )
          elseif  char  ==  "]"
          then
            leaveOptional   ( )
          elseif  char  ==  "$"
          then
            state                       =   State.OpenMath
          elseif  char  ==  "-"
          then
            newSentence                 =   NewSentence.Hyphen
            state                       =   State.Beginning
          elseif  char  ==  "."
          or      char  ==  "?"
          or      char  ==  "!"
          then
            state                       =   State.EndSentence
          elseif  char  ==  ","
          then
            state                       =   State.Space
            newSentence                 =   NewSentence.No
          elseif  char  ==  ":"
          or      char  ==  ";"
          then
            state                       =   State.Space
            newSentence                 =   NewSentence.Maybe
          elseif  isSpace ( char  )
          then
            state                       =   State.Beginning
            newSentence                 =   NewSentence.No
          elseif  isQuote ( char  )
          or      char  ==  ")"
          then
            state                       =   State.EndWord
            newSentence                 =   NewSentence.No
          else
            spellChecker.logFile:write ( ( ">>"  ):rep ( ctrStack  ) ..  "unexpected character »"..char.."« in Inner\n" )
            texOutput                   =   texOutput ..  mark  ( Error.Char, "Unexpected Character", char  )
            char                        =   ""
            state                       =   State.FailSafe
          end
          texOutput                     =   texOutput ..  char
        end
      else
        if      state ==  State.FailSafe
        then
          --  do nothing special
        elseif  state ==  State.EndSentence
        then
          newSentence                   =   NewSentence.Yes
          if      isSpace ( char  )
          then
            state                       =   State.Beginning
          elseif  isQuote ( char  )
          or      char  ==  ")"
          then
            state                       =   State.EndWord
            newSentence                 =   NewSentence.No
          elseif  char  ==  "."
          or      char  ==  "?"
          or      char  ==  "!"
          then
            --  bad style, but ok
          elseif  char  ==  "\\"
          then
            cWord                       =   ""
            state                       =   State.Macro
          elseif  char  ==  "}"
          then
            leaveMandatory  ( )
          elseif  char  ==  "]"
          then
            leaveOptional   ( )
          else
            --  should fail?
            spellChecker.logFile:write ( ( ">>"  ):rep ( ctrStack  ) ..  "unexpected character »"..char.."« in EndSentence\n" )
            state                       =   State.FailSafe
          end
        elseif  state ==  State.Space
        then
          if      isSpace ( char  )
          then
            state                       =   State.Beginning
          elseif  char  ==  "\\"
          then
            cWord                       =   ""
            state                       =   State.Macro
          elseif  char  ==  "}"
          then
            leaveMandatory  ( )
          elseif  char  ==  "]"
          then
            leaveOptional   ( )
          else
            -- should fail?
            spellChecker.logFile:write ( ( ">>"  ):rep ( ctrStack  ) ..  "unexpected character »"..char.."« in Space\n" )
            state                       =   State.FailSafe
          end
        elseif  state ==  State.EndWord
        then
          if      isSpace ( char  )
          then
            state                       =   State.Beginning
          elseif  isQuote ( char  )
          or      char  ==  ")"
          or      char  ==  "/"
          then
            state                       =   State.EndWord
            newSentence                 =   NewSentence.No
          elseif  char  ==  "\\"
          then
            cWord                       =   ""
            state                       =   State.Macro
          elseif  char  ==  "{"
          then
            enterMandatory  ( )
          elseif  char  ==  "}"
          then
            leaveMandatory  ( )
          elseif  char  ==  "["
          then
            enterOptional   ( )
          elseif  char  ==  "]"
          then
            leaveOptional   ( )
          elseif  char  ==  "-"
          then
            newSentence                 =   NewSentence.Hyphen
            state                       =   State.Beginning
          elseif  char  ==  "."
          or      char  ==  "?"
          or      char  ==  "!"
          then
            state                       =   State.EndSentence
          elseif  char  ==  ","
          then
            state                       =   State.Space
            newSentence                 =   NewSentence.No
          elseif  char  ==  ":"
          or      char  ==  ";"
          then
            state                       =   State.Space
            newSentence                 =   NewSentence.Maybe
          elseif  containsExact ( dictionary._lower,  char  )
          then
            lWord                       =   char
            tWord                       =   char
            uWord                       =   dictionary._upper [ containsWhere ( dictionary._lower,  char  ) ]
            newSentence                 =   NewSentence.Hyphen
            state                       =   State.Inner
            char                        =   ""
          else
            -- should fail?
            spellChecker.logFile:write ( ( ">>"  ):rep ( ctrStack  ) ..  "unexpected character »"..char.."« in EndWord\n" )
            state                       =   State.FailSafe
          end
        elseif  state ==  State.Macro
        then
          if      char:match  ( "%a"  )
          then
            cWord                       =   cWord ..  char
          else
            spellChecker.logFile:write ( ( "  "  ):rep ( ctrStack  ) ..  "Macro: "..cWord )
            command                     =   cWord
            if  char  ~=  "\\"
            then
              if  command ==  "-"
              then
                state                     =   State.Beginning
                newSentence               =   NewSentence.Hyphen
              else
                local entry               =   spellChecker.knownCommands [ cWord ]
                if      entry
                then
                  local left, right       =   entry:match ( "([chi]*)|([chi]*[-,;.?!]?)"  )
                  if left and right
                  then
                    optionals             =   left
                    arguments             =   right
                  elseif  entry ==  "!"
                  then
                    log.fatal ( "spellChecker.check", "Cannot parse special command »"  ..  cWord ..  "«" )
                  else
                    optionals             =   ""
                    arguments             =   entry
                  end
                  spellChecker.logFile:write  ( "\n"  ..  ( "  "  ):rep ( ctrStack  ) ..  "\\"  ..  cWord ..  "[" ..  optionals ..  "]{"  ..  arguments ..  "}" )
                elseif  spellChecker.failCommands [ cWord ]
                then
                  log.fatal ( "spellChecker.check", "Found the failCommand »\\" ..  cWord ..  "«" )
                else
                  spellChecker
                  .macros [ cWord ]       =   true
                  optionals               =   ""
                  arguments               =   ""
                end
                if      isSpace ( char  )
                then
                  state                   =   State.Beginning
                elseif  isQuote ( char  )
                or      char  ==  ")"
                then
                  state                       =   State.EndWord
                  newSentence                 =   NewSentence.No
                elseif  char  ==  "}"
                then
                  leaveMandatory  ( )
                elseif  char  ==  "]"
                then
                  leaveOptional   ( )
                elseif  char  ==  "{"
                then
                  enterMandatory  ( )
                elseif  char  ==  "["
                then
                  enterOptional   ( )
                elseif  char  ==  "-"
                then
                  newSentence           =   NewSentence.Hyphen
                  state                 =   State.Beginning
                elseif  char  ==  "."
                or      char  ==  "?"
                or      char  ==  "!"
                then
                  state                 =   State.EndSentence
                elseif  char  ==  ","
                then
                  state                 =   State.Space
                  newSentence           =   NewSentence.No
                elseif  char  ==  ":"
                then
                  state                 =   State.Space
                  newSentence           =   NewSentence.Maybe
                else
                  state                 =   State.Beginning
                end
              end
            else
              cWord                     =   ""
            end
            spellChecker.logFile:write ( "\n"  )
          end
        elseif  state ==  State.IgnoreArgument
        then
          if    char  ==  "}"
          or    ( char  ==  "]" and not onlyCurly )
          then
            if  ctrStack  ==  theStack
            then
              state                     =   State.Beginning
              onlyCurly                 =   false
              if char == "}"
              then
                leaveMandatory  ( )
              else
                leaveOptional   ( )
              end
            else
              ctrStack                  =   ctrStack  - 1
            end
          elseif  char  ==  "{"
          or      ( char  ==  "[" and not onlyCurly )
          then
            ctrStack                    =   ctrStack  + 1
          elseif  char  ==  "\\"
          then
            escape                      =   State.IgnoreArgument
            state                       =   State.Escape
          else
            --  just ignore
          end
        elseif  state ==  State.Number
        then
          if      isSpace ( char  )
          then
            state                   =   State.Beginning
          elseif  char  ==  "}"
          then
            leaveMandatory  ( )
          elseif  char  ==  "]"
          then
            leaveOptional   ( )
          elseif  char  ==  "{"
          then
            enterMandatory  ( )
          elseif  char  ==  "["
          then
            enterOptional   ( )
          else
            --  just ignore
          end
        elseif  state ==  State.OpenMath
        then
          if char == "$"
          then
            state                       =   State.LongMath
          elseif  char  ==  "\\"
          then
            escape                      =   State.LineMath
            state                       =   State.Escape
          else
            state                       =   State.LineMath
          end
        elseif  state ==  State.LineMath
        then
          if      char  ==  "$"
          then
            state                       =   State.EndWord
            newSentence                 =   NewSentence.No
          elseif  char  ==  "\\"
          then
            escape                      =   State.LineMath
            state                       =   State.Escape
          else
            --  just ignore
          end
        elseif  state ==  State.LongMath
        then
          if      char  ==  "$"
          then
            state                       =   spellStopMath
          elseif  char  ==  "\\"
          then
            escape                      =   State.LongMath
            state                       =   State.Escape
          else
            --  just ignore
          end
        elseif  state ==  State.StopMath
        then
          if      char  ==  "$"
          then
            state                       =   State.EndWord
            newSentence                 =   NewSentence.Yes
          elseif  char  ==  "\\"
          then
            escape                      =   State.LongMath
            state                       =   State.Escape
          else
            state                       =   State.LongMath
          end
        elseif  state ==  State.Escape
        then
          state                         =   escape
        else
          spellChecker.logFile:write ( "Invalid State\n" )
        end
        texOutput                       =   texOutput ..  char
      end
    end
    log.info
    (
      "spellChecker.check",
      "Checked:",
      "»"..texOutput.."«"
    )
    spellChecker.logFile:write ( "Output checked:\n" .. texOutput )
    tex.print(texOutput)
  else
    log.warn
    (
      "spellChecker.check",
      "Cannot check spelling, because dictionary »" ..  language  ..  "« was not loaded.",
      "Use \\loadDictionary{…} to load dictionary file."
    )
    spellChecker.logFile:write ( "Output unchecked:\n" .. text )
    tex.print(text)
  end
end

function  spellChecker.loadDictionary ( dict  )
  local fileName                        =   source  ..  "assets/dictionaries/"  ..  dict  ..  ".lua"
  markFileAsUsed  ( fileName  )
  local file                            =   loadfile  ( fileName  )
  if  file
  then
    spellChecker.dictionaries [ dict  ] =   file  ( )
  else
    log.fatal ( "spellChecker.loadDictionary",  "Cannot load dictionary »"  ..  dict  ..  "« (" ..  fileName  ..  ")" )
  end
end

function  spellChecker.listMacros ( )
  spellChecker.logFile:write ( "\n\nFound these macros:\n" )
  for index, ignore                     in  pairs ( spellChecker.macros )
  do
    spellChecker.logFile:write ( "\\" ..  index ..  "\n" )
  end
end
