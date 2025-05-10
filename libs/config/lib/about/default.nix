{ core, ... }:
let
  inherit (core) string;

  collect = _: [ ];
  prepare = environment: host: about: {
    about = string.expect about;
    source = host.source "<About of Host ${host.name}>";
  };
in
{
  inherit collect prepare;
}
