buildFiles
=   {
      counter                           =   0,
    }

function buildFiles.create  ( extension,  part  )
  local name                            =   buildFiles.name ( extension,  part  )
  return  io.open ( name,  "w" ), name
end

function buildFiles.modify  ( extension,  part  )
  local name                            =   buildFiles.name ( extension,  part  )
  return  io.open ( name,  "w+" ), name
end

function buildFiles.name    ( extension,  part  )
  part                                  =   tostring  ( part  or  ""  )
  if  part  ~=  ""
  then
    part                                =   "-" ..  part
  end
  return  buildDirectory  ..  jobname ..  part  ..  "." ..  extension
end

function buildFiles.open    ( extension,  part  )
  local name                            =   buildFiles.name ( extension,  part  )
  return  io.open ( name,  "r" ), name
end

function buildFiles.register  ( )
  buildFiles.counter                    =   buildFiles.counter + 1
  return tostring ( buildFiles.counter  )
end
