{ core, ... }:
  let
    inherit(core) bool integer list;

    expectU8
    =   value:
          assert  integer.isInstanceOf value
              &&  value >= 0
              &&  value <= 255;
          value;

    splitInteger
    =   value:
          let
            value0                      =   integer.abs value;
            value1                      =   value0 / 256;
            value2                      =   value1 / 256;
            value3                      =   value2 / 256;
            value4                      =   value3 / 256;
            value5                      =   value4 / 256;
            value6                      =   value5 / 256;
            value7                      =   value6 / 256;
          in
          {
            sign                        =   value < 0;

            byte0                       =   integer.and value0 255;
            byte1                       =   integer.and value1 255;
            byte2                       =   integer.and value2 255;
            byte3                       =   integer.and value3 255;
            byte4                       =   integer.and value4 255;
            byte5                       =   integer.and value5 255;
            byte6                       =   integer.and value6 255;
            byte7                       =   integer.and value7 255;

            word0                       =   integer.and value0 65535;
            word1                       =   integer.and value2 65535;
            word2                       =   integer.and value4 65535;
            word3                       =   integer.and value6 65535;

            dword0                      =   integer.and value0 4294967295;
            dword1                      =   integer.and value4 4294967295;
          };

    unpackWord
    =   word:
        {
          inherit word;
          inherit(splitInteger word)  byte0 byte1
                                      sign;
        };

    unpackDWord
    =   dword:
        {
          inherit dword;
          inherit(splitInteger dword) byte0 byte1 byte2 byte3
                                      word0 word1
                                      sign;
        };

    unpackQWord
    =   qword:
        {
          inherit qword;
          inherit(splitInteger qword) byte0 byte1 byte2 byte3 byte4 byte5 byte6 byte7
                                      word0 word1 word2 word3
                                      dword0 dword1
                                      sign;
        };

    foldBuffer
    =   { length, pack }:
          let
            length-1                    =   length - 1;
          in
            list.fold
              (
                { buffer, byte0, byte1, byte2, byte3, byte4, byte5, byte6, byte7, count }:
                value:
                  let
                    buffer'             =   buffer ++ [ (pack bytes) ];
                    bytes
                    =   {
                          byte0         =   bool.select (count == 0)  value'  byte0;
                          byte1         =   bool.select (count == 1)  value'  byte1;
                          byte2         =   bool.select (count == 2)  value'  byte2;
                          byte3         =   bool.select (count == 3)  value'  byte3;
                          byte4         =   bool.select (count == 4)  value'  byte4;
                          byte5         =   bool.select (count == 5)  value'  byte5;
                          byte6         =   bool.select (count == 6)  value'  byte6;
                          byte7         =   bool.select (count == 7)  value'  byte7;
                        };
                    value'              =   expectU8 value;
                  in
                    bytes
                    //  {
                          buffer        =   bool.select (count != length-1) buffer      buffer';
                          count         =   bool.select (count != length-1) (count + 1) 0;
                        }
              )
              {
                buffer                  =   [];
                byte0                   =   0;
                byte1                   =   0;
                byte2                   =   0;
                byte3                   =   0;
                byte4                   =   0;
                byte5                   =   0;
                byte6                   =   0;
                byte7                   =   0;
                count                   =   0;
              };

    packBuffer
    =   { length, pack } @ packer:
        buffer:
          let
            state'                      =   foldBuffer packer buffer;
          in
            assert state'.count == 0;
            state'.buffer;

    packWord
    =   {
          byte0 ? 0,
          byte1 ? 0,
        }:
          (expectU8 byte0) + (expectU8 byte1) * 256;

    packWordBuffer
    =   packBuffer
        {
          length                        =   2;
          pack
          =   { byte0, byte1, ... }:
              {
                inherit byte0 byte1;
                word                    =   packWord  { inherit byte0 byte1; };
              };
        };

    packDWord
    =   {
          byte0 ? 0,
          byte1 ? 0,
          byte2 ? 0,
          byte3 ? 0,
        }:
          list.fold
            (result: byte: result * 256 + (expectU8 byte))
            (expectU8 byte3)
            [ byte2 byte1 byte0 ];

    packDWordBuffer
    =   packBuffer
        {
          length                        =   4;
          pack
          =   { byte0, byte1, byte2, byte3, ... }:
              {
                inherit byte0 byte1 byte2 byte3;
                dword                   =   packDWord { inherit byte0 byte1 byte2 byte3; };
                word0                   =   packWord  { inherit byte0 byte1; };
                word1
                =   packWord
                    {
                      byte0             =   byte2;
                      byte1             =   byte3;
                    };
              };
        };

    packQWord
    =   {
          byte0 ? 0,
          byte1 ? 0,
          byte2 ? 0,
          byte3 ? 0,
          byte4 ? 0,
          byte5 ? 0,
          byte6 ? 0,
          byte7 ? 0,
        }:
          list.fold
            (result: byte: result * 256 + (expectU8 byte))
            (expectU8 byte7)
            [ byte6 byte5 byte4 byte3 byte2 byte1 byte0 ];

    packQWordBuffer
    =   packBuffer
        {
          length                        =   8;
          pack
          =   { byte0, byte1, byte2, byte3, byte4, byte5, byte6, byte7, ... }:
              {
                inherit byte0 byte1 byte2 byte3 byte4 byte5 byte6 byte7;
                dword0                  =   packDWord { inherit byte0 byte1 byte2 byte3; };
                dword1
                =   packDWord
                    {
                      byte0             =   byte4;
                      byte1             =   byte5;
                      byte2             =   byte6;
                      byte3             =   byte7;
                    };
                word0                   =   packWord  { inherit byte0 byte1; };
                word1
                =   packWord
                    {
                      byte0             =   byte2;
                      byte1             =   byte3;
                    };
                word2
                =   packWord
                    {
                      byte0             =   byte4;
                      byte1             =   byte5;
                    };
                word3
                =   packWord
                    {
                      byte0             =   byte6;
                      byte1             =   byte7;
                    };
              };
        };
  in
  {
    inherit packDWord packDWordBuffer
            packQWord packQWordBuffer
            packWord  packWordBuffer
            splitInteger
            unpackDWord unpackQWord unpackWord;
  }
