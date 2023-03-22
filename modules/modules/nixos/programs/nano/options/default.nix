{ types, ... }:
{
  enable
  =   Option.Enable
      ''
        configuration of nano by creating /etc/nanorc
      '';
  afterEnds
  =   Option.Bool' false
      ''
        Make <command>Ctrl+Right</command> stop at word ends instead of beginnings.
      '';
  atBlanks
  =   Option.Bool' false
      ''
        When soft line wrapping is enabled, make it wrap lines at blank characters (tabs and spaces)
          instead of always at the edge of the screen.
      '';
  autoIndentation
  =   Option.Bool' false
      ''
        Automatically indent a newly created line to the same number of tabs and/or spaces as the previous line
          or as the next line if the previous line is the beginning of a paragraph.
      '';
  backup                                =   ./backup.nix;
  bindings                              =   ./bindings.nix;
  boldText
  =   Option.Bool' false
      ''
        Use bold instead of reverse video
          for the title bar, status bar, key combos, function tags, line numbers and selected text.
        This can be overridden by setting the options
          <option>titleColour</option>,
          <option>statusColour</option>,
          <option>keyColour</option>,
          <option>functionColour</option>,
          <option>numberColour</option> and
          <option>selectedColour</option>.
      '';
  brackets
  =   Option.String' ""
      {
        example                         =   "\"’)>]}";
        description
        =   ''
              Set the characters treated as closing brackets when justifying paragraphs.
              This may not include blank characters.
              Only closing punctuation (see <option>punctuation</option>),
                optionally followed by the specified closing brackets,
              can end sentences.
              The default value is ""’)>]}".
            '';
      };
  breakLongLines
  =   Option.Bool' false
      ''
        Automatically hard-wrap the current line when it becomes overlong.
      '';
  caseSensitiveSearch
  =   Option.Bool' false
      ''
        Do case-sensitive searches by default.
      '';
  constantShow
  =   Option.Bool' false
      ''
        Constantly display the cursor position in the status bar.
        This overrides the option <option>quickBlank</option>.
      '';
  cutFromCursor
  =   Option.Bool' false
      ''
        Use cut-from-cursor-to-end-of-line by default, instead of cutting the whole line.
      '';
  emptyLine
  =   Option.Bool' false
      ''
        Do not use the line below the title bar, leaving it entirely blank.
      '';
  colours                               =   ./colours.nix;
  extendSyntax
  =   let
        options
        =   {
              name
              =   Option.String
                  {
                    example             =   "foobar";
                    description
                    =   ''
                          Name of syntax to extend.
                        '';
                  };
              command
              =   Option.Enum
                    [
                      "color"       # <foreground>,<background> "regex" …
                      "comment"     # "string"
                      "formatter"   # program [argument …]
                      "header"      # "regex"
                      "icolor"      # <foreground>,<background> "regex" …
                      "linter"      # program [argument …]
                      "magic"       # "regex"
                      "tabgives"    # "string"
                    ]
                    {
                      example           =   "comment";
                      description
                      =   ''
                            Extension command.
                          '';
                    };
              arguments
              =   Option.String
                  ''
                    Arguments of extension command.
                  '';
            };
      in
        Option.ListOf options
        {
          description
          =   ''
                Extend the syntax previously defined as <option>name</option> with another <option>command</option>.
                This allows adding a new color, icolor, header, magic, formatter, linter, comment or tabgives command
                  to an already defined syntax.
                Useful when you want to slightly improve a syntax defined in one of the system-installed files
                  which normally are not writable.
              '';
        };
  extraConfig
  =   Option.Lines
      {
        description
        =   ''
              The system-wide nano configuration.
              See <citerefentry><refentrytitle>nanorc</refentrytitle><manvolnum>5</manvolnum></citerefentry>.
            '';
        example
        =   ''
              set nowrap
              set tabstospaces
              set tabsize 2
            '';
      };
  fill
  =   Option.NullOr types.integer
      ''
        Set the target width for justifying and automatic hard-wrapping at this number of columns.
        If the value is 0 or less,
          wrapping will occur at the width of the screen minus number columns,
            allowing the wrap point to vary along with the width of the screen if the screen is resized.
        The default value is −8.
      '';
  guideStripe
  =   Option.NullOr types.integer
      {
        example                         =   42;
        description
        =   ''
              Draw a vertical stripe at the given column, to help judge the width of the text.
            '';
      };
  historyLog
  =   Option.Bool' false
      ''
        Save the last hundred search strings and replacement strings and executed commands,
          so they can be easily reused in later sessions.
      '';
  include
  =   Option.ListOf types.path
      {
        description
        =   ''
              Additional Files to add to /etc/nanorc.
            '';
      };
  jumpyScrolling
  =   Option.Bool' false
      ''
        Scroll the buffer contents per half-screen instead of per line.
      '';
  lineNumbers
  =   Option.Bool' false
      ''
        Display line numbers to the left of the text area.
      '';
  locking
  =   Option.Bool' false
      ''
        Enable vim-style lock-files for when editing files.
      '';
  matchBrackets
  =   Option.String' ""
      {
        example                         =   "(<[{)>]}";
        description
        =   ''
              Set the opening and closing brackets that can be found by bracket searches.
              This may not include blank characters.
              The opening set must come before the closing set and the two sets must be in the same order.
              The default value is "(<[{)>]}".
            '';
      };
  mouse
  =   Option.Bool' false
      ''
        Enable mouse support, if available for your system.
        When enabled, mouse clicks can be used to place the cursor, set the mark (with a double click)
          and execute shortcuts.
        The mouse will work in the X Window System and on the console when gpm is running.
        Text can still be selected through dragging by holding down the Shift key.
      '';
  multiBuffer
  =   Option.Bool' false
      ''
        When reading in a file with <keycap>^R</keycap>, insert it into a new buffer by default.
      '';
  noConvert
  =   Option.Bool' false
      ''
        Do not convert files from DOS/Mac format.
      '';
  noHelp
  =   Option.Bool' false
      ''
        Do not display the two help lines at the bottom of the screen.
      '';
  noNewLines
  =   Option.Bool' false
      ''
        Do not automatically add a newline when a text does not end with one.
        This can cause you to save non-POSIX text files.
      '';
  operatingDirectory
  =   Option.String' ""
      {
        example                         =   "$HOME/nano";
        description
        =   ''
              nano will only read and write files inside directory and its subdirectories.
              Also, the current directory is changed to here, so files are inserted from this directory.
              By default, the operating directory feature is turned off.
            '';
      };
  positionLog
  =   Option.Bool' false
      ''
        Save the cursor position of files between editing sessions.
        The cursor position is remembered for the 200 most-recently edited files.
      '';
  preserve
  =   Option.Bool' false
      ''
        Preserve the XON and XOFF keys (<keycap>^Q</keycap> and <keycap>^S</keycap>).
      '';
  punctuation
  =   Option.String' ""
      {
        example                         =   "!.?";
        description
        =   ''
              Set the characters treated as closing punctuation when justifying paragraphs.
              This may not include blank characters.
              Only the specfified closing punctuation,
                optionally followed by closing brackets (see <option>brackets</option>),
              can end sentences.
              The default value is "!.?".
            '';
      };
  quickBlank
  =   Option.Bool' false
      ''
        Do quick status-bar blanking: status-bar messages will disappear after 1 keystroke instead of 25.
        The option <option>constantShow</option> overrides this.
      '';
  quoteString
  =   Option.String' ""
      {
        example                         =   "^([ \\t]*([!#%:;>|}]|//))+";
        description
        =   ''
              Set the regular expression for matching the quoting part of a line.
              The default value is "^([ \t]*([!#%:;>|}]|//))+".
              Note that \t stands for an actual Tab character.
              This makes it possible to rejustify blocks of quoted text when composing email
                and to rewrap blocks of line comments when writing source code.
            '';
      };
  rawSequences
  =   Option.Bool' false
      ''
        Interpret escape sequences directly instead of asking ncurses to translate them.
        If you need this option to get your keyboard to work properly, please report a bug.
        Using this option disables nano’s mouse support.
      '';
  rebindDelete
  =   Option.Bool' false
      ''
        Interpret the Delete and Backspace keys differently so that both Backspace and Delete work properly.
        You should only use this option
          when on your system either Backspace acts like Delete or Delete acts like Backspace.
      '';
  regexSearch
  =   Option.Bool' false
      ''
        Do regular-expression searches by default.
        Regular expressions in nano are of the extended type (ERE).
      '';
  showCursor
  =   Option.Bool' false
      ''
        Put the cursor on the highlighted item in the file browser, to aid braille users.
      '';
  smartHome
  =   Option.Bool' false
      ''
        Make the Home key smarter.
        When Home is pressed anywhere but at the very beginning of non-whitespace characters on a line,
          the cursor will jump either forwards or backwards to that beginning.
        If the cursor is already at that position, it will jump to the true beginning of the line.
      '';
  softWrap
  =   Option.Bool' false
      ''
        Display lines that exceed the screen’s width over multiple screen lines.
        You can make this soft-wrapping occur at whitespace instead of rudely at the screen’s edge,
          by using also <option>atBlanks</option>.
      '';
  spellChecker
  =   Option.String' ""
      {
        example                         =   "aspell";
        description
        =   ''
              Use the given program to do spell checking and correcting,
                instead of using the built-in corrector that calls hunspell or GNU spell.
            '';
      };
  suspendable
  =   Option.Bool' false
      ''
        Allow nano to be suspended (with ^Z by default).
      '';
  syntaxHighlight
  =   Option.Bool' true
      ''
        Whether to enable syntax highlight for various languages.
      '';
  tabulator                             =   ./tabulator.nix;
  temporaryFile
  =   Option.Bool' false
      ''
        Save automatically on exit, don’t prompt.
      '';
  trimBlanks
  =   Option.Bool' false
      ''
        Remove trailing whitespace from wrapped lines when automatic hard-wrapping occurs or when text is justified.
      '';
  unixFormat
  =   Option.Bool' false
      ''
        Save a file by default in Unix format.
        This overrides nano’s default behavior of saving a file in the format that it had.
        (This option has no effect when you also use <option>noConvert</option>.)
      '';
  view
  =   Option.Bool' false
      ''
        Disallow file modification: read-only mode.
        This mode allows the user to open also other files for viewing,
          unless <command>−−restricted</command> is given on the command line.
      '';
  whiteSpace
  =   Option.String' ""
      {
        example                         =   "»⋅";
        description
        =   ''
              Set the two characters used to indicate the presence of tabs and spaces.
              They must be single-column characters.
              The default pair for a UTF-8 locale is "»⋅" and for other locales ">.".
            '';
      };
  wordBounds
  =   Option.Bool' false
      ''
        Detect word boundaries differently by treating punctuation characters as parts of words.
      '';
  wordCharacters
  =   Option.String' ""
      {
        example                         =   "ÄÖÜäöüß";
        description
        =   ''
              Specify which other characters (besides the normal alphanumeric ones)
                should be considered as parts of words.
              This overrides the option <option>wordbounds</option>.
            '';
      };
  zap
  =   Option.Bool' false
      ''
        Let an unmodified Backspace or Delete erase the marked region
          (instead of a single character and without affecting the cutbuffer).
      '';
}
