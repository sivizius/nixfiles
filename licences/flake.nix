{
  description = "Licences";
  inputs = {
    nixpkgs.url = "github:sivizius/nixpkgs/extend-fido2luks-config";
  };
  outputs = { nixpkgs, ... }:
    {
      licences = nixpkgs.lib.licenses;
    };
}
