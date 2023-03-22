{ core, ... }:
{ decrypt, encrypt, helpers, key, serde, ... }:
  let
    inherit(core)     debug;
    inherit(helpers)  formatColumns;
    inherit(key)      AESkey;
    inherit(serde)    packDWordBuffer;

    key128
    =   AESkey.from128bit
        [
           43 126  21  22  40 174 210 166
          171 247  21 136   9 207  79  60
        ];
    key192
    =   AESkey.from192bit
        [
          142 115 176 247 218  14 100  82
          200  16 243  43 128 144 121 229
           98 248 234 210  82  44 107 123
        ];
    key256
    =   AESkey.from256bit
        [
           96  61 235  16  21 202 113 190
           43 115 174 240 133 125 119 129
           31  53  44   7  59  97   8 215
           45 152  16 163   9  20 223 244
        ];

    msg128
    =   [
           50  67 246 168 136  90  48 141
           49  49 152 162 224  55   7  52
        ];

    fastEncrypt                         =   encrypt.fast key128 msg128;
    slowEncrypt                         =   encrypt.slow key128 msg128;

    slowDecrypt                         =   decrypt.slow key128 slowEncrypt;
  in
  {
    inherit key128 key192 key256;
    msg128
    =   debug.warn "msg128"
        {
          data                          =   formatColumns (packDWordBuffer msg128);
          hex                           =   true;
          nice                          =   true;
        }
        msg128;
    fastEncrypt
    =   debug.warn "fastEncrypt"
        {
          data                          =   formatColumns fastEncrypt;
          hex                           =   true;
          nice                          =   true;
        }
        fastEncrypt;
    slowEncrypt
    =   debug.warn "slowEncrypt"
        {
          data                          =   formatColumns slowEncrypt;
          hex                           =   true;
          nice                          =   true;
        }
        slowEncrypt;
    slowDecrypt
    =   debug.warn "slowDecrypt"
        {
          data                          =   formatColumns slowDecrypt;
          hex                           =   true;
          nice                          =   true;
        }
        slowDecrypt;
    /*unmixColumns
    =   debug.debug "unmixColumns"
        {
          nice                          =   true;
          data
          =   {
                before
                =   formatColumns
                    (
                      packDWordBuffer
                      [
                        142 77 161 188
                        1 1 1 1
                        159 220 88 157
                        213 213 215 214
                      ]
                    );
                after
                =   formatColumns
                    (
                      decrypt.unmixColumns
                      (
                        packDWordBuffer
                        [
                          142 77 161 188
                          1 1 1 1
                          159 220 88 157
                          213 213 215 214
                        ]
                      )
                    );
              };
        }
        null;*/
  }




  /*
  key
  =   "AES Counter Mode";

  cipherText
  =   import ./.
      {
        inherit key;
        text
        =   ''
              Ooh ooh

              We're no strangers to love
              You know the rules and so do I
              A full commitment's what I'm thinking of
              You wouldn't get this from any other guy
              I just wanna tell you how I'm feeling
              Gotta make you understand

              Never gonna give you up
              Never gonna let you down
              Never gonna run around and desert you
              Never gonna make you cry
              Never gonna say goodbye
              Never gonna tell a lie and hurt you


              We've known each other for so long
              Your heart's been aching but
              You're too shy to say it
              Inside we both know what's been going on
              We know the game and we're gonna play it
              And if you ask me how I'm feeling
              Don't tell me you're too blind to see

              Never gonna give you up
              Never gonna let you down
              Never gonna run around and desert you
              Never gonna make you cry
              Never gonna say goodbye
              Never gonna tell a lie and hurt you

              Never gonna give you up
              Never gonna let you down
              Never gonna run around and desert you
              Never gonna make you cry
              Never gonna say goodbye
              Never gonna tell a lie and hurt you


              (Ooh, give you up)
              (Ooh, give you up)
              (Ooh)
              Never gonna give, never gonna give
              (Give you up)
              (Ooh)
              Never gonna give, never gonna give
              (Give you up)

              We've know each other for so long
              Your heart's been aching but
              You're too shy to say it
              Inside we both know what's been going on
              We know the game and we're gonna play it

              I just wanna tell you how I'm feeling
              Gotta make you understand

              Never gonna give you up
              Never gonna let you down
              Never gonna run around and desert you
              Never gonna make you cry
              Never gonna say goodbye
              Never gonna tell a lie and hurt you

              Never gonna give you up
              Never gonna let you down
              Never gonna run around and desert you
              Never gonna make you cry
              Never gonna say goodbye
              Never gonna tell a lie and hurt you

              Never gonna give you up
              Never gonna let you down
              Never gonna run around and desert you
              Never gonna make you cry
              Never gonna say goodbye
              Never gonna tell a lie and hurt you
            '';
      };*/