{ core, serde, ... }:
  let
    inherit(core)   integer list path string type;
    inherit(serde)  packDWordBuffer;

    addColumns
    =   { byte0, byte1, byte2, byte3, ... } @ self:
        { byte0, byte1, byte2, byte3, ... }:
        {
          byte0                         =   integer.xor self.byte0 byte0;
          byte1                         =   integer.xor self.byte1 byte1;
          byte2                         =   integer.xor self.byte2 byte2;
          byte3                         =   integer.xor self.byte3 byte3;
        };

    addRoundKey                         =   list.zipWith addColumns;

    formatColumns
    =   list.map
        (
          { byte0, byte1, byte2, byte3, ... }:
          "${integer.formatHexByte byte0} ${integer.formatHexByte byte1} ${integer.formatHexByte byte2} ${integer.formatHexByte byte3}"
        );

    getRoundConstant                    =   list.get [1 2 4 8 16 32 64 128 27 54];

    repeat
    =   rounds:
        initial:
        convert:
          list.fold
            convert
            initial
            (list.generate (x: x) rounds);

    rotateColumn
    =   { byte0, byte1, byte2, byte3, ... }:
        {
          byte0                         =   byte1;
          byte1                         =   byte2;
          byte2                         =   byte3;
          byte3                         =   byte0;
        };

    substituteAndShiftRows4
    =   state:
          let
            column0                     =   substituteColumn (list.get state 0);
            column1                     =   substituteColumn (list.get state 1);
            column2                     =   substituteColumn (list.get state 2);
            column3                     =   substituteColumn (list.get state 3);

            column0'
            =   {
                  inherit(column0) byte0;
                  inherit(column1) byte1;
                  inherit(column2) byte2;
                  inherit(column3) byte3;
                };

            column1'
            =   {
                  inherit(column1) byte0;
                  inherit(column2) byte1;
                  inherit(column3) byte2;
                  inherit(column0) byte3;
                };

            column2'
            =   {
                  inherit(column2) byte0;
                  inherit(column3) byte1;
                  inherit(column0) byte2;
                  inherit(column1) byte3;
                };

            column3'
            =   {
                  inherit(column3) byte0;
                  inherit(column0) byte1;
                  inherit(column1) byte2;
                  inherit(column2) byte3;
                };
          in
            [ column0' column1' column2' column3' ];

    substituteByte                      =   list.get (path.import ./sbox.nix);

    substituteColumn
    =   { byte0, byte1, byte2, byte3, ... }:
        {
          byte0                         =   substituteByte byte0;
          byte1                         =   substituteByte byte1;
          byte2                         =   substituteByte byte2;
          byte3                         =   substituteByte byte3;
        };

    toBuffer
    =   length:
        buffer:
          type.matchPrimitiveOrPanic buffer
          {
            list
            =   if      list.length buffer == length
                then
                  list.map
                    (
                      { byte0, byte1, byte2, byte3, ... }:
                        { inherit byte0 byte1 byte2 byte3; }
                    )
                    buffer
                else
                  packDWordBuffer buffer;
            string
            =   packDWordBuffer (list.map string.getByte (string.toCharacters buffer));
          };

    unsubstituteByte                      =   list.get (path.import ./isbox.nix);

    unsubstituteColumn
    =   { byte0, byte1, byte2, byte3, ... }:
        {
          byte0                         =   unsubstituteByte byte0;
          byte1                         =   unsubstituteByte byte1;
          byte2                         =   unsubstituteByte byte2;
          byte3                         =   unsubstituteByte byte3;
        };

    unshiftRows4andUnsubstitute
    =   state:
          let
            column0                     =   list.get state 0;
            column1                     =   list.get state 1;
            column2                     =   list.get state 2;
            column3                     =   list.get state 3;

            column0'
            =   unsubstituteColumn
                {
                  inherit(column0) byte0;
                  inherit(column3) byte1;
                  inherit(column2) byte2;
                  inherit(column1) byte3;
                };

            column1'
            =   unsubstituteColumn
                {
                  inherit(column1) byte0;
                  inherit(column0) byte1;
                  inherit(column3) byte2;
                  inherit(column2) byte3;
                };

            column2'
            =   unsubstituteColumn
                {
                  inherit(column2) byte0;
                  inherit(column1) byte1;
                  inherit(column0) byte2;
                  inherit(column3) byte3;
                };

            column3'
            =   unsubstituteColumn
                {
                  inherit(column3) byte0;
                  inherit(column2) byte1;
                  inherit(column1) byte2;
                  inherit(column0) byte3;
                };
          in
            [ column0' column1' column2' column3' ];

  in
  {
    inherit addColumns addRoundKey
            formatColumns
            getRoundConstant
            repeat rotateColumn
            substituteAndShiftRows4 substituteByte substituteColumn
            toBuffer
            unshiftRows4andUnsubstitute unsubstituteByte unsubstituteColumn;

  }
