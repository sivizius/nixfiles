{ bool, debug, integer, set, string, type, ... }:
  let
    inherit(string) char;

    colours
    =   {
          background
          =   {
                black                   =   40;
                red                     =   41;
                green                   =   42;
                yellow                  =   43;
                blue                    =   44;
                magenta                 =   45;
                cyan                    =   46;
                darkGrey                =   47;
              # select                  =   48;
                default                 =   49;
                lightGrey               =   100;
                brightRed               =   101;
                brightGreen             =   102;
                brightYellow            =   103;
                brightBlue              =   104;
                brightMagenta           =   105;
                brightCyan              =   106;
                white                   =   107;
              };
          foreground
          =   {
                black                   =   30;
                red                     =   31;
                green                   =   32;
                yellow                  =   33;
                blue                    =   34;
                magenta                 =   35;
                cyan                    =   36;
                darkGrey                =   37;
              # select                  =   38;
                default                 =   39;
                lightGrey               =   90;
                brightRed               =   91;
                brightGreen             =   92;
                brightYellow            =   93;
                brightBlue              =   94;
                brightMagenta           =   95;
                brightCyan              =   96;
                white                   =   97;
              };
        };

    concatAttributes
    =   attributes:
          let
            attributes'
            =   type.matchPrimitiveOrPanic attributes
                {
                  bool                  =   bool.select attributes "1" "0";
                  int                   =   integer.toString attributes;
                  list                  =   string.concatWith ";" attributes;
                  null                  =   "";
                  path                  =   "${attributes}";
                  string                =   attributes;
                };
          in
            attributes';

    displayAttributes
    =   {
          reset                         =   0;
          bold                          =   1;
          faint                         =   2;
          italic                        =   3;
          underline                     =   4;
          slowBlink                     =   5;
          rapidBlink                    =   6;
          invert                        =   7;
          conceal                       =   8;
          crossedOut                    =   9;
          font
          =   {
                default                 =   10;
                alternative
                =   number:
                      debug.panic [ "displayAttributes" "font" "alternative" ]
                      {
                        text            =   "Alternative Font must be an integer in 1…9";
                        data            =   number;
                        when
                        =   !(integer.isInstanceOf number)
                        ||  number < 1
                        ||  number > 9;
                      }
                      number + 10;
              };
          fraktur                       =   20;
          doubleUnderline               =   21;
          normalIntensity               =   22;
          #…
          notCrossedOut                 =   29;
          # …
        }
    //  colours;

    mapToSGR
    =   set.mapValues
        (
          attributes:
            type.matchPrimitiveOrDefault attributes
            {
              lambda                    =   args: SGR (attributes args);
              set                       =   mapToSGR attributes;
            }
            (SGR attributes)
        );

    APC                                 =   "${char.escape}_";
    CSI                                 =   "${char.escape}[";
    DCS                                 =   "${char.escape}P";
    OSC                                 =   "${char.escape}]";
    PM                                  =   "${char.escape}^";
    SOS                                 =   "${char.escape}X";
    SS2                                 =   "${char.escape}N";
    SS3                                 =   "${char.escape}O";
    ST                                  =   "${char.escape}\\";

    SGR
    =   attributes:
          "${CSI}${concatAttributes attributes}m";
  in
    {
      inherit APC CSI DCS OSC PM SOS SS2 SS3 ST;
      inherit SGR;
      inherit colours concatAttributes displayAttributes;
    }
    //  mapToSGR displayAttributes
