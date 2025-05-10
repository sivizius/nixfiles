{
  ansi,
  context,
  debug,
  error,
  intrinsics,
  library,
  list,
  set,
  string,
  type,
  logLevel ? debug.levels.info,
  fatalLevel ? debug.levels.error,
  ...
}:
let
  Body =
    string
    || [ string ]
    || {
      #     depth:  integer?                = null,
      #     fatal:  bool                    = false,
      #     text:   ([ string ] | string)?  = [],
      #     when:   bool                    = true,
      #     show:   bool                    = false,
      #     data:   any                     = null,
    }
    || null;

  Debug = type "Debug" {
    from # :
      # { colour: string, level: integer }
      # -> { body: [ string ]; fatal: bool; nice: bool; show: bool; showType: bool; when: bool; }
      # -> Debug
      =
        {
          active,
          colour,
          fatal,
          level,
          logger,
          source,
          ...
        }@self:
        {
          body,
          hex ? false,
          maxDepth ? null,
          nice ? false,
          show ? false,
          showType ? true,
          trace ? false,
          when ? true,
        }:
        let
          body' = list.map string.expect body;
          fail = if level == 0 then error.abort else error.panic;
          message =
            let
              format = context.formatAbsolute';
            in
            [ "[${self.getVariant}] {${format source} @ ${context.formatFileName source}}" ] ++ body';
          toDebug =
            isFatal: from:
            Debug.instantiateAs self.getVariant {
              inherit from isFatal;
              body = body';
              __functor = { ... }: from;
              __toString = { body, ... }: logger (string.concatLines body) error.abort "???";
            };
        in
        if when && (active || fatal) then
          if fatal then
            toDebug true (logger (ansiFormat colour message) (fail "See Error Message Above"))
          else if show then
            toDebug false (
              value:
              let
                additionalLines = string.splitLines (
                  string.toTrace {
                    inherit
                      hex
                      maxDepth
                      nice
                      showType
                      trace
                      ;
                  } value
                );
              in
              logger (ansiFormat colour (message ++ additionalLines)) value
            )
          else
            toDebug false (logger (ansiFormat colour message))
        else
          toDebug false (x: x);
  };

  DebugLevel =
    let
      print =
        let
          toLines = text: string.splitLines (string.trim text);
          toLines' =
            text:
            type.matchPrimitiveOrPanic text {
              null = [ ];
              list = text;
              string = toLines text;
            };
          fromList = lines: {
            body = list.map string.expect lines;
          };
          fromSet =
            {
              data ? null,
              hex ? false,
              maxDepth ? null,
              nice ? false,
              show ? false,
              showType ? true,
              text ? [ ],
              trace ? false,
              when ? true,
            }@this:
            {
              inherit
                hex
                maxDepth
                nice
                show
                showType
                trace
                when
                ;
              body =
                (toLines' text)
                ++ (
                  if this ? data then
                    string.splitLines (
                      string.toTrace {
                        inherit
                          hex
                          maxDepth
                          nice
                          showType
                          trace
                          ;
                      } data
                    )
                  else
                    [ ]
                );
            };
        in
        self: source: body:
        Debug
          (
            self
            // {
              source = self.source source;
            }
          )
          (
            type.matchPrimitiveOrPanic body {
              null = {
                body = [ ];
              };
              list = fromList body;
              set = fromSet body;
              string = {
                body = toLines body;
              };
            }
          );
    in
    type "DebugLevel" {
      from =
        variant:
        { colour, level, logger ? intrinsics.trace }:
        DebugLevel.instantiateAs variant {
          inherit colour level logger print;
          __functor = print;
          active = level <= logLevel.level;
          fatal = level <= fatalLevel.level;
          message = null;
        };
    };

  Source = string || [ string ] || null;

  ansiFormat =
    let
      backspaces = "${string.repeat string.char.backspace 7}";
    in
    color: lines:
    let
      concatLines = string.concatMapped (line: "\n${color}| ${line}");
      head = list.head lines;
      tail = concatLines (list.tail lines);
    in
    "${string.char.carriageReturn}${color}${ansi.bold}${head}${ansi.reset}${tail}${ansi.reset}";

  minimal =
    set.mapValues
      (
        logger: source: body:
        if body.when or true then
          (if body ? data then intrinsics.trace body.data else (x: x)) logger (body.text or body)
        else
          (x: x)
      )
      {
        dafuq = message: error.abort "[dafuq] ${string.toString message}";
        panic = message: error.throw "[panic] ${string.toString message}";
        error = message: intrinsics.warn "[error] ${string.toString message}";
        warn = message: intrinsics.warn "[warn]  ${string.toString message}";
        info = message: intrinsics.trace "[info]  ${string.toString message}";
        debug = message: intrinsics.trace "[debug] ${string.toString message}";
        trace = message: intrinsics.traceVerbose "[trace] ${string.toString message}";
        silent = message: x: x;
      };

  levels =
    let
      inherit (ansi) foreground;
    in
    {
      dafuq = {
        colour = foreground.brightMagenta;
        level = 0;
        logger = intrinsics.warn;
      }; # This should not even happen.
      panic = {
        colour = foreground.red;
        level = 1;
        logger = intrinsics.warn;
      }; # You will not get a result.
      error = {
        colour = foreground.brightRed;
        level = 2;
        logger = intrinsics.warn;
      }; # You will not get, what you expect.
      warn = {
        colour = foreground.brightYellow;
        level = 3;
        logger = intrinsics.warn;
      }; # You might not get, what you expect.
      info = {
        colour = foreground.brightGreen;
        level = 4;
      }; # Useful information, which are fine.
      debug = {
        colour = foreground.brightCyan;
        level = 5;
      }; # Specific Information.
      trace = {
        colour = foreground.lightGrey;
        level = 6;
      }; # Single code paths.
      silent = {
        colour = foreground.white;
        level = 7;
        logger = intrinsics.traceVerbose;
      }; # Silent.
    };

  printers = set.map DebugLevel levels;

  updatePrinters =
    self:
    {
      debug ? null,
      source,
      ...
    }:
    (set.map (
      name: method:
      if DebugLevel.isInstanceOf method then
        method
        // {
          inherit source;
        }
        // (
          if debug != null then
            {
              active = method.level <= (debug.logLevel or levels.info).level or levels.${debug.logLevel}.level;
              fatal =
                method.level <= (debug.fatalLevel or levels.error).level or levels.${debug.fatalLevel}.level;
            }
          else
            { }
        )
      else
        method
    ) self)
    // {
      inherit source;
    };

  withFunction =
    debugLevel: call:
    debugLevel
    // {
      inherit call;
      __functor =
        { call, print, ... }@self:
        source:
        call (
          self
          // {
            __functor = { ... }: print self source;
          }
        );
    };

  withMessage =
    debugLevel: message:
    debugLevel
    // {
      inherit message;
      __functor = { message, print, ... }@self: source: print self source message;
    };
in
library.NeedInitialisation updatePrinters (
  printers
  // {
    __functor = self: source: updatePrinters self { source = self.source source; };

    inherit Debug DebugLevel levels;

    deprecated = withFunction printers.warn (
      print: other:
      print (
        if other ? source then
          let
            format = context.formatAbsolute';
          in
          "Deprecated: Use ${format other.source} instead!"
        else
          "Deprecated!"
      ) other
    );
    unimplemented = withMessage printers.panic "Not implemented yet, please be patient!";
    unreachable = withMessage printers.dafuq "Unreachable…or at least should not have been o.O!";
  }
)
