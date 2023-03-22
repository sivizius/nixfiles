{ debug, lambda, library, list, set, string, type, ... }:
  let
    Function
    =   type.TypeConstructor "Function"
        (
          functionName:
          signature:
          {
            functionName                =   string.expect functionName;
            signature
            =   debug.panic "Function"
                {
                  text                  =   "Signature must be a list of type with at least two elements!";
                  data
                  =   {
                        inherit functionName signature;
                        isList          =   list.isInstanceOf signature;
                        length          =   list.length signature;
                        all             =   list.all type.isInstanceOf signature;
                      };
                  nice                  =   true;
                  when
                  =   !(list.isInstanceOf signature)
                  ||  (list.length signature < 2)
                  ||  !(list.all type.isInstanceOf signature);
                }
                list.map
                  (
                    argumentType:
                    {
                      inherit(argumentType) __traits__ __type__ __variant__
                                            isInstanceOf mergeWith
                                            expect instanciate instanciateAs;
                    }
                  )
                  signature;
          }
        )
        (
          { source, ... }:
          { functionName, signature }:
            let
              call
              =   { function, signature, ... } @ self:
                  argument:
                    let
                      function'         =   function ((list.head signature).expect argument);
                      signature'        =   list.tail signature;
                    in
                      if list.length signature' > 1
                      then
                        self
                        //  {
                              function  =   lambda.expect function';
                              signature =   signature';
                            }
                      else
                        (list.head signature').expect function';
              from
              =   function:
                    self.instanciate
                    {
                      inherit signature;
                      function          =   lambda.expect function;
                      __functor         =   call;
                      isFunction        =   true;
                      source            =   source';
                    };
              self                      =   type "${source'}" { inherit from; };
              source'                   =   source functionName;
            in
              self
        );
  in
    library.NeedInitialisation
    (
      { ... } @ self:
      { source, ... }:
        self
        //  {
              inherit source;
            }
    )
    (
      Function
      //  {
            inherit Function;
          }
    )
