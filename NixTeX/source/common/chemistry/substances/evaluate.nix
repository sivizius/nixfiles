{ core, ... } @ libs:
let
  inherit(core) debug list;

  init
  =   concise:
      {
        __functor                       =   evaluate;
        counter                         =   if concise then 0 else 1; # ToDo !!!
        lookUp                          =   { };
        ordered                         =   [ ];
      };

  evaluate
  =   { counter, lookUp, ordered, ... } @ self:
      arguments:
        let
          name                          =   list.head arguments;
        in
          if lookUp.${name} or null != null
          then
            self
          else
            self
            //  {
                  counter               =   counter + 1;
                  lookUp
                  =   lookUp
                  //  {
                        ${name}         =   counter;
                      };
                  ordered               =   ordered ++ [ name ];
                };
in
  init
