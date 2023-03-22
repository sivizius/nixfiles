{ bool, debug, derivation, expression, integer, intrinsics, library, list, set, type, ... } @ libs:
  let
    veryDeep#: { depth: int, panic: bool }
    =   {
          depth                         =   64;
          panic                         =   false;
        };

    DoNotFollow
    =   type "DoNotFollow"
        {
          from                          =   value: DoNotFollow.instanciate { inherit value; };
        };

    combine                             =   list.combine (a: b: "${a}${b}");
    hexChars                            =   [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" ];
    hexPairs                            =   combine hexChars hexChars;

    appendContext
    =   intrinsics.appendContext;

    ascii                               =   list.generate (index: getChar index) 128;
    lowerAscii                          =   list.generate (index: getChar ( 97 + index)) 26;
    upperAscii                          =   list.generate (index: getChar ( 65 + index)) 26;
    char
    =   {
          backspace                     =   getChar'  "0008";
          carriageReturn                =   "\r";
          delete                        =   getChar'  "007f";
          escape                        =   getChar'  "001b";
          horizontalTab                 =   "\t";
          lineFeed                      =   "\n";
          null                          =   "";
        };

    concat                              =   concatWith                              "";
    concatIndexMapped                   =   convert: concatIndexMappedWith  convert "";
    concatMapped                        =   convert: concatMappedWith       convert "";
    concatMapped'                       =   convert: concatMappedWith'      convert "";

    concatComma                         =   concatWith                              ",";
    concatIndexMappedComma              =   convert: concatIndexMappedWith  convert ",";
    concatMappedComma                   =   convert: concatMappedWith       convert ",";
    concatMappedComma'                  =   convert: concatMappedWith'      convert ",";

    concatCRLF                          =   concatWith                              "\r\n";
    concatIndexMappedCRLF               =   convert: concatIndexMappedWith  convert "\r\n";
    concatMappedCRLF                    =   convert: concatMappedWith       convert "\r\n";
    concatMappedCRLF'                   =   convert: concatMappedWith'      convert "\r\n";

    concatCSV                           =   concatWith                              ", ";
    concatIndexMappedCSV                =   convert: concatIndexMappedWith  convert ", ";
    concatMappedCSV                     =   convert: concatMappedWith       convert ", ";
    concatMappedCSV'                    =   convert: concatMappedWith'      convert ", ";

    concatLines                         =   concatWith                              "\n";
    concatIndexMappedLines              =   convert: concatIndexMappedWith  convert "\n";
    concatMappedLines                   =   convert: concatMappedWith       convert "\n";
    concatMappedLines'                  =   convert: concatMappedWith'      convert "\n";

    concatWords                         =   concatWith                              " ";
    concatIndexMappedWords              =   convert: concatIndexMappedWith  convert " ";
    concatMappedWords                   =   convert: concatMappedWith       convert " ";
    concatMappedWords'                  =   convert: concatMappedWith'      convert " ";

    concatWith#: string -> [ string ] -> string
    =   intrinsics.concatStringsSep
    or  (
          seperator:
          parts:
            list.fold
            (
              result:
              entry:
                "${result}${seperator}${entry}"
            )
            (list.head parts)
            (list.tail parts)
        );

    concatIndexMappedWith#: F -> string -> [ T ] -> string
    # where
    #   F: int -> T -> string,
    #   T: Any:
    =   convert:
        seperator:
        parts:
          concatWith seperator (list.imap convert parts);

    concatMappedWith#: F -> string -> [ T ] -> string
    # where
    #   F: T -> string,
    #   T: Any
    =   convert:
        seperator:
        parts:
          concatWith seperator (list.map convert parts);

    concatMappedWith'#: F -> string -> [ T ] -> string
    # where
    #   F: string -> T -> string,
    #   T: Any
    =   convert:
        seperator:
        parts:
          concatWith seperator (set.mapToList convert parts);

    concatWithFinal#: string -> string -> [ string ] -> string
    =   seperator:
        final:
        parts:
          if list.length parts > 1
          then
            "${concatWith seperator (list.body parts)}${final}${list.foot parts}"
          else
            list.head parts;

    concatIndexMappedWithFinal#: F -> string -> string -> [ T ] -> string
    # where
    #   F: T -> string,
    #   T: Any
    =   convert:
        seperator:
        final:
        parts:
          concatWithFinal
            seperator
            final
            (list.imap convert parts);

    concatMappedWithFinal#: F -> string -> string -> [ T ] -> string
    # where
    #   F: T -> string,
    #   T: Any
    =   convert:
        seperator:
        final:
        parts:
          concatWithFinal
            seperator
            final
            (list.map convert parts);

    concatMappedWithFinal'#: F -> string -> string -> [ T ] -> string
    # where
    #   F: string -> T -> string,
    #   T: Any
    =   convert:
        seperator:
        final:
        parts:
          concatWithFinal
            seperator
            final
            (set.mapToList convert parts);

    discardContext
    =   intrinsics.unsafeDiscardStringContext;

    discardOutputDependency
    =   intrinsics.unsafeDiscardOutputDependency;

    escape
    =   replace
          [ "\""    "\\"    "\n"  "\r"  "\t"  char.escape ]
          [ "\\\""  "\\\\"  "\\n" "\\r" "\\t" "\\e"       ];

    escapeKey
    =   key:
          if (match "[A-Za-z_][-'0-9A-Za-z_]*" key) != null
          then
            key
          else
            "\"${escape key}\"";

    format#: T -> string
    # where T: Any
    =   {
          display   ? false,
          hex       ? false,
          legacy    ? false,
          maxDepth  ? null,
          nice      ? false,
          showType  ? false,
          trace     ? false,
        }:
          formatValue
          {
            inherit display hex legacy maxDepth nice showType trace;
            attrPath                    =   [];
            depth                       =   0;
            indent                      =   "";
            seen                        =   [];
          };

    formatAttrPath
    =   concatMapped
        (
          key:
            bool.select
              (integer.isInstanceOf key)
              "[${integer.toString key}]"
              ".${key}"
        );

    formatBool                          =   { legacy, ... }: (bool.select legacy bool.formatLegacy bool.format);

    formatFloat                         =   { ... }: intrinsics.toString;

    formatInteger                       =   { hex, ... }: bool.select hex integer.formatHexaDecimal integer.toString;

    formatLambda
    =   let
          mapArgument
          =   key:
              value:
                "${escapeKey key}${bool.select value "?" ""}";
          mapArguments                  =   set.mapToList mapArgument;
        in
          { depth, display, maxDepth, legacy, ... }:
          value:
            let
              args                      =   intrinsics.functionArgs value;
              value'
              =   bool.select (args != {})
                  "{ ${concatCSV (mapArguments args)} }: ..."
                  "_: ...";
            in
              if depth == maxDepth
              then
                "_: ..."
              else if display
              then
                bool.select legacy "<CODE>" value'
              else
                debug.panic [ "formatLambda" ]
                {
                  text                  =   "cannot coerse a function to a string";
                  data                  =   value';
                };

    formatList
    =   { depth, indent, legacy, maxDepth, nice, ... } @ env:
        value:
          let
            body                        =   list.imap (formatValue' env) value;
          in
            if      depth == maxDepth then  "[ ... ]"
            else if value == []       then  bool.select legacy "" "[]"
            else if legacy            then  "[ ${concatMappedWords (value: "(${value})") body} ]"
            else if nice              then  "[\n${indent}  ${concatWith ",\n${indent}  " body}\n${indent}]"
            else                            "[ ${concatCSV body} ]";

    formatNull                          =   { legacy, ... }: _: bool.select legacy "" "null";

    formatPath
    =   { depth, maxDepth, ... }:
        value:
          if depth == maxDepth  then  "<path>"
          else                        intrinsics.toString value; #"${value}";

    formatSet
    =   { depth, display, indent, legacy, maxDepth, nice, ... } @ env:
        { ... } @ value:
          let
            body
            =   set.mapToList format
                (
                  bool.select
                    (value.__public__ or null != null)
                    (set.filterByName  value value.__public__)
                    (set.remove        value [ "__public__" "__type__" "__variant__" ])
                );
            format
            =   key:
                value:
                  let
                    key'                =   escapeKey key;
                  in
                    "${key'} = ${formatValue' env key' value};";
            niceText                    =   "{\n${indent}  ${concatWith "\n${indent}  " body}\n${indent}}";
            niceText'
            =   if body != []
                then
                  bool.select
                    (type.getType value != null)
                    "<${typeName} ${niceText}>"
                    niceText
                else
                  "{}";
            typeName                  =   type.format value;
            value'
            =   if      debug.Debug.isInstanceOf  value       then  "<Debug>"
                else if derivation.isInstanceOf'  value       then  "<Derivation ${value.name}>"
                else if library.isInstanceOf      value       then  "<Library ${value.getVariant}>"
                else if value._type or null != null           then  "<${value._type}>"
                else if nice && !legacy                       then  niceText'
                else if legacy || type.getType value == null  then  "{ ${concatWith " " (set.mapToList format value)} }"
                else if body != []                            then  "<${typeName} { ${concatWith " " body} }>"
                else                                                "<${typeName}>";
          in
            if      depth == maxDepth   then  "{ ... }"
            else if value == {}         then  "{}"
            else if display             then  value'
            else if value ? outPath     then  value.outPath
            else if value ? __toString  then  value.__toString value
            else
              debug.panic "formatSet"
              {
                text                    =   "cannot coerse this set to a string";
                data                    =   value;
              };

    formatString
    =   { depth, display, indent, maxDepth, nice, ... }:
        value:
          let
            value'                      =    escape value;
          in
            if depth == maxDepth
            then
              "<string>"
            else if nice
            then
              let
                lines                   =   splitLines value;
                lines'
                =   concatMapped
                    (
                      line:
                        bool.select
                          (match "[ \n\r\t]*" line != null)
                          "\n${indent}"
                          "\n${indent}  ${replace [ "\${" "''" ] [ "''\${" "'''" ] line}"
                    )
                    lines;
              in
                if list.length lines > 1  then  "''${lines'}''"
                else                            "\"${value'}\""
            else if display || depth > 0  then  "\"${value'}\""
            else                                value;

    formatValue
    =   { attrPath, depth, display, legacy, maxDepth, seen, showType, trace, ... } @ env:
        input:
          let
            env'
            =   env
            //  {
                  seen                  =   seen ++ [ value ];
                };

            format
            =   type.matchPrimitive value
                {
                  bool                  =   formatBool;
                  float                 =   formatFloat;
                  int                   =   formatInteger;
                  lambda                =   formatLambda;
                  list                  =   formatList;
                  null                  =   formatNull;
                  path                  =   formatPath;
                  set                   =   formatSet;
                  string                =   formatString;
                };

            doNotFormat
            =   !showType
            &&  maxDepth != null
            &&  depth >= maxDepth;

            valueIfUnsuccessful
            =   debug.panic [ "formatValue" "valueIfUnsuccessful" ]
                  {
                    text                =   "Panic occured while evaluation input value.";
                    when                =   !display || legacy;
                  }
                  "<panic>";

            valueIfVeryDeep
            =   debug.panic [ "formatValue" "valueIfVeryDeep" ]
                  {
                    text                =   "Very deep o.O";
                    when                =   veryDeep.panic;
                    data                =   formatAttrPath attrPath;
                  }
                  "<very deep (over ${formatInteger env' depth})>";

            inherit(expression.tryEval input) success value;
            value'
            =   if      doNotFormat             then  "..."
                else if !success                then  valueIfUnsuccessful
                else if list.find value seen    then  "<recursion>"
                else if depth >= veryDeep.depth then  valueIfVeryDeep
                else                                  format env' value;
          in
            if trace
            then
              intrinsics.trace "<$>${formatAttrPath attrPath}" value'
            else
              value';

    formatValue'
    =   { attrPath, depth, indent, seen, ... } @ env:
        key:
          formatValue
          (
            env
            //  {
                  attrPath              =   attrPath ++ [ key ];
                  depth                 =   depth + 1;
                  indent                =   "${indent}  ";
                }
          );

    from                                =   format {};

    getByte#: string -> int
    =   text: getByte' (slice 0 1 text);

    getByte'#: string -> int
    =   let
          get#: string -> int -> string
          =   text: index: slice index 1 text;

          head#: string -> char
          =   text: get text 0;

          bytes
          =   intrinsics.listToAttrs
              (
                ( list.generate ( value: { name = getChar value; inherit value; } 127 ) )
                ++  [
                      { name = head ( getChar' "0080" ); value = 194; }
                      { name = head ( getChar' "00c0" ); value = 195; }
                    ]
                ++  (
                      list.combine
                        (
                          a: b:
                          {
                            name        =   head ( getChar' "0${list.get hexChars a}${list.get hexChars (4 * b)}0" );
                            value       =   192 + 4 * a + b;
                          }
                        )
                        ( list.range 1 7 )
                        ( list.range 0 3 )
                    )
                ++  (
                      list.map
                        (
                          a:
                          {
                            name        =   head ( getChar' "${list.get hexChars a}800" );
                            value       =   224 + a;
                          }
                        )
                        ( list.range 0 15 )
                    )
                ++  (
                      list.combine
                        (
                          a:
                          b:
                          {
                            name        =   get ( getChar' "00${list.get hexChars (8 + a)}${list.get hexChars b}" ) 1;
                            value       =   128 + 16 * a + b;
                          }
                        )
                        ( list.range 0  3 )
                        ( list.range 0 15 )
                    )
              );
        in
          bytes.${char};

    getChar'#: string -> char
    =   index: expression.fromJSON "\"\\u${index}\"";

    getChar#: int -> char
    =   index: list.get ( list.map getChar' (combine hexPairs hexPairs) ) index;

    getContext
    =   intrinsics.getContext;

    getFinalChar
    =   self:
          slice ((length self) - 1) 1 self;

    hasContext
    =   intrinsics.hasContext;

    hash#: string -> string -> string
    =   intrinsics.hashString;

    ifOrEmpty
    =   condition:
        text:
          if condition
          then
            text
          else
            "";

    isEmpty#: string -> bool
    =   text: text == "";

    isInstanceOf                        =   intrinsics.isString or (value: type.getPrimitive value == "string");

    length#: string -> int
    =   intrinsics.stringLength
    or  (
          text:
            let
              rest                      =   slice 1 9223372036854775807 text;
            in
              if text == "" then  0
              else                ( length rest ) + 1
        );

    lengthUTF8#: string -> int
    =   text: list.length ( toUTF8characters text );

    match#: string -> string -> [ T ]
    # where T: null | string | [ T ]
    =   intrinsics.match;

    orNull
    =   value:
          isInstanceOf value || value == null;

    repeat#: string -> int -> string
    =   text:
        multiplier:
          concat ( list.generate (_: text) multiplier );

    replace#: [ string ] -> [ string ] -> string -> string
    =   intrinsics.replaceStrings; /* should be possible to construct, but ahhh */

    replace'
    =   { ... } @ substitutions:
          replace
            (set.names substitutions)
            (set.values substitutions);

    slice#: int -> int -> string -> string
    =   intrinsics.substring;

    split#: string -> string -> [ T ]
    # where T: null | string | [ T ]
    =   intrinsics.split;

    splitAt#: string -> string -> [ string ]
    =   regex:
        text:
          list.filter
            ( line: isInstanceOf line )
            ( split regex text );

    splitAt'#: string -> string -> [ string ]
    =   regex:
        text:
          list.filter
            ( line: isInstanceOf line && line != "")
            ( split regex text );

    splitLines#: string -> [ string ]
    =   splitAt "\n";

    splitSpaces
    =   splitAt "([[:space:]]+)";

    splitTabs#: string -> [ string ]
    =   splitAt "\t";

    toBytes#: string -> [ u8 ]
    =   text: list.map getByte' (toCharacters text);

    toCharacters#: string -> [ asciiChar ]
    =   text:
          list.generate (index: slice index 1 text) (length text);

    toPath#: string -> path
    =   path: "./${path}";

    toLowerCase#: string -> string
    =   let
          caseMap
          =   set.pair
                ( upperAscii ++ [ "Ä" "Ö" "Ü" "ẞ" ] )
                ( lowerAscii ++ [ "ä" "ö" "ü" "ß" ] );
        in
          text:
            list.fold
            (
              text:
              char:
                "${text}${caseMap.${char} or char}"
            )
            ""
            ( toUTF8characters text );

    toString#: T -> string
    =   intrinsics.toString
    or  (
          format
          {
            display                     =   false;
            hex                         =   false;
            legacy                      =   true;
            maxDepth                    =   null;
            nice                        =   false;
            showType                    =   false;
            trace                       =   false;
          }
        );

    toTrace#: T -> string
    # where T: Any
    =   { hex, maxDepth, nice, showType, trace }:
          format
          {
            inherit hex maxDepth nice showType trace;
            display                     =   true;
            legacy                      =   false;
          };

    toTraceDeep#: T -> string
    # where T: Any
    =   { hex, nice, showType, trace }:
          format
          {
            inherit hex nice showType trace;
            display                     =   true;
            legacy                      =   false;
            maxDepth                    =   null;
          };

    toTraceShallow#: T -> string
    # where T: Any
    =   { hex, nice, showType, trace }:
          format
          {
            inherit hex nice showType trace;
            display                     =   true;
            legacy                      =   false;
            maxDepth                    =   1;
          };

    toUpperCase#: string -> string
    =   let
          # The german letter ß (sz) cannot be at the start of a word and
          #   therefore does not have a capital form.
          # However in uppercase text, the letter ẞ is allowed,
          #   but the unicode standard still defaults to SS.
          # I do not care about that, I prefer ẞ instead.
          caseMap
          =   set.pair
                ( lowerAscii ++ [ "ä" "ö" "ü" "ß" ] )
                ( upperAscii ++ [ "Ä" "Ö" "Ü" "ẞ" ] );
        in
          text:
            concatMapped
              (char: "${caseMap.${char} or char}")
              (toUTF8characters text);

    toUTF8characters#: string -> [ utf8char ]
    =   text:
          let
            this
            =   list.fold
                (
                  { result, text }:
                  character:
                    if character <= char.delete
                    then
                    {
                      text              =   "";
                      result
                      =   result
                      ++  ( if text != "" then [ text ] else [ ] )
                      ++  [ character ];
                    }
                    else
                    {
                      # Does not validate!
                      # E.g. C2 A3 A3 would be considered one char,
                      #   even though this is invalid utf8!
                      text              =   "${text}${character}";
                      inherit result;
                    }
                )
                {
                  text                  =   "";
                  result                =   [ ];
                }
                (toCharacters text);
            in
              this.result
              ++  (
                    if this.text != ""
                    then
                      [ this.text ]
                    else
                      [ ]
                  );

    trim                                =   library.import ./trim.nix libs;
  in
    type "string"
    {
      inherit DoNotFollow;
      inherit appendContext ascii
              char
              concat          concatIndexMapped           concatMapped          concatMapped'
              concatComma     concatIndexMappedComma      concatMappedComma     concatMappedComma'
              concatCRLF      concatIndexMappedCRLF       concatMappedCRLF      concatMappedCRLF'
              concatCSV       concatIndexMappedCSV        concatMappedCSV       concatMappedCSV'
              concatLines     concatIndexMappedLines      concatMappedLines     concatMappedLines'
              concatWith      concatIndexMappedWith       concatMappedWith      concatMappedWith'
              concatWithFinal concatIndexMappedWithFinal  concatMappedWithFinal concatMappedWithFinal'
              concatWords     concatIndexMappedWords      concatMappedWords     concatMappedWords'
              discardContext discardOutputDependency
              escapeKey
              from
              getByte getChar getContext getFinalChar
              hasContext hash
              ifOrEmpty isEmpty isInstanceOf
              length lengthUTF8
              match
              orNull
              replace replace' repeat
              slice split splitAt splitAt'
              splitLines splitSpaces splitTabs
              toBytes toCharacters toLowerCase toPath toString toTrace toTraceDeep toTraceShallow toUpperCase toUTF8characters trim;
      inherit(trim) ltrim ltrim' rtrim rtrim' trim';

      isPrimitive                       =   true;
    }
