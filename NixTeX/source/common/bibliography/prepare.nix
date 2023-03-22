{ bibliography, core, document, ... } @ libs:
let
  inherit(core)     debug list path set string type;
  inherit(document) escapeEncode;

  citeList
  =   self:
      citations:
        let
          result
          =   list.fold
              (
                { encode, range, previous, text, ... } @ state:
                name:
                  if self.${name} or null != null
                  then
                    if self.${name} ? id
                    then
                      state
                      //  {
                            range       =   previous != null && self.${name}.id == ( previous + 1 );
                            previous    =   self.${name}.id;
                            text
                            =   if text == null
                                then
                                  "${string self.${name}.id}"
                                else if previous != null
                                &&      self.${name}.id == ( previous + 1 )
                                then
                                  text
                                else if range
                                then
                                  "${text}–${string self.${name}.id}"
                                else
                                  "${text},${string self.${name}.id}";
                          }
                    else
                      {
                        encode          =   encode ++ [ name ];
                      }
                  else
                    debug.panic "citeList" "Unknown Reference »${name}«!"
              )
              {
                range                   =   false;
                previous                =   null;
                text                    =   null;
                encode                  =   [ ];
              }
              citations;
          text
          =   if result.text != null
              then
                result.text
              else
                "[???]";
        in
          if result.encode == []
          then
            "\\textsuperscript{[${text}]}"
          else
            escapeEncode "bibliography" result.encode;

  citeString
  =   self:
      name:
        if self.${name} or null != null
        then
          if self.${name}.id or null != null
          then
            "\\textsuperscript{[${string self.${name}.id}]}"
          else
            escapeEncode "bibliography" [ name ]
        else
          debug.panic "citeString" "Unknown Reference »${name}«!";

  prepare
  =   references:
        type.matchPrimitiveOrPanic references
        {
          lambda                        =   prepare ( references libs );
          path                          =   prepare ( path.import references );
          set
          =   (
                set.map
                (
                  name:
                  value:
                    value
                    //  {
                          inherit name;
                          __toString
                          =   self:
                                "\\cite{${name}}";
                        }
                )
                references
              )
          //  {
                __functor
                =   self:
                    name:
                      type.matchPrimitiveOrPanic name
                      {
                        #list            =   citeList    self name;
                        string          =   citeString  self name;
                      };
              };
        };
in
  prepare