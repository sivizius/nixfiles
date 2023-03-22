local logLevel
=   {
      Trace                             =   6,  --  here I am, if you really want to go that deep
      Debug                             =   5,  --  helpfull message for debugging, e.g. with values of variables
      Info                              =   4,  --  should not result in unexpected output, will not fail to compile
      Warn                              =   3,  --  might result in unexpected output, should not fail to compile
      Error                             =   2,  --  will result in unexpected output, might fail to compile
      Dafuq                             =   1,  --  internal errors
      Silent                            =   0,  --  be quite, be silent
    }

--  access by numeric level
logLevel.list
=   {
      [ logLevel.Silent ]
      =   {
            level                       =   logLevel.Silent,
            message                     =   "SILENT",
            colour                      =   "97", --  white
          },
      [ logLevel.Dafuq  ]
      =   {
            level                       =   logLevel.Dafuq,
            message                     =   "DAFUQ",
            colour                      =   "95", --  pink
          },
      [ logLevel.Error  ]
      =   {
            level                       =   logLevel.Error,
            message                     =   "ERROR",
            colour                      =   "91", --  red
          },
      [ logLevel.Warn   ]
      =   {
            level                       =   logLevel.Warn,
            message                     =   "WARN",
            colour                      =   "93", --  yellow
          },
      [ logLevel.Info   ]
      =   {
            level                       =   logLevel.Info,
            message                     =   "INFO",
            colour                      =   "92", --  green
          },
      [ logLevel.Debug  ]
      =   {
            level                       =   logLevel.Debug,
            message                     =   "DEBUG",
            colour                      =   "96", --  blue
          },
      [ logLevel.Trace  ]
      =   {
            level                       =   logLevel.Trace,
            message                     =   "TRACE",
            colour                      =   "37", --  grey
          },
    }

--  access by stringly level
logLevel.map
=   {
      [ "dafuq"   ]                     =   logLevel.list [ logLevel.Dafuq  ],
      [ "debug"   ]                     =   logLevel.list [ logLevel.Debug  ],
      [ "error"   ]                     =   logLevel.list [ logLevel.Error  ],
      [ "info"    ]                     =   logLevel.list [ logLevel.Info   ],
      [ "silent"  ]                     =   logLevel.list [ logLevel.Silent ],
      [ "trace"   ]                     =   logLevel.list [ logLevel.Trace  ],
      [ "warn"    ]                     =   logLevel.list [ logLevel.Warn   ],
    }

log
=   {
      helpText                          =   "",
      files
      =   {
            main                        =   buildFiles.create ( "llg"   ),
            todo                        =   buildFiles.create ( "todo"  ),
          },
      levels
      =   {
            console                     =   logLevel.Warn,
            failure                     =   logLevel.Dafuq,
            file                        =   logLevel.Trace,
            pause                       =   logLevel.Error,
          },
      stepping                          =   false,
      statistics                        =   { 0,  0,  0,  0,  0,  0 },
    }

local function logThis      ( source, lines,  level,  fatal )
  local fatal
  =   fatal
  or  (
        level.level >   logLevel.Silent
      and
        level.level <=  log.levels.failure
      )

  local pause                           =   ( level.level <=  log.levels.pause  )

  --  Always log fatal messages to console.
  local logToConsole                    =   fatal or  ( level.level <=  log.levels.console  ) or  pause
  --  Always log fatal messages to file.
  local logToFile                       =   fatal or  ( level.level <=  log.levels.file     )

  --  only if necessary
  if  logToConsole
  or  logToFile
  then
    log.statistics  [ level.level ]     =   log.statistics  [ level.level ] + 1
    if  type  ( source  ) ==  "table"
    then
      source                            =   table.concat  ( source, " → " )
    end
    --  [level] {source}
    --  | message line 0
    --  | message line 1
    local head
    =   "["   ..  level.message ..  "] "
    ..  "{"   ..  source        ..  "}\n"

    local consoleMessage                =   ""
    local fileMessage                   =   ""
    for index,  line                    in  pairs ( lines )
    do
      for line                          in  line:gmatch ( "[^\n]+"    )
      do
        line                            =   line:match  ( "(.-)[ ]*$" )
        if line ~= "."
        then
          line
          =   "| "  ..  line  ..  "\n"
          consoleMessage
          =   consoleMessage
          ..  escape  ..  "[" ..  level.colour  .. "m"  ..  line
          fileMessage
          =   fileMessage ..  line
        end
      end
    end

    if  logToFile and log.files.main ~= nil
    then
      log.files.main:write ( head ..  fileMessage ..  "\n"  )
      --log.files.main:flush ( )
    end

    if  logToConsole
    then
      texio.write_nl("")
      print
      (
        escape  ..  "[" ..  level.colour  .. "m"
        ..  head
        ..  consoleMessage
        ..  escape  ..  "[0m"
      )
      if  log.stepping
      then
        pause                           =   true
      end
    end

    if  ( fatal or  pause )
    and log.helpText  ~=  ""
    then
      print ( escape  ..  "[94m| "  ..  log.helpText  ..  escape  ..  "[0m" )
    end

    if      fatal
    then
      log.putStatistics ( )
      --  Fail Safe on fatal errors.
      error ( "<<Fatal Error>>" )
    elseif  pause
    then
      print("Press Enter/Return to continue…")
      local result                      =   io.read("*line")
      if  result:byte ( ) ==  0x1b
      then
        log.putStatistics ( )
        error ( "<<Pause>>" )
      end
      return result
    end
  end
  log.helpText                          =   ""
