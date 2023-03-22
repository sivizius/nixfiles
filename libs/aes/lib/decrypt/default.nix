{ core, helpers, key, serde, ... }:
  let
    inherit(core)     bool debug integer list path;
    inherit(helpers)  addRoundKey formatColumns unshiftRows4andUnsubstitute toBuffer;
    inherit(key)      AESkey;
    inherit(serde)    packDWordBuffer unpackDWord;

    unmixColumns
    =   list.map
        (
          { byte0, byte1, byte2, byte3, ... }:
            let
              getH                      =   x: bool.select (x > 127) 27 0;

              byte0'                    =   integer.xor (integer.and (byte0   * 2) 255) (getH byte0);
              byte1'                    =   integer.xor (integer.and (byte1   * 2) 255) (getH byte1);
              byte2'                    =   integer.xor (integer.and (byte2   * 2) 255) (getH byte2);
              byte3'                    =   integer.xor (integer.and (byte3   * 2) 255) (getH byte3);

              byte0''                   =   integer.xor (integer.and (byte0'  * 2) 255) (getH byte0');
              byte1''                   =   integer.xor (integer.and (byte1'  * 2) 255) (getH byte1');
              byte2''                   =   integer.xor (integer.and (byte2'  * 2) 255) (getH byte2');
              byte3''                   =   integer.xor (integer.and (byte3'  * 2) 255) (getH byte3');

              byte0'''                  =   integer.xor (integer.and (byte0'' * 2) 255) (getH byte0'');
              byte1'''                  =   integer.xor (integer.and (byte1'' * 2) 255) (getH byte1'');
              byte2'''                  =   integer.xor (integer.and (byte2'' * 2) 255) (getH byte2'');
              byte3'''                  =   integer.xor (integer.and (byte3'' * 2) 255) (getH byte3'');

              common                    =   integer.xor (integer.xor byte0''' byte1''') (integer.xor byte2''' byte3''');
              fold                      =   list.fold integer.xor common;
            in
            {
              byte0                     =   fold  [ byte0'' byte0'                byte1'  byte1 byte2''         byte2                 byte3 ];
              byte1                     =   fold  [                 byte0 byte1'' byte1'                byte2'  byte2 byte3''         byte3 ];
              byte2                     =   fold  [ byte0''         byte0                 byte1 byte2'' byte2'                byte3'  byte3 ];
              byte3                     =   fold  [         byte0'  byte0 byte1''         byte1                 byte2 byte3'' byte3'        ];
            }
        );

    slowRoundDecryption
    =   state:
          let
            state'                      =   unmixColumns state;
            state''                     =   unshiftRows4andUnsubstitute state';
          in
            debug.debug "slowRoundDecryption"
            {
              data
              =   {
                    state               =   formatColumns state;
                    state'              =   formatColumns state';
                    state''             =   formatColumns state'';
                  };
              nice                      =   true;
            }
            state'';

    # does not work, because it needs the key-inverse.
    fastRoundDecryption
    =   let
          td0                           =   path.import ./td0.nix;
          td1                           =   path.import ./td1.nix;
          td2                           =   path.import ./td2.nix;
          td3                           =   path.import ./td3.nix;

          subTD0                        =   list.get td0;
          subTD1                        =   list.get td1;
          subTD2                        =   list.get td2;
          subTD3                        =   list.get td3;
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
                      (integer.xor (subTD0 column0.byte0) (subTD1 column3.byte1))
                      (integer.xor (subTD2 column2.byte2) (subTD3 column1.byte3))
                  );
              column1'
              =   unpackDWord
                  (
                    integer.xor
                      (integer.xor (subTD0 column1.byte0) (subTD1 column0.byte1))
                      (integer.xor (subTD2 column3.byte2) (subTD3 column2.byte3))
                  );
              column2'
              =   unpackDWord
                  (
                    integer.xor
                      (integer.xor (subTD0 column2.byte0) (subTD1 column1.byte2))
                      (integer.xor (subTD2 column0.byte2) (subTD3 column3.byte3))
                  );
              column3'
              =   unpackDWord
                  (
                    integer.xor
                      (integer.xor (subTD0 column3.byte0) (subTD1 column2.byte1))
                      (integer.xor (subTD2 column1.byte2) (subTD3 column0.byte3))
                  );
              state'                    =   [ column0' column1' column2' column3' ];
            in
              debug.debug "fastRoundDecryption"
              {
                data
                =   {
                      state             =   formatColumns state;
                      state'            =   formatColumns state';
                    };
                hex                     =   true;
                nice                    =   true;
              }
              state';

    decrypt#: AESkey -> [ u8 ]
    =   applyRoundDecryption:
        { roundKeys, ... }:
        message:
          let
            message'                    =   toBuffer 4 message;
            applyRoundDecryption'
            =   state:
                roundKey:
                  let
                    state'              =   addRoundKey state roundKey;
                  in
                    debug.info "applyRoundDecryption'"
                    {
                      data
                      =   {
                            state       =   formatColumns state;
                            state'      =   formatColumns state';
                            roundKey    =   formatColumns roundKey;
                          };
                      nice              =   true;
                    }
                    (applyRoundDecryption state');

            firstRoundKey               =   list.head roundKeys;
            lastRoundKey                =   list.foot roundKeys;
            roundKeys'                  =   list.body (list.tail roundKeys);

            state                       =   unshiftRows4andUnsubstitute (addRoundKey message' lastRoundKey);
            state'
            =   list.foldReversed
                  applyRoundDecryption'
                  state
                  roundKeys';
          in
            debug.debug "decrypt"
            {
              data
              =   {
                    state               =   formatColumns state;
                    state'              =   formatColumns state';
                  };
              hex                       =   true;
              nice                      =   true;
            }
            addRoundKey state' firstRoundKey;
  in
  {
    __functor                           =   _: decrypt;
    #fast                                =   key: decrypt fastRoundDecryption (AESkey.expect key);
    slow                                =   key: decrypt slowRoundDecryption (AESkey.expect key);
    inherit unmixColumns;
  }
