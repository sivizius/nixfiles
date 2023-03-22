{ core, ... }:
  let
    inherit(core) debug indentation list path set string type;

    formatAttributes
    =   prefix:
        { ... } @ attributes:
          list.concat
          (
            set.mapToList
              (
                name:
                value:
                  if  set.isInstanceOf value
                  &&  value.__toString or null == null
                  then
                    formatAttributes "${prefix}${name}-" value
                  else
                    [ "${prefix}${name}: ${string value};" ]
              )
              attributes
          );

    CSS
    =   type "CSS"
        {
          from
          =   { ... } @ definition:
                CSS.instanciate
                {
                  inherit definition;

                  __toString
                  =   { definition, ... }:
                        indentation {}
                        (
                          list.concat
                          (
                            set.mapToList
                              (
                                selector:
                                { ... } @ attributes:
                                  [ "${selector} {" indentation.more ]
                                  ++  (formatAttributes "" attributes)
                                  ++  [ indentation.less "}" ]
                              )
                              definition
                          )
                        );
                };
        };
  in
    CSS // { inherit CSS; }
