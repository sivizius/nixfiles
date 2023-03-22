{ core, helpers, key, serde, ... }:
  let
    inherit(core)     bool integer list path;
    inherit(helpers)  addRoundKey substituteAndShiftRows4 toBuffer;
    inherit(key)      AESkey;
    inherit(serde)    unpackDWord;

    slowRoundEncryption
    =   let
          mixColumns
          =   list.map
              (
                { byte0, byte1, byte2, byte3, ... }:
                  let
                    getH                =   x: bool.select (x > 127) 27 0;
                    byte0'              =   integer.xor (integer.and (byte0 * 2) 255) (getH byte0);
                    byte1'              =   integer.xor (integer.and (byte1 * 2) 255) (getH byte1);
                    byte2'              =   integer.xor (integer.and (byte2 * 2) 255) (getH byte2);
                    byte3'              =   integer.xor (integer.and (byte3 * 2) 255) (getH byte3);
                  in
                  {
                    byte0               =   list.fold integer.xor byte0' [ byte3 byte2 byte1' byte1 ];
                    byte1               =   list.fold integer.xor byte1' [ byte0 byte3 byte2' byte2 ];
                    byte2               =   list.fold integer.xor byte2' [ byte1 byte0 byte3' byte3 ];
                    byte3               =   list.fold integer.xor byte3' [ byte2 byte1 byte0' byte0 ];
                  }
              );
        in
          state:
            mixColumns (substituteAndShiftRows4 state);

    fastRoundEncryption
    =   let
          te0                           =   path.import ./te0.nix;
          te1                           =   path.import ./te1.nix;
          te2                           =   path.import ./te2.nix;
          te3                           =   path.import ./te3.nix;

          subTE0                        =   list.get te0;
          subTE1                        =   list.get te1;
          subTE2                        =   list.get te2;
          subTE3                        =   list.get te3;
        in
          state:
            let
              column0                   =   list.get state 0;
              column1                   =   list.get state 1;
              column2                   =   list.get state 2;
              column3                   =   list.get state 3;

              column0'
              =   unpackDWord
                  (
                    integer.xor
                      (integer.xor (subTE0 column0.byte0) (subTE1 column1.byte1))
                      (integer.xor (subTE2 column2.byte2) (subTE3 column3.byte3))
                  );
              column1'
              =   unpackDWord
                  (
                    integer.xor
                      (integer.xor (subTE0 column1.byte0) (subTE1 column2.byte1))
                      (integer.xor (subTE2 column3.byte2) (subTE3 column0.byte3))
                  );
              column2'
              =   unpackDWord
                  (
                    integer.xor
                      (integer.xor (subTE0 column2.byte0) (subTE1 column3.byte1))
                      (integer.xor (subTE2 column0.byte2) (subTE3 column1.byte3))
                  );
              column3'
              =   unpackDWord
                  (
                    integer.xor
                      (integer.xor (subTE0 column3.byte0) (subTE1 column0.byte1))
                      (integer.xor (subTE2 column1.byte2) (subTE3 column2.byte3))
                  );
            in
              [ column0' column1' column2' column3' ];

    encrypt#: AESkey -> [ u8 ]
    =   applyRoundEncryption:
        { roundKeys, ... }:
        message:
          let
            message'                    =   toBuffer 4 message;
            applyRoundEncryption'       =   state: addRoundKey (applyRoundEncryption state);

            firstRoundKey               =   list.head roundKeys;
            lastRoundKey                =   list.foot roundKeys;
            roundKeys'                  =   list.body (list.tail roundKeys);

            state                       =   addRoundKey message' firstRoundKey;
            state'
            =   list.fold
                  applyRoundEncryption'
                  state
                  roundKeys';
          in
            addRoundKey
              (substituteAndShiftRows4 state')
              lastRoundKey;
  in
  {
    __functor                           =   _: encrypt;
    fast                                =   key: encrypt fastRoundEncryption (AESkey.expect key);
    slow                                =   key: encrypt slowRoundEncryption (AESkey.expect key);
  }
