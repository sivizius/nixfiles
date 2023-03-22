text
=   {
      annotations                       =   false,
      reviewSeen                        =   "",
      reviewSuffix                      =   "",
      reviewColours
      =   {
            [ ""          ]             =   "orange",
            [ "minor"     ]             =   "orange",
            [ "disagree"  ]             =   "yellow",
            [ "urgent"    ]             =   "red",
            [ "solved"    ]             =   "green",
          },
      details
      =   {
            threshold                   =   2,
            default                     =   1,
          },
      thinkDash
      =   {
            threshold                   =   2,
            default                     =   1,
            comma                       =   ",",
            dash                        =   "~–",
          },
    }

function  text.thd        ( input )
  local level                           =   tonumber  ( input ) or  text.thinkDash.default
  if  level < text.thinkDash.threshold
  then
    tex.print ( text.thinkDash.comma  )
  else
    tex.print ( text.thinkDash.dash   )
  end
end

function  text.thinkDash.setThreshold  ( input )
  text.thinkDash.threshold              =   tonumber  ( input ) or  text.thinkDash.default
end

function  text.detailed   ( input,  message )
  local level                           =   tonumber  ( input ) or  text.details.default
  if  level >=  text.details.threshold
  then
    tex.print ( message )
  end
end

function  text.elaborate  ( input )
  text.details.threshold                =   tonumber  ( input ) or  text.details.default
end

function  text.annotate   ( state )
  text.annotations                      =   ( state ==  "true"  or  state ==  "annotate"  )
end



function  text.reviewColour ( state, comment )
  if  text.annotations
  then
    if  text.reviewColours  [ state ]
    then
      tex.print ( text.reviewColours  [ state ] )
    else
      --  Unknown?
      log.warning
      (
        "text.reviewColour",
        "Unknown State: »"  ..  state   ..  "«",
        "Comment:       »"  ..  comment ..  "«"
      )
      tex.print ( "yellow" )
    end
  end
  if    state           ~=  "solved"
  and   text.reviewSeen ~=  comment
  then
    text.reviewSeen                     =   comment
    if  state ==  ""
    then
      log.todo
      (
        "Review:",
        comment
      )
    else
      log.todo
      (
        "Review ["  ..  state ..  "]:",
        comment
      )
    end
  end
end
