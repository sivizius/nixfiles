{ core, document, ... } @ libs:
let
  inherit(core) list;
in
{
  initEvaluationState
  =   {
        __functor
        =   list.fold
            (
              { counter, list, lookUp, ... } @ self:
              name:
                if  lookUp.${name} or null == null
                then
                  {
                    counter             =   counter + 1;
                    list                =   list ++ [ name ];
                    lookUp              =   lookUp // { ${name} = counter; };
                  }
                else
                  self
            );
        counter                         =   0;
        list                            =   [ ];
        lookUp                          =   { };
      };
}