{ core, physical, ... }:
let
  inherit(core)     debug list number set string type;
  inherit(physical) formatValue;

  fullTable
  =   set.map (symbol: value: value // { inherit symbol; } )
      {
        # Period 1
        H   = { dalton =  1.0080;  };
        He  = { dalton =  4.0026;  };

        # Period 2
        Li  = { dalton =   6.94;    };
        Be  = { dalton =   9.0122;  };
        B   = { dalton =  10.81;    };
        C   = { dalton =  12.011;   };
        N   = { dalton =  14.007;   };
        O   = { dalton =  15.999;   };
        F   = { dalton =  18.998;   };
        Ne  = { dalton =  20.180;   };

        # Period 3
        Na  = { dalton =  22.990;   };
        Mg  = { dalton =  24.305;   };
        Al  = { dalton =  26.982;   };
        Si  = { dalton =  28.085;   };
        P   = { dalton =  30.974;   };
        S   = { dalton =  32.06;    };
        Cl  = { dalton =  35.45;    };
        Ar  = { dalton =  39.948;   };

        # Period 4
        K   = { dalton =  39.098;   };
        Ca  = { dalton =  40.078;   };
        Sc  = { dalton =  44.956;   };
        Ti  = { dalton =  47.867;   };
        V   = { dalton =  50.942;   };
        Cr  = { dalton =  51.996;   };
        Mn  = { dalton =  54.938;   };
        Fe  = { dalton =  55.845;   };
        Co  = { dalton =  58.933;   };
        Ni  = { dalton =  58.693;   };
        Cu  = { dalton =  63.546;   };
        Zn  = { dalton =  65.380;   };
        Ga  = { dalton =  69.723;   };
        Ge  = { dalton =  72.630;   };
        As  = { dalton =  74.922;   };
        Se  = { dalton =  78.971;   };
        Br  = { dalton =  79.904;   };
        Kr  = { dalton =  83.798;   };

        # Period 5
        Rb  = { dalton =  85.468;   };
        Sr  = { dalton =  87.620;   };
        Y   = { dalton =  88.906;   };
        Zr  = { dalton =  91.224;   };
        Nb  = { dalton =  92.906;   };
        Mo  = { dalton =  95.950;   };
        Tc  = { dalton =  97.4;     };
        Ru  = { dalton = 101.07;    };
        Rh  = { dalton = 102.91;    };
        Pd  = { dalton = 106.42;    };
        Ag  = { dalton = 107.87;    };
        Cd  = { dalton = 112.41;    };
        In  = { dalton = 114.82;    };
        Sn  = { dalton = 118.71;    };
        Sb  = { dalton = 121.76;    };
        Te  = { dalton = 127.60;    };
        I   = { dalton = 126.90;    };
        Xe  = { dalton = 131.29;    };

        # Period 6
        Cs  = { dalton = 132.91;    };
        Ba  = { dalton = 137.33;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        #  = { dalton = ;    };
        Pb  = { dalton = 207.20;    };
        Bi  = { dalton = 208.98;    };
        Po  = { dalton = 209.98;    };
        At  = { dalton = 210;       };
        Rn  = { dalton = 222;       };

        # Period 7
      };
  tableOfMasses                         =   set.mapValues ( value: value.dalton ) fullTable;

  normaliseMolecularFormula
  =   let
        addElements
        =   { ... } @ elements:
            previous:
            count:
              type.matchPrimitiveOrPanic previous
              {
                set
                =   set.fold
                    (
                      { ... } @ elements:
                      name:
                      previous:
                        elements
                        //  {
                              ${name}   =   previous * count + ( elements.${name} or 0 );
                            }
                    )
                    elements
                    previous;
                string
                =   elements
                //  {
                      ${previous}       =   ( elements.${previous} or 0 ) + count;
                    };
                null                    =   elements;
              };
        getSymbol                       =   foo: foo.symbol or foo;
        parse
        =   { elements, previous } @ this:
            token:
              type.matchPrimitiveOrPanic token
              {
                int
                =   if previous != null
                    then
                    {
                      elements          =   addElements elements previous token;
                      previous          =   null;
                    }
                    else
                      debug.panic [ "normaliseMolecularFormula" "parse" ] "Unexpected Number!";
                list
                =   {
                      elements          =   addElements elements previous 1;
                      previous          =   normalise token;
                    };
                set
                =   {
                      elements          =   addElements elements previous 1;
                      previous          =   getSymbol token;
                    };
                string
                =   {
                      elements          =   addElements elements previous 1;
                      previous          =   token;
                    };
              };
        defaultState
        =   {
              elements                  =   { };
              previous                  =   null;
            };
        finalise                        =   { elements, previous }: addElements elements previous 1;
        normalise
        =   this:
              finalise ( list.fold parse defaultState this );
      in
        this: finalise (parse defaultState this);

  calculateMassOfFormula
  =   formula:
        debug.debug "calculateMassOfFormula"
        {
          text                          =   "Molecular Formula";
          data                          =   formula;
        }
        (
          type.matchPrimitiveOrPanic formula
          {
            null                        =   null;
            set
            =   set.fold
                (
                  state:
                  symbol:
                  count:
                    ( state + count * ( tableOfMasses.${symbol} or (debug.panic "calculateMassOfFormula" "Unknown symbol: ${symbol}")) )
                )
                0
                formula;
          }
        );

  formatMolecularFormula
  =   { ... } @ formula:
        list.fold
        (
          result:
          symbol:
            let
              count                     =   formula.${symbol} or 0;
            in
              if count == 0
              then
                result
              else if count == 1
              then
                "${result}${symbol}"
              else
                "${result}${symbol}${string count}"
        )
        ""
        (
          if formula.C or 0 == 0
          then
            set.names fullTable
          else
            [
              "C" "H"
              "Ag" "Al" "Ar" "As" "At" "B" "Ba" "Be" "Bi" "Br" "Ca" "Cd" "Cl" "Co"
              "Cr" "Cs" "Cu" "F" "Fe" "Ga" "Ge" "He" "I" "In" "K" "Kr" "Li" "Mg"
              "Mn" "Mo" "N" "Na" "Nb" "Ne" "Ni" "O" "P" "Pb" "Pd" "Po" "Rb" "Rh"
              "Rn" "Ru" "S" "Sb" "Sc" "Se" "Si" "Sn" "Sr" "Tc" "Te" "Ti" "V" "Xe"
              "Y" "Zn" "Zr"
            ]
        );

  mapAnalysis
  =   { formula, ... } @ substance:
      { ... } @ gotElements:
        if gotElements != { }
        then
          let
            formula'                    =   normaliseMolecularFormula formula;
            format
            =   elements:
                  string.concatCSV
                  (
                    set.mapToList
                    (
                      symbol:
                      value:
                        "\\ch{${symbol}}:~${formatValue { inherit value; precision = 2; } "percent"}"
                    )
                    elements
                  );
            calculated
            =   let
                  mapped                =   set.map (symbol: value: tableOfMasses.${symbol} * value) formula';
                  sum                   =   number.sum (set.values mapped);
                  filtered              =   set.map (symbol: _: mapped.${symbol} or 0.0 ) gotElements;
                  calcElements          =   set.mapValues (value: value / sum * 100.0) filtered;
                in
                  format calcElements;
            found                       =   format gotElements;
          in
            [ "Elementar\\-analyse berechnet für \\ch{${formatMolecularFormula formula'}}: ${calculated}; gefunden: ${found}." ]
        else
          [ ];
in
{
  inherit normaliseMolecularFormula formatMolecularFormula calculateMassOfFormula;
  inherit mapAnalysis;
  inherit fullTable tableOfMasses;
}
