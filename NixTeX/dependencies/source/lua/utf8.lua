utf8
=   {
      --  Lazy Match!
      charMatch                         =   "([%z\1-\127\194-\244][\128-\191]*)",
    }

function utf8.split ( input )
  return  input:utf8split ( )
end

function utf8.char  ( input )
  return  input:utf8char  ( )
end

--- Split String into Table of UTF8 Characters.
function string:utf8split ( ) --> table < string  >
  return  self:gmatch ( utf8.charMatch  )
end

--- get utf8-character at given `offset`.
function string:utf8char  ( offset  ) --> string
  return  self:match  ( utf8.charMatch, offset  )
end
