{ list, string, ... }:
  let
    concat                              =   splits: string.concat (list.flat splits);
    splitSpaces                         =   string.split "([[:space:]]+)";

    ltrim'
    =   parts:
          if list.head parts == ""
          && parts != [ "" ]
          then
            list.generate (x: list.get parts ( x + 2 )) ( list.length parts - 2 )
          else
            parts;
    rtrim'
    =   parts:
          if list.foot parts == ""
          && parts != [ "" ]
          then
            list.generate (x: list.get parts x) ( list.length parts - 2 )
          else
            parts;
    trim'                               =   text: list.flat ( rtrim' ( ltrim' ( splitSpaces text ) ) );
    trim                                =   text: string.concat ( trim' text );
  in
  {
    __functor                           =   self: trim;
    ltrim                               =   text: concat (ltrim' (splitSpaces text));
    rtrim                               =   text: concat (rtrim' (splitSpaces text));
    inherit ltrim' rtrim' trim trim';
  }
