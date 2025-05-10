{
  description = "Licences";
  inputs = {
    nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config2";
  };
  outputs =
    { nixpkgs, ... }:
    {
      licences = nixpkgs.lib.licenses;
    };
}
