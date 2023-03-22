let
  MenuOption
  =   Option.Enum'
        [
          "main"
          "search"
          "replace"
          "replacewith"
          "yesno"
          "gotoline"
          "writeout"
          "insert"
          "extcmd"
          "help"
          "spell"
          "linter"
          "browser"
          "whereisfile"
          "gotodir"
          "all"
        ]
        "all";

  FunctionOption
  =   Option.Enum
      [
        "help"
        "cancel"
        "exit"
        "writeout"
        "savefile"
        "insert"
        "whereis"
        "wherewas"
        "findprevious"
        "findnext"
        "replace"
        "cut"
        "copy"
        "paste"
        "zap"
        "chopwordleft"
        "chopwordright"
        "cutrestoffile"
        "mark"
        "curpos"
        "wordcount"
        "speller"
        "formatter"
        "linter"
        "justify"
        "fulljustify"
        "indent"
        "unindent"
        "comment"
        "complete"
        "left"
        "right"
        "up"
        "down"
        "scrollup"
        "scrolldown"
        "prevword"
        "nextword"
        "home"
        "end"
        "beginpara"
        "endpara"
        "prevblock"
        "nextblock"
        "pageup"
        "pagedown"
        "firstline"
        "lastline"
        "gotoline"
        "findbracket"
        "prevbuf"
        "nextbuf"
        "verbatim"
        "tab"
        "enter"
        "delete"
        "backspace"
        "recordmacro"
        "runmacro"
        "undo"
        "redo"
        "refresh"
        "suspend"
        "casesens"
        "regexp"
        "backwards"
        "older"
        "newer"
        "flipreplace"
        "flipgoto"
        "flipexecute"
        "flippipe"
        "flipnewbuffer"
        "flipconvert"
        "dosformat"
        "macformat"
        "append"
        "prepend"
        "backup"
        "discardbuffer"
        "browser"
        "gotodir"
        "firstfile"
        "lastfile"
        "nohelp"
        "constantshow"
        "softwrap"
        "linenumbers"
        "whitespacedisplay"
        "nosyntax"
        "smarthome"
        "autoindent"
        "cutfromcursor"
        "nowrap"
        "tabstospaces"
        "mouse"
        "suspendable"
      ];
