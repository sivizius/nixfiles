people
=   {
      extension                         =   "glsp",
      language                          =   "deu",
      list                              =   { },
      mind                              =   { },
      table                             =   { },
    }

local function  parseDate ( this )
  if  this
  and this.date
  and type ( this.date ) == "string"
  then
    local maybe                         =   false
    local date                          =   this.date
    local unknown                       =   date:match  ( "(.+)%?")
    if  unknown
    then
      maybe                             =   true
      date                              =   unknown
    end

    if      #date ==  10
    then
      local year, month, day            =   date:match("(%d%d%d%d)-(%d%d)-(%d%d)")
      return  {
                year                    =   tonumber  ( year  ),
                month                   =   tonumber  ( month ),
                day                     =   tonumber  ( day   ),
                maybe                   =   maybe,
              }
    elseif  #date ==  7
    then
      local year, month                 =   date:match("(%d%d%d%d)-(%d%d)")
      return  {
                year                    =   tonumber  ( year  ),
                month                   =   tonumber  ( month ),
                maybe                   =   maybe,
              }
    elseif  #date ==  4
    then
      return  {
                year                    =   tonumber  ( date  ),
                maybe                   =   maybe,
              }
    else
      return nil
    end
  else
    return nil
  end
end

local month
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

local function putDate ( date )
  if  date
  and date.year
  then
    local life                          =   tostring  ( date.year )
    if  date.month
    then
      life                              =   month [ date.month  ] ..  " " ..  life
      if  date.day
      then
        life                            =   tostring  ( date.day  ) ..  ".~"  ..  life
      end
    end
    if  date.maybe
    then
      life                              =   life  ..  "?"
    end
    return life
  else
    return "?"
  end
end

function  people.getEntry ( name )
  local entry                           =   people.list [ name  ]
  if  entry
  then
    if  not entry.uses
    then
      local bornAs                      =   ""
      if entry.born
      and entry.born.as
      then
        bornAs                          =   "geboren \\textsc{" ..  entry.born.as ..  "} "
      end
      local life                        =   putDate(parseDate(entry.born))
      if entry.died
      then
        life                            =   life  ..  "–" ..  putDate(parseDate(entry.died))
      end
      entry.life                        =   life
      entry.long                        =   "\\textsc{" ..  entry.full  ..  "} \\mbox{("  ..  life ..  ")}"

      entry.identifier                  =   name
      if entry.description
      then
        entry.description.native
        =   entry.description [ people.language ]
        or  entry.description.eng
        or  ""
      end
      entry.bookmarkAs                  =   "\\textsc{" ..  entry.full  ..  "}"
      entry.title                       =   bornAs  ..  "(" ..  life  ..  ")"
      entry.uses                        =   1
    else
      entry.uses                        =   entry.uses + 1
    end
  end
  return entry
end

function people.sort ( this, that )
  return this.full < that.full
end

function people.print ( name, text  )
  if  not name
  or  name  ==  ""
  then
    name                                =   text:lower()
  end
  local pdfString                       =   text
  local texString                       =   "\\textsc{" ..  text ..  "}"

  local entry                           =   people.getEntry ( name )
  if  entry
  then
    texString                           =   "\\protect\\hyperlink{person:"  ..  name  ..  "}{"  ..  texString ..  "}"
  else
    log.warn
    (
      "people.print",
      "Who is »"..text.."« (»"..name.."«)?"
    )
  end
  tex.print ( "{\\texorpdfstring{\\mbox{" ..  texString ..  "}}{" ..  pdfString ..  "}}" )
end
