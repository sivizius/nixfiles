{
  description                           =   "Licences";
  inputs
  =   {
        nixpkgs.url                     =   "github:NixOS/nixpkgs/master";
      };
  outputs
  =   { nixpkgs, ... }:
      {
        licences                        =   nixpkgs.lib.licenses;
      };
}