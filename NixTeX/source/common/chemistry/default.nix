{ chemistry, core, ... } @ libs:
let
  inherit(core) library;

  elements                              =   library.import ./elements.nix   libs;
  compound                              =   library.import ./compound.nix   libs;
  groups
  =   let
        inherit (elements.fullTable) C Fe H O P S;
        Ac                              =   [ Me C O 2 ];
        CC                              =   [ C 2 ];
        CH2                             =   [ C H 2 ];
        Et                              =   [ Me CH2 ];
        Fc                              =   [ Fe C 10 H 9 ];
        Fc'                             =   [ Fe C 10 H 8 ];
        Me                              =   [ C H 3 ];
        Ms                              =   [ Me S O 3 ];
        Ph                              =   [ C 6 H 5 ];
        Pyr                             =   [ C 16 H 8 ];
      in
        { inherit Ac CC CH2 Et Fc Fc' Me Ms Ph Pyr; };
  ir                                    =   library.import ./ir.nix         libs;
  journal                               =   library.import ./journal.nix    libs;
  ligands
  =   let
        inherit(elements.fullTable) C O P;
        inherit(groups) Fc' Ph;
      in
      {
        CO                              =   [ C O ];
        dppf                            =   [ Fc' [ P Ph 2 ] 2 ];
      };
  ms                                    =   library.import ./ms.nix         libs;
  nmr                                   =   library.import ./nmr.nix        libs;
  substances                            =   library.import ./substances     libs;
  symbols                               =   elements.fullTable // groups // ligands;
  synthesis                             =   library.import ./synthesis.nix  libs;
  values                                =   library.import ./values.nix     libs;
in
{
  inherit compound elements groups ir journal ligands ms nmr substances synthesis symbols values;
  inherit(substances) Substance Mixture;
}