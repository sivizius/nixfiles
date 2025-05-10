{
  # libconfig is another flake to seperate
  #   the abstract stuff as a library everyone can use
  #   from my configurations which is not really usefull for anyone else.
  libconfig,
  # Profiles are abstract as well: You may have a cloud server a hetzner too.
  profiles,
  # Services as well: You like it? Use it!
  services,
  ...
}:
let
  inherit(libconfig.lib)  Host mapHosts nameElements;

  hosts
  =   (
        scopedImport ./hosts
          { inherit Host; }
          {
            inherit users;
            inherit(profiles) profiles;
            inherit(services) services;
          }
      );
  users
  =   {
        foobar    = foobar.user;
        sivizius  = sivizius.user;
      };
in
{
  nixosConfigurations = mapHosts hosts;
}