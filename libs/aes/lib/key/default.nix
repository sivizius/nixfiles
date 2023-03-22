{ core, helpers, serde, ... }:
  let
    inherit(core)     bool debug integer list set string type;
    inherit(helpers)  formatColumns getRoundConstant repeat rotateColumn substituteColumn toBuffer;
    inherit(serde)    packDWord unpackDWord;

    expandRoundKey
    =   length:
        key:
        round:
          let
            prevKey                     =   list.foot key;
            finalLine
            =   let
                  afterRotWord          =   rotateColumn (unpackDWord prevKey.final);
                  afterSubWord          =   packDWord (substituteColumn afterRotWord);
                  afterXor              =   integer.xor roundConstant afterSubWord;
                  roundConstant         =   getRoundConstant round;
                in
                  debug.debug "expandRoundKey"
                  {
                    text                =   "Final Coulumn";
                    data
                    =   {
                          inherit afterSubWord afterXor roundConstant;
                          afterRotWord  =   packDWord afterRotWord;
                          before        =   prevKey.final;
                        };
                    hex                 =   true;
                  }
                  afterXor;

            dword0                      =   integer.xor prevKey.dword0 finalLine;
            dword1                      =   integer.xor prevKey.dword1 dword0;
            dword2                      =   integer.xor prevKey.dword2 dword1;
            dword3                      =   integer.xor prevKey.dword3 dword2;
            dword3'
            =   bool.select (length > 6)
                  (packDWord (substituteColumn (unpackDWord dword3)))
                  dword3;
            dword4                      =   integer.xor prevKey.dword4 dword3';
            dword5                      =   integer.xor prevKey.dword5 dword4;
            dword6                      =   integer.xor prevKey.dword6 dword5;
            dword7                      =   integer.xor prevKey.dword7 dword6;

            final
            =   list.get
                  [ dword0 dword1 dword2 dword3 dword4 dword5 dword6 dword7 ]
                  (length - 1);
          in
            key
            ++  (
                  debug.debug "expandRoundKey"
                  {
                    text                =   "Round ${string round}";
                    data
                    =   { inherit dword0 dword1 dword2 dword3 final; }
                    //  (set.ifOrEmpty (length > 4) { inherit dword4; })
                    //  (set.ifOrEmpty (length > 5) { inherit dword5; })
                    //  (set.ifOrEmpty (length > 6) { inherit dword6; })
                    //  (set.ifOrEmpty (length > 7) { inherit dword7; });
                    hex                 =   true;
                  }
                  [ { inherit dword0 dword1 dword2 dword3 dword4 dword5 dword6 dword7 final; } ]
                );

    from
    =   { length, rounds }:
        key:
          let
            key'                        =   toBuffer length' key;
            get                         =   index: (list.get key' index).dword;
            length'                     =   length / 32;
            roundKeys
            =   repeat ((rounds * 4 + length' - 1) / length' - 1)
                  [
                    {
                      dword0            =   get 0;
                      dword1            =   get 1;
                      dword2            =   get 2;
                      dword3            =   get 3;
                      dword4            =   get 4;
                      dword5            =   get 5;
                      dword6            =   get 6;
                      dword7            =   get 7;
                      final             =   get (length' - 1);
                    }
                  ]
                  (
                    debug.debug "expandKey"
                    {
                      text              =   "Key (${string length'})";
                      data              =   list.generate get length';
                      hex               =   true;
                    }
                    expandRoundKey length'
                );
            roundKeys'
            =   list.concatMap
                  (
                    { dword0, dword1, dword2, dword3, dword4, dword5, dword6, dword7, final }:
                      [ (unpackDWord dword0) ]
                      ++  (list.ifOrEmpty (length' > 1) (unpackDWord dword1))
                      ++  (list.ifOrEmpty (length' > 2) (unpackDWord dword2))
                      ++  (list.ifOrEmpty (length' > 3) (unpackDWord dword3))
                      ++  (list.ifOrEmpty (length' > 4) (unpackDWord dword4))
                      ++  (list.ifOrEmpty (length' > 5) (unpackDWord dword5))
                      ++  (list.ifOrEmpty (length' > 6) (unpackDWord dword6))
                      ++  (list.ifOrEmpty (length' > 7) (unpackDWord dword7))
                  )
                  roundKeys;
            columns                     =   list.generate (list.get roundKeys') (rounds*4);
          in
            AESkey.instanciate
            {
              inherit columns length rounds;
              inherit
                (
                  list.fold
                    (
                      { count, roundKeys, state }:
                      column:
                        let
                          state'        =   state ++ [ column ];
                        in
                          if count != 0
                          then
                          {
                            inherit roundKeys;
                            count       =   count - 1;
                            state       =   state';
                          }
                          else
                          {
                            count       =   3;
                            roundKeys   =   roundKeys ++ [ state' ];
                            state       =   [];
                          }
                    )
                    {
                      count             =   3;
                      roundKeys         =   [];
                      state             =   [];
                    }
                    columns
                )
                roundKeys;
            };

    AESkey
    =   type "AESkey"
        {
          inherit from;
          from128bit                    =   from { length = 128; rounds = 11; };
          from192bit                    =   from { length = 192; rounds = 13; };
          from256bit                    =   from { length = 256; rounds = 15; };
        };
  in
    AESkey // { inherit AESkey; }
