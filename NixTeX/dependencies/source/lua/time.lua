time
=   {
      monthNames
      =   {
            de
            =   {
                  "Januar",
                  "Februar",
                  "März",
                  "April",
                  "Mai",
                  "Juni",
                  "Juli",
                  "August",
                  "September",
                  "Oktober",
                  "November",
                  "Dezember",
                }
          }
    }

function time.printToday  ( today  )
  local date
  if today
  then
    date = os.date  ( "*t", tonumber  ( today  ) )
  else
    date = os.date  ( "*t"                      )
  end
  local today
  =   tostring  ( date.day  ) ..  ".~"
  ..  time.monthNames.de  [ date.month  ] ..  " "
  ..  tostring  ( date.year )
  log.trace
  (
    "time.printToday",
    "Today is " ..  today
  )
  tex.print ( today )
end

function time.printPDFtoday ( )
  local date
  if time ~=  ""
  then
    date = os.date  ( "*t", tonumber  ( time  ) )
  else
    date = os.date  ( "*t"                      )
  end
  local today
  =   ( "D:%04d%02d%02d133742+0100" ):format
      (
        date.year,
        date.month,
        date.day
      )
  tex.print ( today )
end

function time.printMonthAndYear  ( today )
  local date
  if today
  then
    date = os.date  ( "*t", tonumber  ( today ) )
  else
    date = os.date  ( "*t"                      )
  end
  local today
  =   time.monthNames.de  [ date.month  ] ..  "~"
  ..  tostring  ( date.year )
  log.trace
  (
    "time.printMonthAndYear",
    "Today is " ..  today
  )
  tex.print ( today )
end

function  time.parse ( date )
  if  date
  and type ( date ) == "string"
  then
    if      #date ==  10
    then
      local year, month, day            =   date:match("(%d%d%d%d)-(%d%d)-(%d%d)")
      return  {
                year                    =   tonumber  ( year  ),
                month                   =   tonumber  ( month ),
                day                     =   tonumber  ( day   ),
              }
    elseif  #date ==  7
    then
      local year, month                 =   date:match("(%d%d%d%d)-(%d%d)")
      return  {
                year                    =   tonumber  ( year  ),
                month                   =   tonumber  ( month ),
              }
    elseif  #date ==  4
    then
      return  {
                year                    =   tonumber  ( date  ),
              }
    else
      return nil
    end
  else
    return nil
  end
end

function time.printFrom  ( date )
  if  date
  then
    if      type  ( date  ) ==  "string"
    then
      if date == ""
      then
        time.printToday ( )
      else
        time.printFrom ( time.parse  ( date  ) )
      end
    elseif  type  ( date  ) ==  "number"
    then
      time.printToday (  date  )
    elseif  type  ( date  ) ==  "table"
    then
      if  date.year
      then
        local today                           =   tostring  ( date.year )
        if date.month
        then
          today                               =   time.monthNames.de  [ date.month  ] ..  " "   ..  today
          if date.day
          then
            today                             =   tostring  ( date.day    ) ..  ".~"  ..  today
          end
        end
        log.trace
        (
          " time.printFrom",
          "Today is " ..  today
        )
        tex.print ( today )
      else
        log.fatal ( "print.printTable", "Year Missing"  )
      end
    else
      log.fatal ( "print.printTable", "Invalid type of date: "  ..  type  ( date  ) )
    end
  else
    time.printToday  (  )
  end
end
