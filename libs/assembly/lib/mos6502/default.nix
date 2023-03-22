{ core, helpers, serde, ... }:
  let
    inherit(core) set string type;

    Instruction
    =   let
          __toString
          =   { mnemonic, operants, ... }:
                if operants == []
                then
                  mnemonic
                else
                  "${mnemonic} ${string.concatMappedCSV string operants}";
        in
          type "Instruction"
          {
            from
            =   mnemonic:
                { opcode, operants, ... }:
                  Instruction.instanciateAs mnemonic
                  {
                    inherit mnemonic opcode operants __toString;
                  };
          };

    InstructionBuilder
    =   type "InstructionBuilder"
        {
          from
          =   mnemonic:
              { call, ... } @ data:
                InstructionBuilder.instanciateAs mnemonic
                {
                  inherit data mnemonic;
                  __functor
                  =   { call, data, mnemonic, ... }:
                        call mnemonic data;
                };
        };

    mapGroup1
    =   set.map
        (
          mnemonic:
          opcode:
            InstructionBuilder mnemonic
            {
              inherit opcode;
              call
              =   { opcode, ... }:
                  mnemonic:
                  operant:
                    if operant
                    Instruction mnemonic
                    {
                      opcode
                      =   if operant
                    };
            }
        );

    group1
    =   mapGroup1
        {
          ora                           =   16 * 0;
          and                           =   16 * 1;
          eor                           =   16 * 2;
          adc                           =   16 * 3;
          sta                           =   16 * 4;
          lda                           =   16 * 5;
          cmp                           =   16 * 6;
          sbc                           =   16 * 7;
        };
  in
    group1