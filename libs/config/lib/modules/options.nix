{ toMeta, types, ... }:
  let
    # Primitive Types
    Bool                                =   Option  types.bool              {};
    Float                               =   Option  types.float             {};
    Integer                             =   Option  types.integer           {};
    Lines                               =   Option  types.lines             {};
    List                                =   Option  types.list              {};
    Null                                =   Option  types.null              {};
    Number                              =   Option  types.number            {};
    Path                                =   Option  types.path              {};
    PositiveInteger                     =   Option  types.positiveInteger   {};
    PositiveNumber                      =   Option  types.positiveNumber    {};
    String                              =   Option  types.string            {};
    UnsignedInteger                     =   Option  types.unsignedInteger   {};

    # Composed Types
    Either                              =   this: that: Option  (types.either this that)  {};
    Enum                                =   variants:   Option  (types.enum   variants)   {};
    ListOf                              =   subtype:    Option  (types.listOf subtype)    {};
    NullOr                              =   subtype:    Option  (types.nullOr subtype)    {};
    SetOf                               =   subtype:    Option  (types.setOf  subtype)    {};
  in
  {
    inherit Bool Float Integer Lines List Null Number Path PositiveInteger PositiveNumber String UnsignedInteger;
    inherit Either Enum ListOf NullOr SetOf;

    # Primitive Types
    Bool'
    =   default:
        meta:
          let
            this                        =   Bool meta;
          in
            this
            //  {
                  inherit default;
                  meta
                  =   this.meta
                  //  {
                        example         =   !default;
                      };
                };

    Disable
    =   meta:
          Option types.bool { default = true; }
          (
            (toMeta meta)
            //  {
                  example               =   false;
                }
          );

    Enable
    =   meta:
          Option types.bool { default = false; }
          (
            (toMeta meta)
            //  {
                  example               =   true;
                }
          );

    Float'                              =   default: meta:  (Float            meta) // { inherit default; };
    Integer'                            =   default: meta:  (Integer          meta) // { inherit default; };
    Lines'                              =   default: meta:  (Lines            meta) // { inherit default; };
    List'                               =   default: meta:  (List             meta) // { inherit default; };
    Null'                               =   default: meta:  (Null             meta) // { inherit default; };
    Number'                             =   default: meta:  (Number           meta) // { inherit default; };
    Path'                               =   default: meta:  (Path             meta) // { inherit default; };
    PositiveInteger'                    =   default: meta:  (PositiveInteger  meta) // { inherit default; };
    PositiveNumber'                     =   default: meta:  (PositiveNumber   meta) // { inherit default; };
    String'                             =   default: meta:  (String           meta) // { inherit default; };
    UnsignedInteger'                    =   default: meta:  (UnsignedInteger  meta) // { inherit default; };

    # Composed Types
    Enum'                               =   variants: default: meta:  (Enum   variants  meta) //  { inherit default; };
    ListOf'                             =   subtype:  default: meta:  (ListOf subtype   meta) //  { inherit default; };
    NullOr'                             =   subtype:  default: meta:  (NullOr subtype   meta) //  { inherit default; };
    SetOf'                              =   subtype:  default: meta:  (SetOf  subtype   meta) //  { inherit default; };
  }
