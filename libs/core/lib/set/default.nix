{ debug, intrinsics, list, type, ... }:
  let
    all
    =   predicate:
        dictionary:
          (partition predicate dictionary).wrong == {};

    all'
    =   predicate:
        dictionary:
          (partition' predicate dictionary).wrong == {};

    any
    =   predicate:
        dictionary:
          (partition predicate dictionary).right != {};

    any'
    =   predicate:
        dictionary:
          (partition' predicate dictionary).right != {};

    callValues
    =   argument:
          mapValues (value: value argument);

    # string -> [ { T... } ] -> [ T ]
    # where T: Any
    collect
    =   intrinsics.catAttrs;

    filter# F -> { T } -> { T }
    # where
    #   F: string -> T -> bool,
    #   T: Any
    =   predicate:
        { ... } @ self:
          (partition predicate self).right;

    # { T } -> [ string ] -> { T... }
    # where T: Any:
    filterByName
    =   { ... } @ self:
        keys:
          fromList
          (
            list.map
              (
                name:
                {
                  inherit name;
                  value                 =   self.${name};
                }
              )
              keys
          );

    filterKeys# F -> { T } -> { T }
    # where
    #   F: string -> bool,
    #   T: Any
    =   predicate:
        { ... } @ self:
          (partitionByName predicate self).right;

    filterValue# F -> { T } -> { T }
    # where
    #   F: T -> bool,
    #   T: Any
    =   predicate:
        { ... } @ self:
          (partitionByValue predicate self).right;

    # F -> S -> { T... } -> S
    # where
    #   F: S -> string -> T -> S,
    #   T, S: Any:
    fold
    =   next:
        state:
        { ... } @ self:
          list.fold
          (
            state:
            name:
              next state name self.${name}
          )
          state
          ( names self );

    # F -> S -> { T... } -> S
    # where
    #   F: S -> { name: string; value: T; } -> S,
    #   T, S: Any:
    fold'
    =   next:
          fold
          (
            state:
            name:
            value:
              next
                state
                { inherit name value; }
          );

    # F -> S -> { T... } -> S
    # where
    #   F: S -> string -> T -> S,
    #   T, S: Any:
    foldValues
    =   next:
        state:
        { ... } @ self:
          list.fold
          (
            state:
            name:
              next state self.${name}
          )
          state
          ( names self );

    # [ { name: string, value: T } ] -> { string -> T }
    # where T: Any:
    fromList
    =   intrinsics.listToAttrs;

    # D -> [ string ] -> { string -> D }
    fromListDefault
    =   value:
        listOfKeys:
          fromList
          (
            list.map
              (name: { inherit name value; })
              listOfKeys
          );

    # F -> [ T ] -> { R... }
    # where
    #   F: int -> T -> { name: string, value: R },
    #   T, R: Any:
    fromListIMapped
    =   convert:
        input:
          fromList  (list.imap convert input);

    # F -> [ T ] -> { R... }
    # where
    #   F: int -> T -> R,
    #   T, R: Any:
    fromListIMappedValue
    =   convert:
        input:
          fromList
          (
            list.imap
              (
                index:
                name:
                {
                  inherit name;
                  value                 =   convert index name;
                }
              )
              input
          );

    # F -> [ T ] -> { R... }
    # where
    #   F: T -> { name: string, value: R },
    #   T, R: Any:
    fromListMapped
    =   convert:
        keyValuePairs:
          fromList  (list.map convert keyValuePairs);

    # F -> [ T ] -> { R... }
    # where
    #   F: T -> R,
    #   T, R: Any:
    fromListMappedValue
    =   convert:
        input:
          fromList
          (
            list.map
              (
                name:
                {
                  inherit name;
                  value                 =   convert name;
                }
              )
              input
          );

    generate
    =   generator:
        count:
          fromList (list.generate generator count);

    # string -> { T... } -> T
    # where T: Any:
    get
    =   intrinsics.getAttr
    or  (
          name:
          self:
            self.${name}
        );

    getKeySource#: string -> { string -> T } -> { column: int; file: string; line: int; }
    =   intrinsics.unsafeGetAttrPos;

    # string -> { T... } -> D -> T | D
    # where T, D: Any:
    getOr
    =   name:
        self:
        default:
          self.${name} or default;

    getSource
    =   { ... } @ self:
          if self != {}
          then
            getKeySource (list.head (names self)) self
          else
            null;

    # string -> { ... } -> bool
    hasAttribute
    =   intrinsics.hasAttr
    or  (
          name:
          self:
            self.${name} or true == self.${name} or false
        );

    ifOrEmpty
    =   condition:
        value:
          if condition
          then
            value
          else
            {};

    # { string -> T } -> { string -> U } -> { string -> U }
    intersect
    =   intrinsics.intersectAttrs;

    isInstanceOf                        =   intrinsics.isAttrs;

    map                                 =   intrinsics.mapAttrs;

    mapFold
    =   convert:
        operator:
          fold
          (
            state:
            name:
            value:
              operator state (convert name value)
          );

    mapFold'
    =   convert:
        operator:
          fold'
          (
            state:
            entry:
              operator state (convert entry)
          );

    mapNamesAndValues#: F -> { T... } -> { R... }
    # where
    #   F: string -> T -> { name: string, value: R }
    #   T, R: Any,
    =   convert:
        self:
          fromList (mapToList convert self);

    # F -> { T... } -> [ R ]
    # where
    #   F: string -> T -> R,
    #   T, R: Any:
    mapToList
    =   convert:
        { ... } @ self:
          values (map convert self);

    # F -> { T... } -> [ R ]
    # where
    #   F: string -> T -> R,
    #   T, R: Any:
    mapToListConcatted
    =   convert:
        { ... } @ self:
          list.concat (values (map convert self));

    # F -> { T... } -> { R... }
    # where
    #   F: T -> R,
    #   T, R: Any:
    mapValues
    =   convert:
          map (_: convert);

    name
    =   map
        (
          name:
          value:
            value // { inherit name; }
        );

    names                               =   intrinsics.attrNames;

    orNull
    =   value:
          isInstanceOf value || value == null;

    pair#: n, T @ n:[ string ] -> n:[ T ] -> { T }
    =   listOfNames:
        listOfValues:
          if  list.isInstanceOf listOfNames
          &&  list.isInstanceOf listOfValues
          &&  list.length listOfNames == list.length listOfValues
          then
            fromListIMappedValue (index: name: list.get listOfValues index) listOfNames
          else
            debug.panic "pair" "Names and Values must be two lists of same length!";

    pairNameWithValue
    =   name: value: { inherit name value; };

    partition
    =   predicate:
        dictionary:
          list.fold
            (
              { right, wrong }:
              name:
                let
                  value                 =   dictionary.${name};
                in
                  if predicate name dictionary.${name}
                  then
                  {
                    inherit wrong;
                    right               =   right // { ${name} = value; };
                  }
                  else
                  {
                    inherit right;
                    wrong               =   wrong // { ${name} = value; };
                  }
            )
            {
              right                     =   {};
              wrong                     =   {};
            }
            (names dictionary);

    partition'
    =   predicate:
          partition (name: value: predicate { inherit name value; });

    partitionByName
    =   predicate:
          partition (name: _: predicate name);

    partitionByValue
    =   predicate:
          partition (_: predicate);

    # { ... } -> [ string ] -> { ... }:
    remove                              =   intrinsics.removeAttrs;

    # { T... } -> string -> T
    # where T: Any:
    select                              =   { ... } @ self: field: self.${field};
    select'                             =   { ... } @ self: field: self.${field} or null;

    selectOr                            =   { ... } @ self: field: default: self.${field} or default;

    values                              =   intrinsics.attrValues;

    zip                                 =   intrinsics.zipAttrsWith;
  in
    type "set"
    {
      isPrimitive                       =   true;
      of
      =   subtype:
            let
              inner                     =   type.expect subtype;
            in
              type "SetOf"
              {
                isInstanceOf            =   value: isInstanceOf value && all (_: inner.isInstanceOf) value;
                inherit inner;
              };

      inherit all all' any any'
              callValues collect
              filter filterByName filterKeys filterValue fold fold' foldValues
              fromList fromListDefault fromListIMapped fromListIMappedValue fromListMapped fromListMappedValue
              generate get getOr getKeySource getSource
              hasAttribute
              ifOrEmpty intersect isInstanceOf
              map mapFold mapFold' mapNamesAndValues mapToList mapToListConcatted mapValues
              name names
              orNull
              pair pairNameWithValue partition partitionByName partitionByValue
              remove
              select select' selectOr
              values
              zip;
    }
