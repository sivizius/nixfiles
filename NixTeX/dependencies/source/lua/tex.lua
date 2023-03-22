tex.newline                             =   bs..bs

function tex.define ( name, func, arguments,  optional  )
  if    type  ( arguments ) ==  "number"
  and   arguments > 0
  then
    if  arguments < 10
    then
      local argumentString              =   "[[#1]]"
      for index = 2, arguments
      do
        argumentString                  =   argumentString  ..  ", [[#" ..  tostring  ( index ) ..  "]]"
      end
      if  optional
      then
        tex.print ( "\\newcommand{\\" ..  name  ..  "}["  ..  arguments ..  "]{\\directlua{"  ..  func  ..  "(" ..  argumentString  ..  ")}}")
      else
        tex.print ( "\\newcommand{\\" ..  name  ..  "}["  ..  arguments ..  "]["  ..  tostring  ( optional  ) ..  "]{\\directlua{"  ..  func  ..  "(" ..  argumentString  ..  ")}}")
      end
    else
      log.dafuq
      (
        "tex.define",
        "Cannot define tex-commands with more than 9 arguments."
      )
    end
  else
    tex.print ( "\\def\\" ..  name  ..  "{\\directlua{" ..  func  ..  "()}}")
  end
end
