{ core, document, ... } @ libs:
let
  inherit(core)       debug library list;
  inherit(list)       generate get head length toSet;

  libs'
  =   libs
  //  {
        Mixture
        =   substances:
            { ... } @ object:
              object
              //  {
                    __type__            =   "Mixture";
                    inherit substances;
                  };

        Substance
        =   name:
            { ... } @ object:
              object
              //  {
                    __type__            =   "Substance";
                    inherit name;
                  };
      };

  finalise#: { string -> Substance } -> [ Substance ] -> { string -> Substance }
  =   { ... } @ substances:
      { ordered, ... } @ state:
        substances
        //  toSet
            (
              generate
              (
                id:
                  let
                    name                =   get ordered id;
                    substance           =   substances.${name};
                  in
                    {
                      inherit name;
                      value
                      =   substance
                      //  {
                            inherit id;
                          };
                    }
              )
              (length ordered)
            );

  call
  =   state:
      argument:
        let
          name                          =   head argument;
        in
          if state.substances.lookUp.${name} or null != null
          then
            state
          else
            state
            //  {
                  substances
                  =   state.substances
                  //  {
                        counter         =   state.substances.counter + 1;
                        list            =   state.substances.list ++ [ name ];
                        lookUp
                        =   state.substances.lookUp
                        //  {
                              ${name}   =   state.substances.counter;
                            };
                      };
                };
in
{
  inherit(library.import ./check.nix libs') check check' checkNovel;
  inherit(libs') Mixture Substance;
  evaluate                              =   library.import ./evaluate.nix libs';
  prepare                               =   library.import ./prepare.nix  libs';
  toLua                                 =   library.import ./lua.nix      libs';
  inherit finalise;
}