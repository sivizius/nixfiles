{ extendPath, ... }:
let
  inherit(builtins) all attrNames attrValues concatMap concatStringsSep dirOf elem elemAt filter foldl'
                    fromJSON functionArgs genList getFlake head listToAttrs isAttrs isBool isFloat
                    isFunction isInt isList isPath isString map match removeAttrs replaceStrings
                    split storeDir stringLength substring toString tryEval trace typeOf
                    unsafeGetAttrPos;

  anything
  =   { path, previous, value, ... } @ args:
        let
          type                    =   typeOf previous
        in
          if previous == null
          then
            value
          else if value == null
          then
            previous
          else if type == typeOf value
          then
            {
              lambda              =   throw "Cannot merge functions yet.";
              list                =   previous ++ value;
              set                 
            }.${type} or (equal args)
          else
            throw "The option `${path}' has conflicting types of definition values.";
  default
  =   { path, previous, value, ... }:
        throw "Not implemented yet!";

  equal
  =   { path, previous, value, ... }:
        if previous == value
        then
          value
        else
          throw "The option `${path}' has conflicting definition values.";

  functions
  =   { merge, ... }:
      { path, previous, value, ... }:
        args: merge (previous args) (value args);

  line
  =   { previous, value, ... }:
        let
          previous'                 =   head (split "\n" previous);
        in
          "${previous}${value}";

  lists
  =   { path, previous, value, ... }:
        previous ++ value;

  never
  =   { path, previous, value, ... }:
        throw "The option `${path}' is defined multiple times.";

  nullOr
  =   { merge, ... }:
      { path, previous, value, ... } @ self:
        if previous == null
        then
          value
        else if value != null
        then
          merge self
        else
          throw "The option `${path}` is defined both null and not null";

  sets
  =   { path, previous, value, ... }:
        let
          values                =   value;
        in
          foldl'
          (
            { ... } @ result:
            name:
              let
                value           =   value.${name};
                mergedSet
                =   attrs
                    {
                      path      =   extendPath path name;
                      previous  =   previous.${name};
                      inherit value;
                    };
                value'
                =   if hasAttribute name previous
                    then
                      if  isSet previous.${name}
                      &&  isSet value
                      then
                        mergedSet
                      else
                        throw "Cannot merge values of `${path}`, because of conflicting definition values of field `${name}`."
                    else
                      value;
              in
                result
                //  {
                      ${name}   =   value';
                    };
          )
          previous
          (attrNames value);

  stringsWith
  =   seperator:
      { previous, value, ... }:
        "${previous}${seperator}${value}";
in
{ 
  inherit anything default equal functions line lists never nullOr sets stringsWith;
}
