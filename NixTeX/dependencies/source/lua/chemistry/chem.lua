--chLevel                                 =   0
chem                                    =   { }
includeCode ( "chemistry/spectra"     )
includeCode ( "chemistry/xray"        )

local CouldBe
=   {
      --  Default.
      Default                           =   0x00,
      --  After » « no sub/superscript shall follow.
      Normal                            =   0x01,
      --  After »)« a subscript value might follow.
      SubScript                         =   0x02,
      --  After »]« a superscript value might follow.
      SuperScript                       =   0x03,
    }

local Special
=   {
      [ "i" ]                           =   "\\textit{i}",
      [ "m" ]                           =   "\\textit{m}",
      [ "o" ]                           =   "\\textit{o}",
      [ "p" ]                           =   "\\textit{p}",
    }

local Greek
=   {
      [ "a" ]                           =   "α",
      [ "b" ]                           =   "β",
      [ "c" ]                           =   "ψ",
      [ "d" ]                           =   "δ",
      [ "e" ]                           =   "ε",
      [ "f" ]                           =   "φ",
      [ "g" ]                           =   "γ",
      [ "h" ]                           =   "η",
      [ "i" ]                           =   "ι",
      [ "j" ]                           =   "ξ",
      [ "k" ]                           =   "κ",
      [ "l" ]                           =   "λ",
      [ "m" ]                           =   "μ",
      [ "n" ]                           =   "ν",
      [ "o" ]                           =   "ο",
      [ "p" ]                           =   "π",
      [ "q" ]                           =   "ϑ",
      [ "r" ]                           =   "ρ",
      [ "s" ]                           =   "σ",
      [ "t" ]                           =   "τ",
      [ "u" ]                           =   "θ",
      [ "v" ]                           =   "ω",
      [ "w" ]                           =   "ς",
      [ "x" ]                           =   "χ",
      [ "y" ]                           =   "ζ",
      [ "z" ]                           =   "υ",
    }

local Operators
=   {
      [ "+" ]                           =   { "~+~",  " + ",  "+" },
      [ "-" ]                           =   { "-",    "-",    "−" },
      [ "*" ]                           =   { "·",    "·",    "·" },
    }

local PseudoAcronyms
=   {
      [ "=" ]                           =   { "", "⇌",  },
      [ "-" ]                           =   { "", "↔",  },
    }