end

local function parseLogLevel      ( level )
  local this                            =   logLevel.map  [ level ]
  if  this  ~=  nil
  then
    return this.level
  else
    log.error
    (
      "parseLogLevel",
      "Invalid Log Level »" ..  level ..  "«, valid are: trace, debug, info, warn, fail and silent"
    )
    return nil
  end
end

function log.help           ( text  )
  log.helpText                          =   tostring  ( text  )
end

--tex.define  ( "logDafuq", "log.dafuq",  2 )
function log.dafuq          ( source, ... )
  return logThis ( source, { ...     },  logLevel.list [ logLevel.Dafuq  ],  false )
end

--tex.define  ( "logDebug", "log.debug",  2 )
function log.debug          ( source, ... )
  return logThis ( source, { ...     },  logLevel.list [ logLevel.Debug  ],  false )
end

--tex.define  ( "logError", "log.error",  2 )
function log.error          ( source, ... )
  return logThis ( source, { ...     },  logLevel.list [ logLevel.Error  ],  false )
end

--tex.define  ( "logFatal", "log.fatal",  2 )
function log.fatal          ( source, ... )
  -- try to avoid and use log.error instead.
  --  use only, if you cannot recover.
  logThis ( source, { ...     },  logLevel.list [ logLevel.Error  ],  true  )
end

--tex.define  ( "logInfo",  "log.info",   2 )
function log.info           ( source, ... )
  return logThis ( source, { ...     },  logLevel.list [ logLevel.Info   ],  false )
end

--tex.define  ( "logSilent", "log.silent",  2 )
function log.silent         ( source, ... )
  --  will not log anything, but might be somehow useful?
  return logThis ( source, { ...     },  logLevel.list [ logLevel.Silent ],  false )
end

--tex.define  ( "logTrace", "log.trace",  2 )
function log.trace          ( source, ... )
  return logThis ( source, { ...     },  logLevel.list [ logLevel.Trace  ],  false )
end

--tex.define  ( "logWarn",  "log.warn",   2 )
function log.warn           ( source, ... )
  return logThis ( source, { ...     },  logLevel.list [ logLevel.Warn   ],  false )
end

function log.todo           ( ... )
  log.files.todo:write(table.concat({...}, "\n").."\n")
  log.warn  ( "<<ToDo>>", ... )
end

function log.setConsoleLevel  ( level )
  if type ( level ) ==  "string"
  then
    level                               =   parseLogLevel ( level )
  end
  if  level >=  logLevel.Silent
  and level <=  logLevel.Trace
  then
    log.trace
    (
      "log.setConsoleLevel",
      "Set File Log Level to "  ..  tostring  ( level )
    )
    log.levels.console                  =   level
  else
    log.warn
    (
      "log.setConsoleLevel",
      "Log Level must be a Number Between 0 and 6"
    )
  end
end

function log.setFailureLevel  ( level )
  if type ( level ) ==  "string"
  then
    level                               =   parseLogLevel ( level )
  end
  if  level >=  logLevel.Silent
  and level <=  logLevel.Trace
  then
    log.trace
    (
      "log.setFailureLevel",
      "Set File Log Level to " ..  tostring  ( level  )
    )
    log.levels.failure                  =   level
  else
    log.warn
    (
      "log.setFailureLevel",
      "Log Level must be a Number Between 0 and 6"
    )
  end
end

function log.setFileLevel     ( level )
  if type ( level ) ==  "string"
  then
    level                               =   parseLogLevel ( level )
  end
  if  level >=  logLevel.Silent
  and level <=  logLevel.Trace
  then
    log.trace
    (
      "log.setFileLevel",
      "Set File Log Level to " ..  tostring  ( level  )
    )
    log.levels.file                     =   level
  else
    log.warn
    (
      "log.setFileLevel",
      "Log Level must be a Number Between 0 and 6"
    )
  end
end

function log.setPauseLevel  ( level )
  if type ( level ) ==  "string"
  then
    level                               =   parseLogLevel ( level )
  end
  if  level >=  logLevel.Silent
  and level <=  logLevel.Trace
  then
    log.trace
    (
      "log.setConsoleLevel",
      "Set File Log Level to "  ..  tostring  ( level )
    )
    log.levels.pause                    =   level
  else
    log.warn
    (
      "log.setConsoleLevel",
      "Log Level must be a Number Between 0 and 6"
    )
  end
end

function log.putStatistics  ( )
  local message
  =   "There were "
  ..  tostring  ( log.statistics  [ logLevel.Error  ] ) ..  " errors, "
  ..  tostring  ( log.statistics  [ logLevel.Warn   ] ) ..  " warnings, "
  ..  tostring  ( log.statistics  [ logLevel.Info   ] ) ..  " info-messages, "
  ..  tostring  ( log.statistics  [ logLevel.Debug  ] ) ..  " debug-messages, "
  ..  tostring  ( log.statistics  [ logLevel.Trace  ] ) ..  " traces and "
  ..  tostring  ( log.statistics  [ logLevel.Dafuq  ] ) ..  " fuck-ups."
end

log.trace
(
  jobname,
  "Start Logging"
)

io.output(buildFiles.create ( "lgo" ))
