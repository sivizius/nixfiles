{ intrinsics, list, type, ... }:
  let
    Dictionary
    =   type "Dictionary"
        {
          from#: { T... } -> { string -> T }
          =   dictionary:
                Dictionary.instanciate
                {
                  inherit dictionary;
                  __functor
                  =   { dictionary, ... }:
                      key:
                        dictionary.${key} or null;
                };
        };

    filter# (string -> T -> bool) -> { string -> T } -> { string -> T }
    =   predicate:
          filterMap predicate (x: x);

    filterKeys# (string -> bool) -> { string -> T } -> { string -> T }
    =   predicate:
          filter (key: value: predicate key);

    filterMap# (string -> T -> bool) -> (string -> T -> U) -> { string -> T } -> { string -> U }
    =   predicate:
        mapping:
        { ... } @ dictionary:
          list.fold
          (
            { ... } @ dictionary':
            { key, value }:
              if (predicate key value)
              then
                dictionary'
                //  {
                      ${key}            =   mapping value;
                    }
              else
                dictionary'
          )
          {}
          (getKeys dictionary);

    filterValues# (T -> bool) -> { string -> T } -> { string -> T }
    =   predicate:
          filter (key: predicate);

    fold#: (S -> { key: string, value: T } -> S) -> S -> { string -> T } -> S
    =   function:
        state:
        dictionary:
          list.fold function state (toList dictionary);

    fromList#: [ { key: string, value: T } ] -> { string -> T }
    =   list.fold
        (
          { ... } @ dictionary:
          { key, value }:
            if dictionary.${key} or false != dictionary.${key} or true
            then
              dictionary
              //  {
                    ${key}              =   value;
                  }
            else
              throw "Key »${key}« already in dictionary!"
        )
        { };

    get#:
    =   intrinsics.getAttr
    or  (
          key:
          dictionary:
            dictionary.${key}
        );

    getOr#: string -> { string -> T } -> T -> T
    =   key:
        dictionary:
        default:
            dictionary.${key} or default;

    getKeys#: { string -> T } -> [ string ]
    =   intrinsics.attrNames;

    # string -> { ... } -> bool
    hasKey#:
    =   intrinsics.hasAttr
    or  (
          name:
          dictionary:
            dictionary.${name} or true == dictionary.${name} or false
        );

    map#: (string -> T -> U) -> { string -> T } -> { string -> U }
    =   intrinsics.mapAttrs
    or  (
          mapping:
          { ... } @ dictionary:
            list.fold
            (
              { ... } @ dictionary':
              key:
                dictionary'
                //  {
                      ${key}            =   mapping key dictionary.${key};
                    }
            )
            { }
            ( getKeys dictionary )
        );

    new                                 =   Dictionary {};

    toList#: { string -> T } -> [ { key: string, value: T } ]
    =   dictionary:
          list.fold
          (
            pairs:
            key:
              pairs
              ++  [
                    {
                      inherit key;
                      value             =   dictionary.${key};
                    }
                  ]
          )
          []
          (getKeys dictionary);
  in
    Dictionary
    //  {
          inherit Dictionary;
          inherit filter map getKeys;
          inherit fromList toList;
        }

  /*

    # string -> [ { T... } ] -> [ T ]
    # where T: Any
    collect
    =   intrinsics.catAttrs
    or  (
          name:
          pairs:
            list.fold
            (
              result:
              { ... } @ entry:
                if hasAttribute name entry
                then
                  result ++ [ entry.${name} ]
                else
                  result
            )
            [ ]
            pairs
        );

    # { T } -> [ string ] -> { T... }
    # where T: Any:
    filterByName
    =   { ... } @ dictionary:
        keys:
          fromList (list.map (name: { inherit name; value = dictionary.${name}; }) keys);

    filterKeys# F -> { T } -> { T }
    # where
    #   F: string -> bool,
    #   T: Any
    =   predicate:
        { ... } @ dictionary:
          filterByName dictionary (list.filter predicate (names dictionary));

    filterValue# F -> { T } -> { T }
    # where
    #   F: T -> bool,
    #   T: Any
    =   predicate:
        { ... } @ dictionary:
          filterByName dictionary (list.filter (name: predicate dictionary.${name}) (names dictionary));



    # D -> [ T ] -> { D... }
    # where
    #   F: T -> R,
    #   T, R: Any:
    fromListDefault
    =   value:
        list:
          fromList (list.map (name: { inherit name value; }));

    # F -> [ T ] -> { R... }
    # where
    #   F: T -> { name: string, value: R },
    #   T, R: Any:
    fromListMapped
    =   function:
        list:
          fromList (list.map function list);

    # F -> [ T ] -> { R... }
    # where
    #   F: int -> T -> { name: string, value: R },
    #   T, R: Any:
    fromListIMapped
    =   function:
        list:
          fromList (list.imap function list);

    # F -> [ T ] -> { R... }
    # where
    #   F: T -> R,
    #   T, R: Any:
    fromListMappedValue
    =   function:
        list:
          fromList (list.map (name: { inherit name; value = function name; }) list);

    # F -> [ T ] -> { R... }
    # where
    #   F: int -> T -> R,
    #   T, R: Any:
    fromListIMappedValue
    =   function:
        list:
          fromList (list.imap (index: name: { inherit name; value = function index name; }) list);




    # { ... } -> { ... } -> { ... }
    intersect
    =   intrinsics.intersectAttrs
    or  (
          left:
          right:
            list.fold
            (
              result:
              entry:
                if hasAttribute entry right
                then
                  result // { ${entry} = right.${entry}; }
                else
                  result
            )
            { }
            (names left)
        );

    mapNamesAndValues#: F -> { T... } -> { R... }
    # where
    #   F: string -> T -> { name: string, value: R }
    #   T, R: Any,
    =   function:
        dictionary:
          fromList ( mapToList function dictionary );

    # F -> { T... } -> { R... }
    # where
    #   F: T -> R,
    #   T, R: Any:
    mapValues
    =   function:
          map
          (
            _:
            value:
              function value
          );

    # F -> { T... } -> [ R ]
    # where
    #   F: string -> T -> R,
    #   T, R: Any:
    mapToList
    =   function:
        { ... } @ dictionary:
          values ( map function dictionary );


    pair#: n, T @ n:[ string ] -> n:[ T ] -> { T }
    =   names:
        values:
          if  isList names
          &&  isList values
          &&  length names == length values
          then
            fromListIMappedValue (index: name: list.get values index) names
          else
            debug'.panic "pair" "Names and Values must be two lists of same length!";

    pairNameWithValue
    =   name: value: { inherit name value; };

    # { ... } -> [ string ] -> { ... }:
    remove
    =   intrinsics.removeAttrs
    or  (
          { ... } @ dictionary:
          list:
            list.fold
            (
              result:
              name:
                if !( find list name )
                then
                  result
                  //  {
                        ${name}           =   dictionary.${name};
                      }
                else
                  result
            )
            { }
            (names dictionary)
        );

    # { T... } -> string -> T
    # where T: Any:
    select                                =   { ... } @ dictionary: field: dictionary.${field};

    # { ... } -> [ T ]
    # where T: Any
    values
    =   intrinsics.attrValues
    or  (
          { ... } @ dictionary:
          list.map (name: dictionary.${name}) (names dictionary)
        );
  in
  {
    inherit collect filter filterByName filterKeys filterValue fold fromList fromListDefault fromListMapped mapNamesAndValues
            fromListMappedValue get getOr hasAttribute intersect map mapToList mapValues names pair pairNameWithValue
            remove select values;
  }
  */