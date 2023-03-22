{ any, debug, expression, function, intrinsics, never, set, type, ... }:
  let
    Derivation
    =   type "Derivation"
        {
          inherit from fromStrict isInstanceOf isInstanceOf' parseName;
        };

    from
    =   function "from"
          [ any Derivation ]
          (
            { name, builder, system, ... } @ drvAttrs:
              Derivation.instanciate
              (
                if intrinsics ? derivation
                then
                  intrinsics.derivation drvAttrs
                else
                {
                  inherit name drvAttrs;
                  all                   =   never.never; # ToDo!
                  builder               =   builder; # ToDo: Check!
                  drvPath               =   never.never; # ToDo!
                  out                   =   never.never; # ToDo!
                  outPath               =   never.never; # ToDo!
                  outputName            =   "out";
                  system                =   system; # ToDo: Check!
                  type                  =   "derivation";
                }
              )
          );

    fromStrict
    =   function "fromStrict"
          [ any any ]
          (
            { name, builder, system, ... } @ drvAttrs:
              Derivation.instanciate
              (
                intrinsics.derivationStrict drvAttrs
              )
          );

    isInstanceOf
    =   value:
          let
            legacy                      =   isLegacy value;
          in
            (type.defaultInstanceOf "Derivation" value)
            ||  (
                  debug.error "isInstanceOf"
                  {
                    text                =   "Legacy Derivation detected!";
                    data                =   { keys = set.names value; inherit(value) name pname outPath; };
                    when                =   legacy;
                  }
                  legacy
                );

    isInstanceOf'
    =   value:
          (type.defaultInstanceOf "Derivation" value) || (isLegacy value);

    isLegacy
    =   value:
          let
            value'                      =   expression.tryEval value;
          in
            value'.value.type or null == "derivation";

    parseName
    =   intrinsics.parseDrvName;
  in
    Derivation
