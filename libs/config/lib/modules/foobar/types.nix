{ lib, ... }:
  let
    inherit(lib) types;
  in
  {
    addCheck
    =   foo:
        bar:
          (types.addCheck foo bar)
          //  {
              };
    attrs
    =   types.attrs
    //  {
        };
    attrsOf
    =   legacy:
          (types.attrsOf legacy)
          //  {
              };
    bool
    =   types.bool
    //  {
        };
    coercedTo
    =   foo:
        bar:
        baz:
          (types.coercedTo foo bar baz)
          //  {
              };
    either
    =   foo:
        bar:
          (types.either foo bar)
          //  {
              };
    enum
    =   legacy:
          (types.enum legacy)
          //  {
              };
    int
    =   types.int
    //  {
        };
    lines
    =   types.lines
    //  {
        };
    listOf
    =   legacy:
          (types.listOf legacy)
          //  {
              };
    nonEmptyListOf
    =   legacy:
          (types.nonEmptyListOf legacy)
          //  {
              };
    nullOr
    =   legacy:
          (types.nullOr legacy)
          //  {
              };
    oneOf
    =   legacy:
          (types.oneOf legacy)
          //  {
              };
    path
    =   types.path
    //  {
        };
    package
    =   types.package
    //  {
        };
    port
    =   types.port
    //  {
        };
    raw
    =   types.raw
    //  {
        };
    singleLineStr
    =   types.singleLineStr
    //  {
        };
    str
    =   types.str
    //  {
        };
    strMatching
    =   legacy:
          (types.strMatching legacy)
          //  {
              };
    submodule
    =   legacy:
          (types.submodule legacy)
          //  {
              };
    submoduleWith
    =   legacy:
          (types.submoduleWith legacy)
          //  {
              };
    unspecified
    =   types.unspecified
    //  {
        };
  }
