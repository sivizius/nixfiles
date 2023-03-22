fluent
=   {
      languages                         =   { "deu",  "eng",  },
      snippets                          =   { },
    }

function  fluent.check  ( snippet,  definition  )
  if      type  ( definition  ) ==  "table"
  then
    if  not definition.eng
    then
      log.warn
      (
        { "fluent.add", "fluent.check", }
        "No translation to english defined for snippet " ..  tostring  ( snippet ) ..  "!",
        "At least a translation to english should exist."
      )
      if  not definition  [ 1 ]
      then
        log.warn
        (
          { "fluent.add", "fluent.check", }
          "No default translation defined for snippet " ..  tostring  ( snippet ) ..  "!",
          "Even if there is no translation to english, there must be default translation."
        )
      end
    else
      for index,  language              in  ipairs  ( fluent.languages  )
      do
        if  not definition  [ language  ]
        then
          log.warn
          (
            { "fluent.add", "fluent.check", }
            "No translation to language " ..  tostring  ( language  )
            ..  " defined for snippet " ..  tostring  ( snippet ) ..  "!"
            "There should be a translation available for all languages."
          )
        end
      end
    end
  elseif  type  ( definition  ) ~=  "string"
  and     type  ( definition  ) ~=  "function"
  then
    log.error
    (
      { "fluent.add", "fluent.check", }
      "Invalid type of definition for snippet " ..  tostring  ( snippet ) ..  "!",
      "Must be either of type string, table or function."
    )
  end
end

function  fluent.add        ( snippet,  definition    )
  fluent.check  ( snippet,  definition  )
  fluent.snippets [ snippet ]         =   definition
end

function  fluent.translate  ( snippet,  language, ... )
  local entry                           =   fluent.snippets [ snippet ]
  if  entry
  then
    if      type  ( entry ) ==  "string"
    then
      return  entry
    elseif  type  ( entry ) ==  "table"
    then
      if      entry [ language  ]
      then
        return  entry [ language  ]
      elseif  entry.eng
      then
        log.error
        (
          "fluent.translate",
          "Cannot find snippet "  ..  tostring  ( snippet   )
          ..  " for language "    ..  tostring  ( language  ) ..  "!",
          "I will try english instead."
        )
        return  entry.eng
      elseif  entry [ 1 ]
      then
        log.error
        (
          "fluent.translate",
          "Cannot find snippet "  ..  tostring  ( snippet )
          ..  " neither for language " ..  tostring  ( language  )
          ..  " nor for the english language!",
          "I will try the first definition of unknown language instead."
        )
        return  entry [ 1 ]
      else
        log.fatal
        (
          "fluent.translate",
          "Cannot find a suitable translation for snippet " ..  tostring  ( snippet   ) ..  "!"
        )
        return  nil
      end
    elseif  type  ( entry ) ==  "function"
    then
      local result                      =   entry ( snippet,  language, ... )
      if  not result
      then
        log.fatal
        (
          "fluent.translate",
          "Cannot translate complex snippet " ..  tostring  ( snippet ) .. " with given arguments!"
        )
        return  nil
      else
        return  result
      end
    else
      log.fatal
      (
        "fluent.translate",
        "Something is wrong with the definition of snippet "  ..  tostring  ( snippet ) ..  "!"
      )
      return  nil
    end
  else
    log.fatal
    (
      "fluent.translate",
      "Cannot find snippet "  ..  tostring  ( snippet ) ..  "!"
    )
    return  nil
  end
end
