{ list, type, ... }:
  let
    # F -> [ T ] -> [ T ]
    # where
    #   F: T -> T -> bool,
    #   T: Any:
    funnySort
    =   let
          maxInsertion                  =   20;
        in
          lessThan:
          parts:
            let
              len                       =   list.length parts;
            in
              if      len < 2
              then
                # Empty list or just one element
                parts
              else if len <= maxInsertion
              then
                # Insertion Sort, average: O(n²), maximum is O(400), so…fine?
                insertionSort lessThan parts
              else
                # Merge Sort, average: O(n log(n))
                mergeSort     lessThan parts;

    # F -> [ T ] -> [ T ]
    # where
    #   F: T -> T -> bool,
    #   T: Any:
    insertionSort
    =   let
          # F -> T -> [ T ] -> [ T ]
          # where
          #   F: T -> T -> bool,
          #   T: Any
          insert
          =   lessThan:
              first:
              rest:
                if rest == [ ]
                then
                  [ first ]
                else
                  let
                    second              =   list.head rest;
                  in
                    if lessThan first second
                    then
                      [ first  ] ++ rest
                    else
                      [ second ] ++ (insert lessThan first (list.tail rest));
        in
          lessThan:
          parts:
            if parts == [ ]
            then
              [ ]
            else
              insert lessThan (list.head parts) (insertionSort (list.tail parts));

    # F -> [ T ] -> [ T ]
    # where
    #   F: T -> T -> bool,
    #   T: Any:
    mergeSort
    =   lessThan:
        parts:
          let
            len                         =   list.length parts;
            half                        =   len / 2;
            half'                       =   len - half;
            left                        =   list.generate (x: list.get parts x             ) half;
            right                       =   list.generate (x: list.get parts ( x + half )  ) half';
          in
            (
              list.fold
              (
                { done, left ? null, right ? null, result } @ state:
                _:
                  if done
                  then
                    state
                  else if left == [ ]
                  then
                  {
                    done                =   true;
                    result              =   result ++ right;
                  }
                  else if right == [ ]
                  then
                  {
                    done                =   true;
                    result              =   result ++ left;
                  }
                  else if lessThan (list.head left) (list.head right)
                  then
                  {
                    inherit right;
                    left                =   list.tail left;
                    result              =   result ++ (list.head left);
                  }
                  else
                  {
                    inherit left;
                    right               =   list.tail right;
                    result              =   result ++ (list.head right);
                  }
              )
              {
                done                    =   false;
                left                    =   funnySort lessThan left;
                right                   =   funnySort lessThan right;
                result                  =   [ ];
              }
              (list.empty len)
            ).result;
  in
    { inherit funnySort insertionSort mergeSort; }
