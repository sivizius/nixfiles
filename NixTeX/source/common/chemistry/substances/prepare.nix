{ chemistry, core, document, physical, Substance, ... } @ libs:
  let
    inherit(core)       context debug list path type;
    inherit(chemistry)  compound elements;
    inherit(elements)   calculateMassOfFormula normaliseMolecularFormula;

    defaultOptions#: { code: bool ? false, ... } -> { code: bool, ... }
    =   {
          code      ? false,
          id        ? false,
          mass      ? false,
          name      ? false,
          structure ? false,
        }:
        { inherit code id mass name structure; };

    parseOptions
    =   options:
          defaultOptions
          (
            {
              "i"                       =   { id = true; };
            }.${options}
          );

    format#: Substance -> Options -> string
    =   { name, fake ? false, ... } @ substance:
        options:
          let
            options'
            =   type.matchPrimitiveOrPanic options
                {
                  set                   =   defaultOptions  options;
                  string                =   parseOptions    options;
                };
          in
            if      options' == { code = false; id = false; mass = false; name = false; structure = false; }
            then
              "\\directlua{substances.printNumber([[${name}]])}"
            else if options' == { code = true;  id = false; mass = false; name = false; structure = false; }
            then
              "\\directlua{substances.printCode([[${name}]])}"
            else if options' == { code = false; id = true;  mass = false; name = false; structure = false; }
            then
              "\\directlua{substances.printNumber([[${name}]])}"
            else if options' == { code = true;  id = true;  mass = false; name = false; structure = false; }
            then
              "\\directlua{substances.printCodeID([[${name}]])}"
            else if options' == { code = false; id = false; mass = true;  name = false; structure = false; }
            then
              "\\directlua{substances.printMass([[${name}]])}"
            else if options' == { code = false; id = false; mass = false; name = true;  structure = false; }
            then
              "\\directlua{substances.printName([[${name}]])}"
            else if options' == { code = true;  id = false; mass = false; name = true;  structure = false; }
            then
              "\\directlua{substances.printWithCode([[${name}]])}"
            else if options' == { code = false; id = true;  mass = false; name = true;  structure = false; }
            then
              "\\directlua{substances.printWithID([[${name}]])}"
            else if options' == { code = false; id = false; mass = false; name = false; structure = true;  }
            then
              "\\directlua{substances.printMolecule([[${name}]])}"
            else if options' == { code = true;  id = false; mass = false; name = false; structure = true;  }
            then
              "\\directlua{substances.printMoleculeWithCode([[${name}]])}"
            else if options' == { code = false; id = true;  mass = false; name = false; structure = true;  }
            then
              "\\directlua{substances.printMoleculeWithNumber([[${name}]])}"
            else if options' == { code = true;  id = true;  mass = false; name = false; structure = true;  }
            then
              "\\directlua{substances.printMoleculeWithNumberCode([[${name}]])}"
            else if options' == { code = false; id = false; mass = true;  name = false; structure = true;  }
            then
              "\\directlua{substances.printMoleculeWithMass([[${name}]])}"
            else
              debug.unimplemented "format";

    libs'
    =   libs
    //  {
          chemistry
          =   chemistry
          //  {
                inherit Substance;
              };
        };

    prepare
    =   source:
        substances:
          type.matchPrimitiveOrPanic substances
          {
            null                        =   [];
            lambda                      =   prepare source ( substances libs' );
            path
            =   prepare
                  (source substances)
                  (path.importScoped { inherit Substance; } substances);
            list                        =   list.concatMap (prepare source) substances;
            set
            =   let
                  substance             =   substances;
                  formula               =   normaliseMolecularFormula substance.formula or [];
                  value
                  =   substance
                  //  {
                        inherit formula source;
                        dalton          =   calculateMassOfFormula formula;
                      };
                in
                [
                  {
                    inherit(value) name;
                    value
                    =   value
                    //  {
                          __functor     =   _: format value;
                          __toString    =   _: format value {};
                          CodeID        =   format value { code = true; id = true;                };
                          ID            =   format value {              id = true;                };
                          Name          =   format value {                          name = true;  };
                          NameID        =   format value {              id = true;  name = true;  };
                        };
                  }
                ];
          };
  in
    substances:
      list.toSet (prepare (context "substances") substances)
