{ any, debug, expression, function, intrinsics, lambda, set, ... }:
  let
    TypeConstructor
    =   type "TypeConstructor"
        {
          from
          =   let
                __functor
                =   { apply, instanciate, ... } @ self:
                    argument:
                      let
                        result          =   apply argument;
                      in
                        if lambda.isInstanceOf result
                        then
                          self
                          //  {
                                apply   =   result;
                              }
                        else
                          instanciate self result;
              in
                kind:
                apply:
                instanciate:
                  TypeConstructor.instanciateAs kind
                  {
                    inherit apply instanciate;
                    inherit __functor;
                  };
        };

    applyFunction
    =   from:
        value:
          let
            value'                      =   from value;
          in
            # Check if the same function?
            if value'.isFunction or false
            then
              applyFunction value'
            else
              value';

    applyLambda
    =   { expect, from, ... } @ self:
        value:
          let
            value'                      =   from value;
          in
            if  lambda.isInstanceOf value'
            then
              applyLambda (self // { from = value'; })
            else
              expect value';

    defaultFunctor
    =   { expect, from ? null, ... } @ self:
        value:
          if        lambda.isInstanceOf from
          then
            applyLambda self value
          else if  from.isFunction or false
          then
            applyFunction from value
          else
            expect value;

    defaultInstanceOf
    =   this:
        value:
          get value == this;

    defaultMergeWith
    =   variant:
        prev:
        next:
          debug.panic [ variant "defaultMergeWith" ]
          {
            text                        =   "Could not merge values of ${variant}, because they are not equal!";
            data                        =   { inherit prev next; };
            when                        =   prev != next;
          }
          prev;

    defaultToString
    =   self:
          debug.panic [ (format self) "defaultToString" ]
          {
            text                        =   "Cannot coerce value of type ${format self} to string!";
            data                        =   self;
            nice                        =   true;
          };

    enum
    =   let
          constructEnum
          =   { __variant__, ... } @ self:
              variantName:
              value:
                let
                  constructor
                  =   function:
                        TypeConstructor
                          "${enumName}::${variantName}"
                          function
                          (_: instanciate);
                  enumName              =   __variant__;
                  instanciate           =   self.instanciateAs variantName;
                in
                  if      type.isInstanceOf   value
                  then
                    constructor value.expect
                  else if lambda.isInstanceOf value
                  then
                    constructor value
                  else
                    instanciate value;
        in
          TypeConstructor "enum"
          (
            enumName:
            { ... } @ variants:
              { inherit enumName variants; }
          )
          (
            { ... }:
            { enumName, variants, ... }:
              let
                from
                =   variantName:
                      debug.panic [ "enum" enumName "from" ]
                      {
                        text
                        =   ''
                              There is no variant `${variantName}` in enum `${enumName}`.
                              Valid variants are:
                            '';
                        data            =   variants;
                        when            =   !(set.hasAttribute variants variantName);
                      }
                      (constructEnum self variantName variants.${variantName});
                match
                =   value:
                    { ... } @ cases:
                      let
                        case            =   cases.${getVariant value'};
                        case'
                        =   if lambda.isInstanceOf case
                            then
                              case value'
                            else
                              case;
                        missing         =   set.remove variants (set.names cases);
                        unexpected      =   set.remove cases (set.names variants);
                        value'          =   self.expect value;
                      in
                        debug.panic [ "enum" enumName "match" ]
                        {
                          text          =   "Unexpected variants:";
                          data          =   unexpected;
                          when          =   unexpected != {};
                        }
                        debug.panic [ "enum" enumName "match" ]
                        {
                          text          =   "The following variants are not covered:";
                          data          =   missing;
                          when          =   missing != {};
                        }
                        case';
                self
                =   type enumName
                    (
                      (set.map (constructEnum self) variants)
                      //  { inherit from match; }
                    );
              in
                self
          );

    extend
    =   { __variant__, ... } @ self:
        {
          __functor     ? (self.__functor     or  defaultFunctor),
          __toString    ? (self.__toString    or  defaultToString),
          isInstanceOf  ? (self.isInstanceOf  or  (defaultInstanceOf __variant__)),
          mergeWith     ? (self.mergeWith     or  defaultMergeWith),
          __public__    ? self.__public__ or null,
          ...
        } @ definition:
          let
            expect
            =   value:
                  if isInstanceOf value
                  then
                    value
                  else if debug.Debug.isInstanceOf value
                  then
                    abort "${value}"
                  else
                    debug.dafuq [ __variant__ "expect" ]
                    {
                      text              =   "Value of `${__variant__}` expected, got: `${get value}`!";
                      data              =   value;
                      nice              =   true;
                    }
                    (abort "???");
            instanciate                 =   instanciateAs null;
            instanciateAs
            =   variantName:
                value:
                  let
                    value'
                    =   if set.isInstanceOf value
                        then
                          value
                        else
                          { inherit value; };
                  in
                    value'
                    //  {
                          __type__      =   __variant__;
                          __variant__   =   variantName;
                          getType       =   __variant__;
                          getVariant    =   variantName;
                          inherit __public__;
                        };
          in
            self
            //  definition
            //  {
                  inherit(self) __traits__ __type__ __variant__;
                  inherit __functor __toString __public__
                          isInstanceOf mergeWith;
                  inherit expect instanciate instanciateAs;
                };

    format
    =   self:
          let
            typeName                    =   getType     self;
            variantName                 =   getVariant  self;
          in
            if typeName != null
            then
              if variantName != null
              then
                "${typeName}::${variantName}"
              else
                typeName
            else
              "primitive ${getPrimitive self}";

    from
    =   typeName:
        { ... } @ definition:
          extend
            {
              __public__                =   null;
              __traits__                =   {};
              __type__                  =   "type";
              __variant__               =   typeName;
            }
            definition;

    # Get Type
    get#: T: Introspection @ T -> string
    =   value:
          let
            typeName                    =   getType value;
          in
            if typeName != null
            then
              typeName
            else
              getPrimitive value;

    getPrimitive#: T: Introspection @ T -> string
    =   intrinsics.typeOf;

    getType
    =   this:
          let
            this'                       =   expression.tryEval this;
          in
            if this'.success
            then
              this'.value.__type__ or null
            else
              "never";

    getVariant
    =   this:
          this.__variant__ or null;

    isReserved
    =   name:
          {
            # special methods, hardcoded into nix
            __functor                   =   true;
            __toString                  =   true;
            # custom type system
            __traits__                  =   true;
            __type__                    =   true;
            __variant__                 =   true;
          }.${name} or false;

    # Type Checks
    matchPrimitive# T: Introspection, R1, R2, R3, R4, R5, R6, R7, R8, R9
    #@  T
    #-> { bool: R1, float: R2, int: R3, lambda: R4, list: R5, null: R6, path: R7, set: R8, string: R9 }
    #-> R
    =   value:
        { bool, float, int, lambda, list, null, path, set, string } @ select:
          select.${getPrimitive value};

    matchPrimitive'
    =   function "matchPrimitive"
          [ any any any ]
          matchPrimitive;

    matchPrimitiveOrDefault# T: Introspection, D, R1, R2, R3, R4, R5, R6, R7, R8, R9
    #@  T
    #-> { bool: R1, float: R2, int: R3, lambda: R4, list: R5, null: R6, path: R7, set: R8, string: R9 }
    #-> D
    #-> R | D
    =   value:
        { ... } @ select:
        default:
          select.${getPrimitive value} or default;

    matchPrimitiveOrDefault'
    =   function "matchPrimitiveOrDefault"
          [ any any any any ]
          matchPrimitiveOrDefault;

    matchPrimitiveOrPanic
    =   value:
        select:
          matchPrimitiveOrDefault value select
          (
            debug.panic "matchPrimitiveOrPanic"
            {
              text                      =   "Primitive Type ${getPrimitive value} was not handled";
              data                      =   value;
            }
          );

    matchPrimitiveOrPanic'
    =   function "matchPrimitiveOrPanic"
          [ any any any ]
          matchPrimitiveOrPanic;

    struct#: string -> { string } -> type
    =   let
          checkFields
          =   structName:
              fields:
              signatures:
                let
                  unexpected            =   set.remove fields (set.names signatures);
                in
                  set.map
                  (
                    name:
                    { expect, ... } @ signature:
                      expect
                      (
                        fields.${name}
                        or  signature.default
                        or  (
                              debug.panic [ "struct" structName "checkFields" ]
                              {
                                text    =   "Field `${name}` is empty and type `${getVariant signature}` does not provide a default!";
                                data    =   signature;
                              }
                            )
                      )
                  )
                  (
                    debug.panic [ "struct" structName "checkFields" ]
                    {
                      text              =   "Unexpected fields:";
                      data              =   unexpected;
                      when              =   unexpected != {};
                      nice              =   true;
                    }
                    signatures
                  );
        in
          TypeConstructor "struct"
          (
            structName:
            { ... } @ definition:
              let
                inner                   =   set.partitionByValue type.isInstanceOf definition;
              in
              {
                inherit structName;
                types                   =   inner.right;
                values                  =   inner.wrong;
              }
          )
          (
            { ... }:
            { structName, types, values }:
              let
                self
                =   type structName
                    (
                      values
                      //  {
                            from
                            =   fields:
                                  self.instanciate
                                  (
                                    checkFields
                                      structName
                                      fields
                                      types
                                  );
                          }
                    );
              in
                self
          );

    trait#: string -> ({ ... } -> { ... }) -> trait
    =   traitName:
        methods:
          type traitName
          (
            methods
            //  {
                  from
                  =   object:
                        if type.isInstanceOf object
                        then
                          { ... } @ required:
                            object
                            //  {
                                  __traits__
                                  =   object.__traits__
                                  //  {
                                        ${traitName}
                                        =   required
                                        //  (methods required);
                                      };
                                }
                        else
                          method:
                            let
                              methods   =   (object.__traits__ or {}).${traitName} or null;
                            in
                              debug.panic [ "trait" traitName "from" ]
                              {
                                text    =   "Object of type `${get object}` does not implement `${traitName}`";
                                data    =   object;
                                when    =   methods != null;
                              }
                              methods.${method} object;
                }
          );

    type
    =   from "type"
        {
          inherit TypeConstructor;
          __functor
          =   { ... }:
                from;
          inherit defaultInstanceOf;
          inherit format get getPrimitive getType getVariant;
          inherit matchPrimitive matchPrimitiveOrDefault matchPrimitiveOrPanic;
          inherit enum struct trait;
        };
  in
    type
