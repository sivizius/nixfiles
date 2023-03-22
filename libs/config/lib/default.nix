{ core, nixpkgs, secrets, store, vault, web, ... }:
  Library "libconfig"
    { inherit core nixpkgs secrets store vault web; }
    {
      about                             =   ./about;
      configurations                    =   ./configurations;
      devices                           =   ./devices;
      hosts                             =   ./hosts;
      #maintainers                       =   ./maintainers;
      #modules                           =   ./modules;
      networks                          =   ./networks;
      packages                          =   ./packages;
      peers                             =   ./peers;
      profiles                          =   ./profiles;
      services                          =   ./services;
      systems                           =   ./systems;
      users                             =   ./users;
      versions                          =   ./versions;
    }
