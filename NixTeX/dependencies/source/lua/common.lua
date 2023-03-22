bs                                      =   string.char (  92 )
escape                                  =   string.char (  27 )
newline                                 =   string.char (  10 )
percent                                 =   string.char (  37 )
tilde                                   =   string.char ( 126 )

loadedFiles                             =   {}
function include(name)
  local fileName                        =   name  ..  ".lua"
  markFileAsUsed  ( fileName  )
  assert
  (
    not dofile(fileName),
    "something is wrong with " .. fileName
  )
end

function includeCode  ( name  )
  include(source.."source/lua/"..name)
end

function includeTUC  ( name  )
  include(source.."tuc/"..name)
end

function markFileAsUsed ( name  )
  table.insert  ( loadedFiles,  name  )
end

function loadTexFile    ( name  )
  markFileAsUsed  ( name  ..  ".tex"  )
end

function loadLuaFile    ( name  )
  include ( name  )
end


function commonFinal()
  spellChecker.listMacros ( )
  labels.check            ( )
  glossary.saveAll        ( )
  substances.save         ( )
  local loaded                          =   "Loaded Files:\n"
  for index, file                       in  ipairs  ( loadedFiles )
  do
    loaded                              =   loaded  ..  "→ "  ..  file  ..  "\n"
  end
  log.info
  (
    "Common Final",
    loaded
  )
  for line                              in  io.open(buildFiles.name("lgo")):lines()
  do
    if line == ""
    then
    else
      local luaotfload, message         =   line:match("luaotfload | (.*)")
      if luaotfload and message
      then
        log.info
        (
          "luaotfload",
          message
        )
      else
        log.info
        (
          "output",
          "> »"..line.."«"
        )
      end
    end
  end
  --log.putStatistics ( )
  --spellCheckerLog:close()
end

function commonAfterDependencies  ( )
  colour.texDefineAll()
end

includeCode ( "buildFiles"  )
tex.newline                             =   bs..bs

includeCode ( "logging"     )
includeCode ( "units"       )
includeCode ( "utf8"        )
includeCode ( "colour"      )
includeCode ( "roman"       )
