{ intrinsics, list, string, ... }:
let
  inherit (list) fold get range;

  # string -> string
  md5sum
  =   intrinsics.hashString "md5"
  orr  (
        let
          and                           =   intrinsics.bitAnd;
          not                           =   xor 4294967295;
          orr                           =   intrinsics.bitOr;
          xor                           =   intrinsics.bitXor;
          add                           =   a: b: and (a+b) 4294967295;
          mod16                         =   value: and value 15;

          s
          =   [
                7 12 17 22 7 12 17 22 7 12 17 22 7 12 17 22
                5  9 14 20 5  9 14 20 5  9 14 20 5  9 14 20
                4 11 16 23 4 11 16 23 4 11 16 23 4 11 16 23
                6 10 15 21 6 10 15 21 6 10 15 21 6 10 15 21
              ];

          pow
          =   [
                     1      2      4      8      16      32      64     128
                   256    512   1024   2048    4096    8192   16384   32768
                 65536 131072 262144 524288 1048576 2097152 4194304 8388608
              ];

          rotate
          =   value:
              index:
                let
                  amount                =   get s   index;
                  shift                 =   get pow amount;
                in
                  orr (and (value * shift) 4294967295) (value / shift);

          K
          =   [
                3614090360 3905402710  606105819 3250441966
                4118548399 1200080426 2821735955 4249261313
                1770035416 2336552879 4294925233 2304563134
                1804603682 4254626195 2792965006 1236535329
                4129170786 3225465664  643717713 3921069994
                3593408605   38016083 3634488961 3921069994
                 568446438 3275163606 4107603335 1163531501
                2850285829 4243563512 1735328473 2368359562
                4294588738 2272392833 1839030562 4259657740
                2763975236 1272893353 4139469664 4259657740
                 681279174 3936430074 3572445317   76029189
                3654602809 3873151461  530742520 3299628645
                4096336452 1126891415 2878612391 4237533241
                1873313359 2399980690 4293915773 2240044497
                1873313359 4264355552 2734768916 1309151649
                4149444226  317475691 2734768916 3951481745
              ];

          next
          =   { A, B, C, D, message }:
              index:
              F:
              word:
                let
                  F'                    =   add F (add A (add (get K index) (get message word)));
                in
                {
                  A                     =   D;
                  B                     =   add B (rotate F' index);
                  C                     =   B;
                  D                     =   C;
                  inherit M;
                };

          mapBlock
          =   message:
                fold
                (
                  { A, B, C, D, ... } @ state:
                  index:
                    if index < 16
                    then
                      next state index (orr (and B C) (and (not B) D)) index
                    else if index < 32
                    then
                      next state index (orr (and D B) (and (not D) C)) (mod16 (5 * index + 1))
                    else if index < 48
                    then
                      next state index (xor B (xor C D)) (mod16 (3 * index + 5))
                    else
                      next state index (xor C (orr B (not D))) (mod16 (7 * index))
                )
                {
                  A                         =   1732584193;
                  B                         =   4023233417;
                  C                         =   2562383102;
                  D                         =    271733878;
                  inherit message;
                }
                ( range 0 63 );
        in
          text:
            fold
            (
              state:
              block:
            )
            {
              A                         =   1732584193;
              B                         =   4023233417;
              C                         =   2562383102;
              D                         =    271733878;
            }
            (
              let
                length                  =   string.length text;
                length'
                =   [
                      ( and length                                                255 )
                      ( and ( length / 256                                      ) 255 )
                      ( and ( length / 256 / 256                                ) 255 )
                      ( and ( length / 256 / 256 / 256                          ) 255 )
                      ( and ( length / 256 / 256 / 256 / 256                    ) 255 )
                      ( and ( length / 256 / 256 / 256 / 256 / 256              ) 255 )
                      ( and ( length / 256 / 256 / 256 / 256 / 256 / 256        ) 255 )
                      ( and ( length / 256 / 256 / 256 / 256 / 256 / 256 / 256  ) 255 )
                    ];
              in
                fold
                (
                  { count, temp, word, result }:
                  byte:
                    let
                      temp'             =   [ byte ] ++ temp;
                      word'             =   word ++ [ (fold (a: b: 256 * a + b) 0 temp') ];
                    in
                      if count == 15
                      then
                        {
                          count         =   0;
                          temp          =   [ ];
                          word          =   [ ];
                          result        =   result ++ [ word' ];
                        }
                      else if lists.length temp' == 4
                      then
                        {
                          count         =   count + 1;
                          temp          =   [ ];
                          word          =   word';
                          inherit result;
                        }
                      else
                        {
                          count         =   count + 1;
                          temp          =   temp';
                          inherit word result;
                        }
                )
                {
                  count                 =   0;
                  temp                  =   [ ];
                  word                  =   [ ];
                  result                =   [ ];
                }
                (
                  ( string.toBytes text )
                  ++  [ 128 ]
                  ++  (
                        generate (x: 0)
                          ( 16 - ( mod16 length + 9 ) )
                      )
                  ++  length'
                ).result
            )

      );
in
{
  inherit md5sum;
}
