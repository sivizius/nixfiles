{ core, document, ... } @ libs:
let
  inherit(core) debug string type;

  format
  =   compound:
        type.matchPrimitiveOrPanic compound
        {
          string                        =   "\\directlua{chem.compounds.texPrint([[${compound}]])}";
          list                          =   "\\directlua{chem.compounds.texPrint([[${string.concatWith "||" compound}]])}";
        };
  from
  =   compound:
      {
        input                           =   compound;
        __toString                      =   { input, ... }: format input;
      };
in
{
  inherit format from;
  __functor                             =   { ... }: from;
}