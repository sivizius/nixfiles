linefeed = ""--string.char(10)
function putHyperTarget ( identifier, text, name  )
  log.info("putHyperTarget", "declare link: »" .. name  ..  ":" ..  identifier .. "«")
  return  "\\vadjust pre{\\hypertarget{"  ..  name  ..  ":"
  ..        identifier
  ..      "}{}}\\acrWithOptional{"
  ..        text
  ..      "}"
end

function glossaryStyle1 ( value,  name  )
  return
  (
    putHyperTarget  ( value.identifier, value.bookmarkAs, name  )
    ..  "& "  ..  value.title ..  "&" ..
    ( value.description.native  or  ""  )  ..  tex.newline..linefeed
  )
end

function glossaryStyle2 ( value,  name  )
  if  not value.description.native
  or  value.description.native  ==  ""
  then
    return
    (
      putHyperTarget  ( value.identifier, value.bookmarkAs, name  )
      ..  "& \\textit{"  ..  value.title  .. "}" ..  tex.newline..linefeed
    )
  else
    return
    (
      putHyperTarget  ( value.identifier, value.bookmarkAs, name  )
      ..  "& \\textit{" ..  value.title
      ..  "}: "  ..  value.description.native..tex.newline..linefeed
    )
  end
end

function glossaryStyle3 ( value,  name  )
  if  not value.description.native
  or  value.description.native  ==  ""
  then
    return
    (
      putHyperTarget  ( value.identifier, value.bookmarkAs, name  )
      ..  "& "  ..  "\\textit{" ..  value.title ..  "}: \\newline "
      ..  value.title ..  "}" ..  tex.newline..linefeed
    )
  else
    return
    (
      putHyperTarget  ( value.identifier, value.bookmarkAs, name  )
      ..  "& "  ..  "\\textit{" ..  value.title ..  "}: \\newline "
      ..  value.description.native  ..  tex.newline..linefeed
    )
  end
end

function glossaryStyle4 ( value,  name  )
  return
  (
    putHyperTarget  ( value.identifier, value.bookmarkAs, name  )
    .. " " .. value.title ..  tex.newline  ..  "*" ..linefeed
    ..  "\\multicolumn{1}{@{\\qquad}p{\\linewidth-2em}}{"
    ..    ( value.description.native  or  ""  )
    ..  "}" ..  tex.newline..linefeed
  )
end

glossaryStyles
= {
    [ "simple"  ]
    =   {
          foo = glossaryStyle1,
          bar = "l@{\\quad}p{.3\\linewidth}X",
        },
    [ "single-line" ]
    =   {
          foo = glossaryStyle2,
          bar = "l@{\\quad}X",
        },
    [ "multi-line"  ]
    =   {
          foo = glossaryStyle3,
          bar = "l@{\\quad}X",
        },
    [ "people"  ]
    =   {
          foo = glossaryStyle4,
          bar = "l",
        },
  }

function  glossaryStyles.getSection ( style,  this, name  )
  local glossaryStyle                   =   glossaryStyles  [ style ]
  local currentSection                  =   0
  local output
  =   "\\begin{longtabu}{"  ..
        glossaryStyle.bar  ..
      "}"..linefeed
  local firstLine                       =   true
  for index, entry                      in  ipairs  ( this.table  )
  do
    if  entry.section
    and entry.section ~=  currentSection
    then
      currentSection                    =   entry.section
      local title                       =   this.sections [ entry.section ].title
      if  title ~=  ""
      then
        if not firstLine
        then
          output                        =   output  ..  tex.newline ..  "*"
        end
        output
        =   output  ..  "\\multicolumn{\\numColumns}{l}{\\textbf{"
        ..  title
        ..  "}}" ..  tex.newline ..  "*"..linefeed
      end
    end
    if not firstLine
    then
      output                            =   output  ..  tex.newline ..  "*[-16pt]"..linefeed
    else
      firstLine                         =   false
    end
    output                              =   output  ..  glossaryStyle.foo ( entry,  name  )
  end
  output                                =   output  ..  "\\end{longtabu}"..linefeed
  --print(output)
  return output
end
