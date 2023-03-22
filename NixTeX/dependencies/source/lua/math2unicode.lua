--- Replace these Commands with Unicode Character.
local CommandReplace
=   {
      [ "m" ]                           =   "µ",
    }

--- States of the Parser.
local States
=   {
      Normal                            =   1,
      SubScript                         =   2,
      SubScriptGroup                    =   3,
      SuperScript                       =   4,
      SuperScriptGroup                  =   5,
      Escape                            =   6,
      Command                           =   7,
      Argument                          =   8,
    }

local StateStack
=   {
      [ States.Normal           ]       =   { push  = States.Normal,            },
      [ States.SubScript        ]       =   { push  = States.SubScriptGroup,    },
      [ States.SubScriptGroup   ]       =   { push  = States.SubScriptGroup,    },
      [ States.SuperScript      ]       =   { push  = States.SuperScriptGroup,  },
      [ States.SuperScriptGroup ]       =   { push  = States.SuperScriptGroup,  },
      --  States.Escape gets ignored anyway.
      [ States.Command          ]       =   { push  = States.Argument,          },
    }

--- Ignore Style Commands, but Use its Argument.
local StyleCommands
=   {
      "emph"                            =   true,
      "mathbf"                          =   true,
      "text"                            =   true,
      "textbf"                          =   true,
      "textit"                          =   true,
      "textrm"                          =   true,
      "textsc"                          =   true,
      "textsf"                          =   true,
      "texttt"                          =   true,
      "underline"                       =   true,
    }

--- Replace Subscript Characters with Unicode Character.
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
    }

--- Replace Superscript Characters with Unicode Character.
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
    }

stack                                   =   {}

function stack.new    ( )
  return  {
            stack                       =   { },
            pointer                     =   0,
          }
end

function table:peek   ( )
  return  self.stack  [ self.pointer  ]
end

function table:pop    ( )
  local result                          =   self.stack  [ self.pointer  ]
  self.pointer                          =   self.pointer  - 1
  return  self, result
end

function table:push   ( value )
  self.pointer                          =   self.pointer  + 1
  self.stack  [ self.pointer  ]         =   value
  return  self
end

function string:math2unicode  ( )
  local output                          =   ""
  local state                           =   States.Normal
  local restate                         =   stack.new ( )
  local depth                           =   stack.new ( )
  local command                         =   ""
  for char                              in  self:utf8split  (  )
  do
    if      char  ==  "{"
    and     state ~=  States.Escape
    then
      state                             =   StateStack  [ state ].push

    elseif  char  ==  "}"
    and     state ~=  States.Escape
    then
      --  …
    elseif  state ==  States.Normal
    then
      if      char  ==  "_"
      then
        state                           =   States.SubScript
      elseif  char  ==  "^"
      then
        state                           =   States.SuperScript
      elseif  char  ==  bs
      then
        state                           =   States.Escape
        restate                         =   restate:push  ( States.Normal )
      else
        output                          =   output  ..  char
      end
    elseif  state ==  States.SubScript
    then
      state                             =   States.Normal
      output                            =   output  ..  ( SubScripts    [ char  ] or  char  )
    elseif  state ==  States.SubScriptGroup
    then
      output                            =   output  ..  ( SubScripts    [ char  ] or  char  )
    elseif  state ==  States.SuperScript
    then
      state                             =   states.Normal
      output                            =   output  ..  ( SuperScripts  [ char  ] or  char  )
    elseif  state ==  States.SuperScriptGroup
    then
      output                            =   output  ..  ( SuperScripts  [ char  ] or  char  )
    elseif  state ==  States.Escape
    then
      if  ( ( char >= "A" ) and ( char <= "Z" ) )
      or  ( ( char >= "a" ) and ( char <= "z" ) )
      then
        command                         =   char
        state                           =   States.Command
      else
        output                          =   output  ..  char
        state                           =   restate
      end
    elseif  state ==  States.Command
    then
      if  ( ( char >= "A" ) and ( char <= "Z" ) )
      or  ( ( char >= "a" ) and ( char <= "z" ) )
      then
        command                         =   command ..  char
      else
        if      char  ==  " "
        then
          char                          =   ""
        elseif  char  ==  bs
        then
          --  \cmd0\cmd0
          --       ^
          char                          =   ""
          state                         =   States.Escape
        else
          restate, state                =   restate:pop ( )
          if  state ==  States.Normal
          then
            if      char  ==  "_"
            then
              char                      =   ""
              state                     =   States.SubScript
            elseif  char  ==  "^"
            then
              char                      =   ""
              state                     =   States.SuperScript
            end
          end
        end
        output
        =   output
        ..  ( CommandReplace  [ command ] or  ( bs  ..  command ) )
        ..  char
      end
    elseif  state ==  States.Argument
    then
      restate, state                    =   restate:pop ( )
      if  StyleCommands [ command ] ~=  nil
      then
        output                          =   output  ..  char
      else
        output
        =   output
        ..  ( CommandReplace  [ command ] or  ( bs  ..  command ) )
        ..  char
      end
    else
      log.fatal
      (
        "math2unicode",
        "Invalid State: " ..  tonumber  ( state )
      )
    end
  end
  return  output
end
