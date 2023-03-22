Service "Printing"
{
  configuration
  =   { registries, ... }:
      {
        printing
        =   {
              drivers                   =   [ registries.nix.hplip ];
              enable                    =   true;
            };
      };
}
