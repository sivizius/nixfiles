{ library, ... } @ libs:
{
  Architecture                          =   library.import ./architecture.nix libs;
  Kernel                                =   library.import ./kernel.nix       libs;
  System                                =   library.import ./system.nix       libs;
}