in
{
  # bind <key> <function> <menu>
  # bind <key> "string" <menu>
  bindings
  =   let
        options
        =   types.struct
            {
              key
              =   Option.String' ""
                  {
                    example             =   "M-X";
                    description
                    =   ''
                          The format of key should be one of:
                          <itemizedlist>
                            <listitem><para>
                              <keycap>^X</keycap>
                              where <code>X</code> is a Latin letter or one of several ASCII characters
                                (<code>@</code>, <code>]</code>, <code>\</code>, <code>^</code>, <code>_</code>)
                              or the word <quote>Space</quote>.
                              Example: <keycap>^C</keycap>.
                            </para></listitem>
                            <listitem><para>
                              <keycombo>M−X</keycombo>
                              where <code>X</code> is any ASCII character except <code>[</code>
                                or the word <quote>Space</quote>.
                              Example: <keycombo>M−8</keycombo>.
                            </para></listitem>
                            <listitem><para>
                              <keycombo>Sh−M−X</keycombo>
                              where <code>X</code> is a Latin letter.
                              Example: <keycombo>Sh−M−U</keycombo>.
                              By default, each <keycombo>Meta+letter</keycombo> keystroke does the same
                                as the corresponding <keycombo>Shift+Meta+letter</keycombo>.
                              But when any <keycombo>Shift+Meta</keycombo> bind is made,
                                that will no longer be the case, for all letters.
                            </para></listitem>
                            <listitem><para>
                              <keycap>FN</keycap>
                              where <code>N</code> is a numeric value from 1 to 24.
                              Example: <keycap>F10</keycap>.
                              (Often, <keycap>F13</keycap> to <keycap>F24</keycap> can be typed
                                as <keycap>F1</keycap> to <keycap>F12</keycap> with <keycap>Shift</keycap>.)
                            </para></listitem>
                            <listitem><para><keycap>Ins</keycap> or <keycap>Del</keycap>.</para></listitem>
                          </itemizedlist>
                        '';
                  };
              function
              =   FunctionOption
                  {
                    example             =   "help";
                    description
                    =   ''
                          Function which will be executed when <option>key</option> is pressed.
                          This option is mutually exclusive with <option>string</option>.
                        '';
                  };
              menu
              =   MenuOption
                  {
                    example             =   "main";
                    description
                    =   ''
                          Menu where this <option>key</option> binding should apply.
                        '';
                  };
              string
              =   Option.String' ""
                  {
                    example             =   "foobar";
                    description
                    =   ''
                          String which will be inserted when <option>key</option> is pressed.
                          This option is mutually exclusive with <option>function</option>.
                        '';
                  };
            };
      in
        Option.ListOf options
        ''
          List of Key-Bindings.
          Rebinds the given <option>key</option> to the given <option>function</option>
            in the given <option>menu</option>
            or in all menus where the function exists when all is used.
          See <citerefentry><refentrytitle>nanorc</refentrytitle><manvolnum>5</manvolnum><refmiscinfo>Rebind Keys</refmiscinfo></citerefentry>.
        '';

  # unbind <key> <menu>
  unbindings
  =   let
        options
        =   types.struct
            {
              key
              =   Option.String' ""
                  {
                    example             =   "^X";
                    description
                    =   ''
                          The format of key should be one of:
                          <itemizedlist>
                            <listitem><para>
                              <keycap>^X</keycap>
                              where <code>X</code> is a Latin letter or one of several ASCII characters
                                (<code>@</code>, <code>]</code>, <code>\</code>, <code>^</code>, <code>_</code>)
                              or the word <quote>Space</quote>.
                              Example: <keycap>^C</keycap>.
                            </para></listitem>
                            <listitem><para>
                              <keycombo>M−X</keycombo>
                              where <code>X</code> is any ASCII character except <code>[</code>
                                or the word <quote>Space</quote>.
                              Example: <keycombo>M−8</keycombo>.
                            </para></listitem>
                            <listitem><para>
                              <keycombo>Sh−M−X</keycombo>
                              where <code>X</code> is a Latin letter.
                              Example: <keycombo>Sh−M−U</keycombo>.
                              By default, each <keycombo>Meta+letter</keycombo> keystroke does the same
                                as the corresponding <keycombo>Shift+Meta+letter</keycombo>.
                              But when any <keycombo>Shift+Meta</keycombo> bind is made,
                                that will no longer be the case, for all letters.
                            </para></listitem>
                            <listitem><para>
                              <keycap>FN</keycap>
                              where <code>N</code> is a numeric value from 1 to 24.
                              Example: <keycap>F10</keycap>.
                              (Often, <keycap>F13</keycap> to <keycap>F24</keycap> can be typed
                                as <keycap>F1</keycap> to <keycap>F12</keycap> with <keycap>Shift</keycap>.)
                            </para></listitem>
                            <listitem><para><keycap>Ins</keycap> or <keycap>Del</keycap>.</para></listitem>
                          </itemizedlist>
                        '';
                  };
              menu
              =   MenuOption
                  {
                    example             =   "help";
                    description
                    =   ''
                          Menu where this <option>key</option> binding should apply.
                        '';
                  };
            };
      in
        Option.ListOf options
        ''
          List of Key-Unbindings.
          Unbin the given <option>key</option> in the given <option>menu</option>
            or in all menus where the function exists when all is used.
          See <citerefentry><refentrytitle>nanorc</refentrytitle><manvolnum>5</manvolnum><refmiscinfo>Rebind Keys</refmiscinfo></citerefentry>.
        '';
}
