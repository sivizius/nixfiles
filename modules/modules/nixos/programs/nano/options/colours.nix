{ types, ... }:
  let
    colorOptions
    =   types.struct
        {
          bg
          =   Option.Enum
                [
                  "black"
                  "blue"
                  "cyan"
                  "green"
                  "magenta"
                  "normal"
                  "red"
                  "white"
                  "yellow"
                ]
                ''
                  Set the Background Colour.
                  Normal means the default background colour.
                '';
          fg
          =   Option.Enum
                [
                  "black"
                  "blue"
                  "brightblue"
                  "brightcyan"
                  "brightgreen"
                  "brightmagenta"
                  "brightred"
                  "brightwhite"
                  "brightyellow"
                  "cyan"
                  "green"
                  "magenta"
                  "normal"
                  "red"
                  "white"
                  "yellow"
                ]
                ''
                  Set the Foreground Colour.
                  Normal means the default foreground colour.
                '';
        };

    ColourOption                        =   Option.NullOr colorOptions;
  in
  {
    # set errorcolor <foreground>,<background>
    error
    =   ColourOption
        ''
          Use this colour combination for the status bar when an error message is displayed.
          The default value is brightwhite for foregorund and red for background.
        '';

    # set functioncolor <foreground>,<background>
    function
    =   ColourOption
        ''
          Specify the colour combination to use for the function descriptions
            in the two help lines at the bottom of the screen.
        '';

    # set keycolor <foreground>,<background>
    key
    =   ColourOption
        ''
          Specify the colour combination to use for the shortcut key combos
            in the two help lines at the bottom of the screen.
        '';

    # set numbercolor <foreground>,<background>
    number
    =   ColourOption
        ''
          Specify the colour combination to use for line numbers.
        '';

    # set selectedcolor <foreground>,<background>
    selected
    =   ColourOption
        ''
          Specify the colour combination to use for selected text.
        '';

    # set statuscolor <foreground>,<background>
    status
    =   ColourOption
        ''
          Specify the colour combination to use for the status bar.
        '';

    # set stripecolor <foreground>,<background>
    stripe
    =   ColourOption
        ''
          Specify the colour combination to use for the vertical guiding stripe.
        '';

    # set titlecolor <foreground>,<background>
    title
    =   ColourOption
        ''
          Specify the colour combination to use for the title bar.
        '';
  }
