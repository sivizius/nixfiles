Module
  ./options
  (
    { core, self, ... }:
      let
        inherit(core) list string;

        optional
        =   option:
            value:
              if  option != null
              &&  option != ""
              &&  option != 0
              &&  option != false
              then
                [ value ]
              else
                [];

        setColour
        =   colour:
              "\"${colour.fg},${colour.bg}\"";

        configFile
        =   string.concatLines
            (
              [
                "# This File was generated and will be overridden by the nixos-rebuid."
                ""
                "# == OPTIONS =="
              ]
              ++  optional  self.afterEnds             "set afterends"
              ++  optional  self.atBlanks              "set atblanks"
              ++  optional  self.autoIndentation       "set autoindent"
              ++  optional  self.boldText              "set boldtext"
              ++  optional  self.brackets              "set brackets \"${self.brackets}\""
              ++  optional  self.breakLongLines        "set breaklonglines"
              ++  optional  self.caseSensitiveSearch   "set casesensitive"
              ++  optional  self.constantShow          "set constantshow"
              ++  optional  self.cutFromCursor         "set cutfromcursor"
              ++  optional  self.emptyLine             "set emptyline"
              ++  optional  self.fill                  "set fill ${string self.fill}"
              ++  optional  self.guideStripe           "set guidestripe ${string self.guideStripe}"
              ++  optional  self.historyLog            "set historylog"
              ++  optional  self.jumpyScrolling        "set jumpyscrolling"
              ++  optional  self.lineNumbers           "set linenumbers"
              ++  optional  self.locking               "set locking"
              ++  optional  self.matchBrackets         "set matchbrackets \"${self.matchBrackets}\""
              ++  optional  self.mouse                 "set mouse"
              ++  optional  self.multiBuffer           "set multibuffer"
              ++  optional  self.noConvert             "set noconvert"
              ++  optional  self.noHelp                "set nohelp"
              ++  optional  self.noNewLines            "set nonewlines"
              ++  optional  self.operatingDirectory    "set operatingdir \"${self.operatingDirectory}\""
              ++  optional  self.positionLog           "set positionlog"
              ++  optional  self.preserve              "set preserve"
              ++  optional  self.punctuation           "set punct \"${self.punctuation}\""
              ++  optional  self.quickBlank            "set quickblank"
              ++  optional  self.quoteString           "set quotestr \"${self.quoteString}\""
              ++  optional  self.rawSequences          "set rawsequences"
              ++  optional  self.rebindDelete          "set rebinddelete"
              ++  optional  self.regexSearch           "set regexp"
              ++  optional  self.showCursor            "set showcursor"
              ++  optional  self.smartHome             "set smarthome"
              ++  optional  self.softWrap              "set softwrap"
              ++  optional  self.spellChecker          "set speller \"${self.spellChecker}\""
              ++  optional  self.suspendable           "set suspendable"
              ++  optional  self.tabulator.size        "set tabsize ${string self.tabulator.size}"
              ++  optional  self.tabulator.toSpaces    "set tabstospaces"
              ++  optional  self.temporaryFile         "set tempfile"
              ++  optional  self.trimBlanks            "set trimblanks"
              ++  optional  self.unixFormat            "set unix"
              ++  optional  self.view                  "set view"
              ++  optional  self.whiteSpace            "set whitespace \"${self.whiteSpace}\""
              ++  optional  self.wordBounds            "set wordbounds"
              ++  optional  self.wordCharacters        "set wordchars \"${self.wordCharacters}\""
              ++  optional  self.zap                   "set zap"
              ++  [
                    ""
                    "# == COLOUR STYLE =="
                  ]
              ++  optional  self.colours.function      "set functioncolor ${setColour self.colours.function}"
              ++  optional  self.colours.error         "set errorcolor ${setColour self.colours.error}"
              ++  optional  self.colours.key           "set keycolor ${setColour self.colours.key}"
              ++  optional  self.colours.number        "set numbercolor ${setColour self.colours.number}"
              ++  optional  self.colours.selected      "set selectedcolor ${setColour self.colours.selected}"
              ++  optional  self.colours.status        "set statuscolor ${setColour self.colours.status}"
              ++  optional  self.colours.stripe        "set stripecolor ${setColour self.colours.stripe}"
              ++  optional  self.colours.title         "set titlecolor ${setColour self.colours.title}"
              ++  [
                    ""
                    "# == BACKUPS =="
                  ]
              ++  optional  self.backups.enable        "set backup"
              ++  optional  self.backups.allowInsecure "set allow_insecure_backup"
              ++  optional  self.backups.directory     "set backupdir \"${self.backup.directory}\""
              ++  [
                    ""
                    "# == SYNTAX HIGHLIGHTING =="
                  ]
              ++  optional  self.syntaxHighlight       "include \"${pkgs.nano}/share/nano/*.nanorc\""
              ++  list.map
                    (file: "include \"${file}\"")
                    self.include
              ++  list.map
                    (this: "extendsyntax ${this.name} ${this.command}")
                    self.extendSyntax
              ++  [
                    ""
                    "# == REBINDING KEYS =="
                  ]
              ++  list.map
                    (this: "unbind ${this.key} ${this.menu}")
                    self.unbindings
              ++  list.map
                    (
                      this:
                        if this.function == null
                        then "bind ${this.key} \"${this.string}\" ${this.menu}"
                        else "bind ${this.key} ${this.function} ${this.menu}"
                    )
                    self.bindings
              ++  [
                    ""
                    "# == CUSTOM SETTINGS =="
                    self.extraConfig
                  ]
            );
      in
        Option.ifEnabled self
        {
          environment.etc.nanorc.text
          =
        }
  )
