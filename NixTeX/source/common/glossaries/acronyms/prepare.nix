{ core, ... }:
  let
    inherit(core) debug set string type;
  in
    { ... } @ acronyms:
    (
      set.map
      (
        name:
        { description ? null, ... } @ acronym:
          let
            acronym'
            =   acronym
            //  {
                  inherit name;
                  full                  =   { __toString = self: "\\acrfull{${name}}"; };
                  long                  =   { __toString = self: "\\acrlong{${name}}"; };
                  short                 =   { __toString = self: "\\acrshort{${name}}"; };
                  as                    =   text: { __toString = self: "\\acrtext[${name}]{${text}}"; };
                };
          in
            type.matchPrimitiveOrPanic description
            {
              null                      =   acronym';
              lambda                    =   acronym' // { description = description acronym'; };
              set                       =   acronym';
            }
      )
      acronyms
    )
