{ debug, list, string, type, ... }:
  let
    Indentation
    =   type.enum "Indentation"
        {
          less                          =   null;
          more                          =   null;
        };
  in
  {
    inherit(Indentation) less more;

    # string -> string | [ string | bool | null ] -> string
    __functor#: self -> string | [ string | Indentation | null ] -> string
    =   self:
        { initial ? "", tab ? "  ", ... }:
        body:
        (
          list.fold
          (
            # S -> null | string | bool -> S
            # where S: { depth: uint, indent: string, result: string }
            { cache, depth, indent, lineNumber, result, tab } @ state:
            line:
              type.matchPrimitiveOrPanic line
              {
                null                    =   state;
                string
                =   state
                //  {
                      lineNumber        =   lineNumber + 1;
                      result            =   "${result}${indent}${line}\n";
                    };
                set
                =   state
                //  (
                      if Indentation.isInstanceOf line
                      then
                        Indentation.match line
                        {
                          more
                          =   let
                                depth'  =   depth + 1;
                                cache'
                                =   if list.length cache <= depth'
                                    then
                                      cache ++ [ "${list.foot cache}${tab}" ]
                                    else
                                      cache;
                              in
                              {
                                cache   =   cache';
                                depth   =   depth';
                                indent  =   list.get cache' depth';
                              };
                          less
                          =   if depth > 0
                              then
                                let
                                  depth'=   depth - 1;
                                in
                                {
                                  depth =   depth';
                                  indent=   list.get cache depth';
                                }
                              else
                                debug.panic [] "Cannot indent less than zero." null;
                        }
                      else
                        debug.panic [] "Got set, but either string or Indentation was expected!" null
                    );
              }
          )
          {
            cache                       =   [ initial ];
            depth                       =   0;
            indent                      =   initial;
            lineNumber                  =   0;
            result                      =   "";
            inherit tab;
          }
          (
            type.matchPrimitiveOrPanic body
            {
              list                      =   body;
              string                    =   string.splitLines body;
            }
          )
        ).result;
  }