local States
=   {
      --  Default and Initial State.
      Default                           =   0x00,
      --  Starting with »_«.
      SubScript                         =   0x01,
      --  Starting with »_(«.
      SubScriptGroup                    =   0x02,
      --  Starting with a number immediately after a token.
      SubScriptNumber                   =   0x03,
      --  Starting with »^«.
      SuperScript                       =   0x04,
      --  Starting with »^(«.
      SuperScriptGroup                  =   0x05,
      --  Starting with »+« or »-« immediately after a token.
      SuperScriptNumber                 =   0x06,
      --  Starting with »[«: Put text as it is, without parsing.
      Text                              =   0x07,
      --  Replace »<acronym>« with the short-form of »acronym«.
      Acronym                           =   0x08,
      Special                           =   0x09,
    }

States.Script                           =   States.SubScript
States.ScriptGroup                      =   States.SubScriptGroup
States.Ignore                           =   States.Text

local SubScripts
=   {
      [ "0" ]                           =   "₀",
      [ "1" ]                           =   "₁",
      [ "2" ]                           =   "₂",
      [ "3" ]                           =   "₃",
      [ "4" ]                           =   "₄",
      [ "5" ]                           =   "₅",
      [ "6" ]                           =   "₆",
      [ "7" ]                           =   "₇",
      [ "8" ]                           =   "₈",
      [ "9" ]                           =   "₉",
      [ "a" ]                           =   "ₐ",
      [ "e" ]                           =   "ₑ",
      [ "h" ]                           =   "ₕ",
      [ "i" ]                           =   "ᵢ",
      [ "j" ]                           =   "ⱼ",
      [ "k" ]                           =   "ₖ",
      [ "l" ]                           =   "ₗ",
      [ "m" ]                           =   "ₘ",
      [ "n" ]                           =   "ₙ",
      [ "o" ]                           =   "ₒ",
      [ "p" ]                           =   "ₚ",
      [ "r" ]                           =   "ᵣ",
      [ "s" ]                           =   "ₛ",
      [ "t" ]                           =   "ₜ",
      [ "u" ]                           =   "ᵤ",
      [ "v" ]                           =   "ᵥ",
      [ "x" ]                           =   "ₓ",
    }

local SuperScripts
=   {
      [ "0" ]                           =   "⁰",
      [ "1" ]                           =   "¹",
      [ "2" ]                           =   "²",
      [ "3" ]                           =   "³",
      [ "4" ]                           =   "⁴",
      [ "5" ]                           =   "⁵",
      [ "6" ]                           =   "⁶",
      [ "7" ]                           =   "⁷",
      [ "8" ]                           =   "⁸",
      [ "9" ]                           =   "⁹",
      [ "+" ]                           =   "⁺",
      [ "−" ]                           =   "⁻",
      [ "a" ]                           =   "ᵃ",
      [ "b" ]                           =   "ᵇ",
      [ "c" ]                           =   "ᶜ",
      [ "d" ]                           =   "ᵈ",
      [ "e" ]                           =   "ᵉ",
      [ "f" ]                           =   "ᶠ",
      [ "g" ]                           =   "ᵍ",
      [ "h" ]                           =   "ʰ",
      [ "i" ]                           =   "ⁱ",
      [ "j" ]                           =   "ʲ",
      [ "k" ]                           =   "ᵏ",
      [ "l" ]                           =   "ˡ",
      [ "m" ]                           =   "ᵐ",
      [ "n" ]                           =   "ⁿ",
      [ "o" ]                           =   "ᵒ",
      [ "p" ]                           =   "ᵖ",
      [ "r" ]                           =   "ʳ",
      [ "s" ]                           =   "ˢ",
      [ "t" ]                           =   "ᵗ",
      [ "u" ]                           =   "ᵘ",
      [ "v" ]                           =   "ᵛ",
      [ "w" ]                           =   "ʷ",
      [ "x" ]                           =   "ˣ",
      [ "y" ]                           =   "ʸ",
      [ "z" ]                           =   "ᶻ",
    }

local function subScriptChar    ( char, state )
  local entry                           =   SubScripts    [ char  ]
  if  entry
  then
    state.pdfString                     =   state.pdfString ..  entry
  else
    state.pdfString                     =   state.pdfString ..  "_" ..  char
  end
  state.texString                       =   state.texString ..  "\\textsubscript{"    ..  char  ..  "}"
  return  state
end

local function subScriptText    ( char, state )
  local entry                           =   SubScripts    [ char  ]
  if  entry
  then
    state.pdfString                     =   state.pdfString ..  entry
  else
    state.pdfString                     =   state.pdfString ..  char
  end
  state.temp                            =   state.temp  ..  char
  return  state
end

local function superScriptChar  ( char, state )
  local entry                           =   SubScripts    [ char  ]
  if  entry
  then
    state.pdfString                     =   state.pdfString ..  entry
  else
    state.pdfString                     =   state.pdfString ..  "^" ..  char
  end
  state.texString                       =   state.texString ..  "\\textsuperscript{"  ..  char  ..  "}"
  return  state
end

local function superScriptText  ( char, state )
  local entry                           =   SuperScripts  [ char  ]
  if  entry
  then
    state.pdfString                     =   state.pdfString ..  entry
  else
    state.pdfString                     =   state.pdfString ..  char
  end
  state.temp                            =   state.temp  ..  char
  return  state
end

-- Parse the Default state.
local function parseDefault     ( char, state )
  if      char  >=  "0"
  and     char  <=  "9"
  then
    if      state.couldBe ==  CouldBe.Normal
    then
      state.texString                   =   state.texString ..  char
      state.pdfString                   =   state.pdfString ..  char
      state.kind                        =   States.Default
    else
      state.temp                        =   char
      state.pdfString                   =   state.pdfString ..  SubScripts  [ char  ]
      state.kind                        =   States.SubScriptNumber
      state.couldBe                     =   CouldBe.Default
    end
  elseif  char  >=  "A"
  and     char  <=  "Z"
  then
    state.texString                     =   state.texString ..  char
    state.pdfString                     =   state.pdfString ..  char
    state.kind                          =   States.Default
    state.couldBe                       =   CouldBe.Default
  elseif  char  >=  "a"
  and     char  <=  "z"
  then
    if      state.couldBe ==  CouldBe.Normal
    then
      state.texString                   =   state.texString ..  Greek [ char  ]
      state.pdfString                   =   state.pdfString ..  Greek [ char  ]
      state.kind                        =   States.SuperScriptNumber
    elseif  state.couldBe ==  CouldBe.SubScript
    then
      state                             =   subScriptChar   ( char, state )
    elseif  state.couldBe ==  CouldBe.SuperScript
    then
      state                             =   superScriptChar ( char, state )
    else
      state.texString                   =   state.texString ..  char
      state.pdfString                   =   state.pdfString ..  char
      state.kind                        =   States.Default
    end
    state.couldBe                       =   CouldBe.Default
  elseif  char  ==  "+"
  or      char  ==  "-"
  or      char  ==  "*"
  then
    if  state.couldBe ==  CouldBe.Normal
    then
      state.texString                   =   state.texString ..  Operators [ char  ] [ 1 ]
      state.pdfString                   =   state.pdfString ..  Operators [ char  ] [ 2 ]
      state.kind                        =   States.Default
    else
      state.temp                        =   Operators [ char  ] [ 3 ]
      state.pdfString                   =   state.pdfString ..  ( SuperScripts  [ char  ] or  char  )
      state.kind                        =   States.SuperScriptNumber
    end
    state.couldBe                       =   CouldBe.Default
  elseif  char  ==  "."
  then
    state.texString                     =   state.texString ..  "•"
    state.pdfString                     =   state.pdfString ..  "•"
    state.kind                          =   States.Default
    state.couldBe                       =   CouldBe.Normal
  elseif  char  ==  "/"
  then
    if  state.italic
    then
      state.texString                   =   state.texString ..  "}"
      state.italic                      =   false
    else
      state.texString                   =   state.texString ..  "\\textit{"
      state.italic                      =   true
    end
  elseif  char  ==  "("
  then
    state.depth                         =   state.depth + 1
    local index                         =   state.maximum [ state.index ]
    if      state.depth ==  index
    then
      char                              =   "("
    elseif  state.depth ==  index - 1
    then
      char                              =   "["
    else
      char                              =   "\\{"
    end
    state.texString                     =   state.texString ..  char
    state.pdfString                     =   state.pdfString ..  char
    state.kind                          =   States.Default
    state.couldBe                       =   CouldBe.Normal
  elseif  char  ==  ")"
  then
    local index                         =   state.maximum [ state.index ]
    if      state.depth ==  index
    then
      char                              =   ")"
    elseif  state.depth ==  index - 1
    then
      char                              =   "]"
    else
      char                              =   "\\}"
    end
    if  state.depth ==  0
    then
      state.index                       =   state.index + 1
    end
    state.texString                     =   state.texString ..  char
    state.pdfString                     =   state.pdfString ..  char
    state.depth                         =   state.depth - 1
    state.kind                          =   States.Default
    state.couldBe                       =   CouldBe.SubScript
  elseif  char  ==  "<"
  then
    state.temp                          =   ""
    state.kind                          =   States.Acronym
    state.couldBe                       =   CouldBe.Default
  elseif  char  ==  "_"
  then
    state.kind                          =   States.SubScript
    state.couldBe                       =   CouldBe.Default
  elseif  char  ==  "^"
  then
    state.kind                          =   States.SuperScript
    state.couldBe                       =   CouldBe.SubScript
  elseif  char  ==  "\""
  or      char  ==  "'"
  then
    state.temp                          =   char
    state.kind                          =   States.Text
    state.couldBe                       =   CouldBe.Normal
  elseif  char  ==  " "
  then
    if state.last == ","
    then
      state.texString                   =   state.texString ..  " "
      state.pdfString                   =   state.pdfString ..  " "
    end
    state.kind                          =   States.Default
    state.couldBe                       =   CouldBe.Normal
  elseif  char  ==  "="
  or      char  ==  ","
  then
    state.texString                     =   state.texString ..  char
    state.pdfString                     =   state.pdfString ..  char
    state.kind                          =   States.Default
    state.couldBe                       =   CouldBe.Normal
  elseif  char  ==  "§"
  then
    state.texString                     =   state.texString ..  "$\\equiv$"
    state.pdfString                     =   state.pdfString ..  "≡"
    state.kind                          =   States.Default
    state.couldBe                       =   CouldBe.Normal
  elseif  char  ==  "@"
  then
    state.kind                          =   States.Special
    state.couldBe                       =   CouldBe.Normal
  else
    log.fatal
    (
      { "nextState",  "Default",  },
      "Unexpected Character: »" ..  char  ..  "«"
    )
  end
  return  state
end

--  Go to next State.
local function nextState        ( char, state )
  if      state.kind  ==  States.Default
  --  (Default, SubScript, SubScriptNumber, SuperScript, SuperScriptNumber, Text, Acronym )
  then
    state                               =   parseDefault  ( char, state )
  elseif  state.kind  ==  States.SubScript
  --  (SubScriptGroup, Default)
  then
    if  char  ==  "("
    then
      state.temp                        =   ""
      state.kind                        =   States.SubScriptGroup
    else
      state                             =   subScriptChar   ( char, state )
      state.kind                        =   States.Default
    end
  elseif  state.kind  ==  States.SubScriptGroup
  --  (SubScriptGroup, Default)
  then
    if      char  ==  ")"
    then
      if  state.count ==  0
      then
        state.texString                 =   state.texString ..  "\\textsubscript{"  ..    state.temp ..  "}"
        state.kind                      =   States.Default
      else
        state.count                     =   state.count - 1
        state.temp                      =   state.temp      ..  ")"
        state.pdfString                 =   state.pdfString ..  "₎"
      end
    elseif  char  ==  "("
    then
      state.count                       =   state.count + 1
      state.temp                        =   state.temp      ..  "("
      state.pdfString                   =   state.pdfString ..  "₍"
    else
      state                             =   subScriptText   ( char, state )
    end
  elseif  state.kind  ==  States.SubScriptNumber
  --  (SubScriptNumber, Default)
  then
    if      char  >=  "0"
    and     char  <=  "9"
    then
      state.temp                        =   state.temp      ..  char
      state.pdfString                   =   state.pdfString ..  SubScripts    [ char  ]
    else
      if state.temp ~= ""
      then
        state.texString                 =   state.texString ..  "\\textsubscript{"  ..    state.temp  ..  "}"
        state.temp                      =   ""
      end
      state                             =   parseDefault  ( char, state )
    end
  elseif  state.kind  ==  States.SuperScript
  --  (SuperScriptGroup, Default)
  then
    if  char  ==  "("
    then
      state.temp                        =   ""
      state.kind                        =   States.SuperScriptGroup
    else
      state                             =   superScriptChar ( char, state )
      state.kind                        =   States.Default
    end
  elseif  state.kind  ==  States.SuperScriptGroup
  --  (SuperScriptGroup, Default)
  then
    if      char  ==  ")"
    then
      if  state.count ==  0
      then
        state.texString                 =   state.texString ..  "\\textsuperscript{"  ..  state.temp  ..  "}"
        state.kind                      =   States.Default
      else
        state.count                     =   state.count - 1
        state.temp                      =   state.temp      ..  ")"
        state.pdfString                 =   state.pdfString ..  "⁾"
      end
    elseif  char  ==  "("
    then
      state.count                       =   state.count + 1
      state.temp                        =   state.temp      ..  "("
      state.pdfString                   =   state.pdfString ..  "⁽"
    else
      state                             =   superScriptText ( char, state )
    end
  elseif  state.kind  ==  States.SuperScriptNumber
  --  (SuperScriptNumber, Default)
  then
    if      char  >=  "0"
    and     char  <=  "9"
    then
      state.temp                        =   state.temp      ..  char
      state.pdfString                   =   state.pdfString ..  SuperScripts  [ char  ]
    elseif  char        ==  "+"
    and     state.temp  ==  "+"
    then
      state.temp                        =   "{\\oplus}"
    elseif  char        ==  "-"
    and     state.temp  ==  "−"
    then
      state.temp                        =   "{\\ominus}"
    else
      if state.temp ~= ""
      then
        state.texString                 =   state.texString ..  "\\textsuperscript{"  ..  state.temp  ..  "}"
        state.temp                      =   ""
      end
      state                             =   parseDefault  ( char, state )
    end
  elseif  state.kind  ==  States.Text
  --  (Text, Default)
  then
    if      char  ==  state.temp
    then
      state.kind                        =   States.Default
    else
      state.texString                   =   state.texString ..  char
      state.pdfString                   =   state.pdfString ..  char
    end
  elseif  state.kind  ==  States.Acronym
  --  (Acronym, Default)
  then
    if  char  ==  ">"
    then
      local entry                       =   PseudoAcronyms  [ state.temp  ]
      if  entry
      then
        state.texString                 =   state.texString ..  entry [ 1 ]
        state.pdfString                 =   state.pdfString ..  entry [ 2 ]
      else
        local entry                     =   acronyms.getEntry ( state.temp, state.lazy  )
        if  entry
        then
          state.texString               =   state.texString ..  entry.short [ 1 ]
          state.pdfString               =   state.pdfString ..  entry.short [ 2 ]
        elseif state.lazy
        then
          state.texString               =   state.texString ..  "\\acrshort{" ..  state.temp  ..  "}"
          state.pdfString               =   state.pdfString ..  "\\acrshort{" ..  state.temp  ..  "}"
        else
          state.texString               =   state.texString ..  "¿¿"  ..  state.temp  ..  "??"
          state.pdfString               =   state.pdfString ..  "¿¿"  ..  state.temp  ..  "??"
        end
      end
      state.kind                        =   States.Default
    else
      state.temp                        =   state.temp  ..  char
    end
  elseif  state.kind  ==  States.Special
  --  (Default)
  then
    state.texString                     =   state.texString ..  Special [ char  ]
    state.pdfString                     =   state.texString ..  Special [ char  ]
    state.kind                          =   States.Default
  else
    log.fatal
    (
      "nextState",
      "Invalid State: " ..  tostring  ( state.kind  )
    )
  end
  state.last                            =   char
  return  state
end

--  Go to prepare state.
local function prepare          ( char, state )
  if      state.kind  ==  States.Default
  --  (Default, SubScript, SubScriptNumber, SuperScript, SuperScriptNumber, Text, Acronym )
  then
    if      ( char  >=  "0" and char  <=  "9" )
    or      char  ==  " "
    or      char  ==  "+"
    or      char  ==  "-"
    or      char  ==  "*"
    or      char  ==  "/"
    or      char  ==  "."
    or      char  ==  "="
    or      char  ==  "§"
    or      char  ==  ","
    or      char  ==  "@"
    then
      state.kind                        =   States.Default
    elseif  ( char  >=  "A" and char  <=  "Z" )
    or      ( char  >=  "a" and char  <=  "z" )
    then
      state.sortBy                      =   state.sortBy  ..  char
      state.kind                        =   States.Default
    elseif  char  ==  "("
    then
      state.sortBy                      =   state.sortBy
      state.depth                       =   state.depth + 1
      state.kind                        =   States.Default
    elseif  char  ==  ")"
    then
      state.sortBy                      =   state.sortBy
      if  state.depth > state.maximum [ #state.maximum  ]
      then
        state.maximum [ #state.maximum  ]
        =   state.depth
      end
      state.depth                       =   state.depth - 1
      if  state.depth ==  0
      then
        table.insert  ( state.maximum,  0 )
      end
      state.kind                        =   States.Default
    elseif  char  ==  "<"
    then
      state.temp                        =   ""
      state.kind                        =   States.Acronym
    elseif  char  ==  "_"
    or      char  ==  "^"
    then
      state.kind                        =   States.Script
    elseif  char  ==  "\""
    or      char  ==  "'"
    then
      state.temp                        =   char
      state.kind                        =   States.Ignore
    else
      log.fatal
      (
        { "prepare",  "Default",  },
        "Unexpected Character: »" ..  char  ..  "«"
      )
    end
  elseif  state.kind  ==  States.Script
  --  (ScriptGroup, Default)
  then
    if  char  ==  "("
    then
      state.kind                        =   States.ScriptGroup
    else
      state.kind                        =   States.Default
    end
  elseif  state.kind  ==  States.ScriptGroup
  --  (ScriptGroup, Default)
  then
    if      char  ==  ")"
    then
      if  state.count ==  0
      then
        state.kind                      =   States.Default
      else
        state.count                     =   state.count - 1
      end
    elseif  char  ==  "("
    then
      state.count                       =   state.count + 1
    end
  elseif  state.kind  ==  States.Acronym
  --  (Acronym, Default)
  then
    if      char  ==  ">"
    then
      local entry                       =   PseudoAcronyms  [ state.temp  ]
      if  entry
      then
        state.sortBy                    =   state.sortBy  ..  entry [ 2 ]
      else
        local entry                     =   acronyms.getEntry ( state.temp, true  )
        if  entry
        then
          state.sortBy
          =   state.sortBy
          ..  entry.short [ 2 ]:gsub  ( "[0-9 +%-*/.=§,@()\128-\255]",  ""  )
        else
          state.sortBy                  =   state.sortBy  ..  "<" ..  state.temp  ..  ">"
        end
      end
      state.kind                        =   States.Default
    else
      state.temp                        =   state.temp  ..  char
    end
  elseif  state.kind  ==  States.Ignore
  --  (Ignore, Default)
  then
    if      char  ==  state.temp
    then
      state.kind                        =   States.Default
    else
      state.sortBy                      =   state.sortBy  ..  char
    end
  else
    log.fatal
    (
      "prepare",
      "Invalid State: " ..  tostring  ( state.kind  )
    )
  end
  return  state
end

-- Frontend
function  chem.parseSimple      ( formula, lazy )
  log.debug("chem.parseSimple", "parse: »" ..  formula ..  "«")
  local state
  =   {
        kind                            =   States.Default,
        temp                            =   "",
        maximum                         =   { 0 },
        depth                           =   0,
        count                           =   0,
        sortBy                          =   "",
      }
  for char                              in  formula:utf8split ( )
  do
    state                               =   prepare   ( char, state )
  end
  local state
  =   {
        kind                            =   States.Default,
        temp                            =   "",
        couldBe                         =   CouldBe.Normal,
        maximum                         =   state.maximum,
        index                           =   1,
        depth                           =   0,
        count                           =   0,
        italic                          =   false,
        texString                       =   "",
        pdfString                       =   "",
        sortBy                          =   state.sortBy,
        lazy                            =   lazy,
        last                            =   "",
      }
  for char                              in  formula:utf8split ( )
  do
    --log.debug("nextState", "state: »" .. tostring ( state.kind  ) ..  "«, char: "..char)
    state                               =   nextState ( char, state )
  end
  if  state.italic
  then
    state.texString                     =   state.texString ..  "}"
    state.italic                        =   false
  end
  if  state.kind  ==  States.Default
  then
    --  just fine
  elseif  state.kind  ==  States.SubScriptNumber
  then
    state.texString                     =   state.texString ..  "\\textsubscript{"    ..  state.temp  ..  "}"
  elseif  state.kind  ==  States.SuperScriptNumber
  then
    state.texString                     =   state.texString ..  "\\textsuperscript{"  ..  state.temp  ..  "}"
  else
    log.fatal
    (
      "chem.parseSimple",
      "Invalid Final Parser State: "  ..  tostring  ( state.kind  )
    )
  end
  --log.debug("chem.parseSimple", "got »"..state.texString.."«|»"..state.pdfString.."«")
  return  "\\mbox{"..state.texString.."}",
          state.pdfString,
          state.sortBy.."\a"..state.pdfString
end

function  chem.printSimple      ( formula )
  local texString, pdfString            =   chem.parseSimple  ( formula )
  tex.print ( "\\texorpdfstring{{"  ..  texString ..  "}}{{"  ..  pdfString ..  "}}"  )
end
