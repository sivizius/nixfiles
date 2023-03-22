{ debug, intrinsics, library, path, type, ... } @ libs:
  let
    all#: T, F: T -> bool @ F -> [ T ] -> bool
    =   intrinsics.all
    or  (
          predicate:
            fold
            (
              state:
              entry:
                state && ( predicate entry )
            )
            true
        );

    any#: T, F: T -> bool @ F -> [ T ] -> bool
    =   intrinsics.any
    or  (
          predicate:
            fold
            (
              state:
              entry:
                state || ( predicate entry )
            )
            false
        );

    body#: T @ [ T ] -> [ T ] | !
    =   self:
          generate
            ( index: get self index )
            ( ( length self ) - 1 );

    bodyOr#: T, D @ [ T ] -> D -> [ T ] | [ D ]
    =   self:
        default:
          if isEmpty self
          then
            [ default ]
          else
            body self;

    call
    =   argument:
          map (value: value argument);

    chain# T, U @ [ T ] -> [ U ] -> [ T | U ]
    =   left:
        right:
          left ++ right;

    # F -> [ T ] -> [ U ] -> [ R ]
    # where
    #   F: T -> U -> R,
    #   T, U, R: Any:
    combine
    =   operator:
        left:
        right:
          concatMap (value: map (value': operator value value') right) left;

    # F -> [ T ] -> [ T ] -> [ T ]
    # where
    #   F: T -> T -> int, /* -1: l < r, 0: l == r, 1: l > r */
    #   T: Ordable:
    compare
    =   compareElements:
        left:
        right:
          let
            compareLists
            =   compare:
                left:
                right:
                len:
                (
                  fold
                  (
                    result:
                    index:
                      if result == 0
                      then
                        compareElements
                          (get left  index)
                          (get right index)
                      else
                        result
                  )
                  0
                  ( range 0 len )
              ).result;
            lengthLeft                  =   length left;
            lengthRight                 =   length right;
          in
            if      lengthLeft  ==  lengthRight
            then
              compareLists compare left right lengthRight
            else if lengthLeft  >   lengthRight
            then
              let
                result                  =   compareLists compare left right lengthRight;
              in
                if result == 0 then 1 else result
            else
              let
                result                  =   compareLists compare left right lengthLeft;
              in
                if result == 0 then (-1) else result;

    # [ [ T ] ] -> [ T ]
    # where T: Any:
    concat
    =   intrinsics.concatLists
    or  (
          fold
          (
            result:
            entry:
              result ++ entry
          )
          [ ]
        );

    # F -> [ T ] -> [ U ]
    # where
    #   F: integer -> T -> U,
    #   T, U: Any:
    concatIMap
    =   convert:
        self:
          concat ( imap convert self );

    # F -> [ T ] -> [ U ]
    # where
    #   F: T -> U,
    #   T, U: Any:
    concatMap
    =   intrinsics.concatMap
    or  (
          convert:
          self:
            concat ( map convert self )
        );

    # int -> [ null ]:
    empty
    =   generate (_: null);

    # F -> [ T ] -> [ T ]
    # where
    #   F: T -> bool,
    #   T: Any:
    filter
    =   intrinsics.filter
    or  (
          predicate:
            fold
            (
              result:
              entry:
                if predicate entry
                then
                  result ++ [ entry ]
                else
                  result
            )
            [ ]
        );

    # [ T ] -> T -> bool
    # where T: Any:
    find
    =   intrinsics.elem
    or  (
          self:
          value:
            if      isEmpty self        then  false
            else if head self == value  then  true
            else                              find (tail self) value
        );

    flat#: T, U: ![ ... ] @ [ [ T ] | U ] -> [ T | U ]
    =   fold
        (
          result:
          entry:
            if isInstanceOf entry
            then
              result ++ entry
            else
              result ++ [ entry ]
        )
        [ ];

    flatDeep#: T, U: ![ ... ] @ [ [ T ] | U ] -> [ U ]
    =   fold
        (
          result:
          entry:
            if isInstanceOf entry
            then
              result ++ ( flatDeep entry )
            else
              result ++ [ entry ]
        )
        [ ];

    # F -> S -> [ T ] -> S
    # where
    #   F: S -> T -> S,
    #   S, T: Any:
    fold
    =   fold';

    # F -> S -> [ T ] -> S
    # where
    #   F: S -> T -> S,
    #   S, T: Any:
    fold'
    =   intrinsics.foldl'
    or  (
          next:
          init:
          self:
            if self != [ ]
            then
              fold'
                next
                ( next init ( head self ) )
                ( tail self )
            else
              init
        );

    # F -> S -> [ T ] -> S
    # where
    #   F: S -> T -> S,
    #   S, T: Any:
    foldReversed
    =   let
          fold'
          =   next:
              init:
              self:
                if self != [ ]
                then
                  fold'
                    next
                    ( next init ( foot self ) )
                    ( body self )
                else
                  init;
        in
          fold';

    # [ T ] -> T
    # where T: Any:
    foot
    =   self:
          get self (length self - 1);

    # [ T... ] | [ ] -> D -> T | D
    # where T, D: Any:
    footOr
    =   self:
        default:
          if isEmpty self
          then
            default
          else
            foot self;

    # F -> int -> [ T ]
    # where F: int -> T:
    generate
    =   intrinsics.genList
    or  (
          generator:
            let
              generate'
              =   len:
                  index:
                    if len > 0
                    then
                      [ ( generator index ) ]
                      ++ ( generate' ( len - 1 ) ( index + 1 ) )
                    else
                      [ ];
            in
              len:
                generate' len 0
        );

    genericClosure                      =   intrinsics.genericClosure;

    # [ T ] -> int -> T:
    get                                 =   intrinsics.elemAt;

    # F -> [ T ] -> { ... }
    # where
    #   F: T -> string,
    #   T: Any:
    groupBy
    =   intrinsics.groupBy
    or  (
          toName:
            fold
            (
              result:
              entry:
                let
                  name                  =   toName entry;
                in
                  result
                  //  {
                        ${name}
                        =   ( result.${name} or [ ] )
                        ++  [ entry ];
                      }
            )
            { }
        );

    # [ T ] -> T
    # where T: Any:
    head
    =   intrinsics.head
    or  (
          self:
            get self 0
        );

    # [ T ... ] | [ ] -> D -> T | D
    # where T, D: Any:
    headOr
    =   self:
        default:
          if isEmpty self
          then
            default
          else
            head self;

    ifOrEmpty
    =   condition:
        value:
          if condition
          then
            [ value ]
          else
            [ ];

    ifOrEmpty'
    =   condition:
        value:
          if condition
          then
            if isInstanceOf value
              then
                value
              else
                [ value ]
          else
            [];

    # F -> [ T ] -> [ R ]
    # where
    #   F: int -> T -> R,
    #   T, R: Any:
    imap
    =   convert:
        self:
          generate (index: convert index (get self index)) (length self);

    # F -> [ T ] -> { string -> U }
    # where
    #   F: T -> { name: string, value: U },
    #   T, U: Any:
    imapValuesToSet
    =   convert:
        self:
          toSet (generate (index: convert index (get self index)) (length self));

    isEmpty#: T @ [ T ] -> bool
    =   self: self == [ ];

    isInstanceOf                        =   intrinsics.isList;

    length#: T @ [ T ] -> int
    =   intrinsics.length;

    # F -> [ T ] -> [ U ]
    # where
    #   F: T -> U,
    #   T, U: Any:
    map
    =   intrinsics.map
    or  (
          convert:
          self:
            generate (index: convert (get self index)) (length self)
        );

    # F -> [ string ] -> { string -> T }
    # where
    #   F: string -> T,
    #   T: Any:
    mapNamesToSet
    =   convert:
        names:
          toSet (map (name: { inherit name; value = convert name; }) names);

    # F -> [ T ] -> { string -> U }
    # where
    #   F: T -> { name: string, value: U },
    #   T, U: Any:
    mapValuesToSet
    =   convert:
        self:
          toSet (map convert self);

    # [ T ] where T: Any:
    new                                 =   [];

    optional#: T | null -> [ T ]
    =   value:
          if value != null
          then
            [ value ]
          else
            [ ];

    optional'#: T | null -> [ T ]
    =   value:
          if isInstanceOf value
          then
            value
          else
            optional value;

    orNull
    =   value:
          isInstanceOf value || value == null;

    # F -> [ T ] -> { right: [ T ], wrong: [ T ] }
    # where
    #   F: T -> bool,
    #   T: Any:
    partition
    =   intrinsics.partition
    or  (
          predicate:
            groupBy
            (
              value:
                if predicate value
                then
                  "right"
                else
                  "wrong"
            )
        );

    range#: int -> int -> [ int ]
    =   from:
        till:
          generate (x: x + from) (till - from + 1);

    # [ T ] -> [ T ]
    # where T: Any:
    reverse
    =   self:
          let
            len                         =   ( length self ) - 1;
          in
            generate (x: get self ( len - x)) self;

    sort                                =   intrinsics.sort;

    sorting                             =   library.import ./sorting.nix libs;

    # [ T ] -> [ T ]
    # where T: Any:
    tail
    =   intrinsics.tail
    or  (
          self:
            generate
              ( index: get self ( index + 1 ) )
              ( ( length self ) - 1 )
        );

    # [ ... ] | [ ] -> D -> [ ... ] | D
    # where T, D: Any:
    tailOr
    =   self:
        default:
          if isEmpty self
          then
            default
          else
            tail self;

    # [ { name: string, value: T } ] -> { T... }
    # where T: Any:
    toSet
    =   intrinsics.listToAttrs
    or  (
          fold
          (
            result:
            { name, value }:
              result // { ${name} = value; }
          )
          { }
        );

    # [ T ] -> [ U ] -> [ [ T U ] ]
    # where T, U: Any:
    zip
    =   left:
        right:
          generate (x: [ (get left x) (get right x) ] ) (length left);


    zipWith#: F -> [ T ] -> [ U ] -> [ V ]
    # where
    #   F: T -> U -> V,
    #   T, U, V: Any
    =   combine:
        left:
        right:
          generate (x: combine (get left x) (get right x) ) (length left);
  in
    type "list"
    {
      isPrimitive                       =   true;
      of
      =   subtype:
            let
              __inner__                 =   type.expect subtype;
            in
              type "SetOf"
              {
                isInstanceOf            =   value: isInstanceOf value && all (_: __inner__.isInstanceOf) value;
                inherit __inner__;
              };

      inherit all any
              body bodyOr
              call chain combine compare concat concatIMap concatMap
              empty
              filter find flat flatDeep fold fold' foldReversed foot footOr
              generate genericClosure get groupBy
              head headOr
              ifOrEmpty ifOrEmpty' imapValuesToSet isEmpty imap isInstanceOf
              length
              map mapNamesToSet mapValuesToSet
              new
              optional optional' orNull
              partition
              range reverse
              sort sorting
              tail tailOr toSet
              zip zipWith;
    }
