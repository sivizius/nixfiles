{ ... }:
{
  services.rsyslogd = {
    enable = true;
    extraConfig = ''
      module(load="imudp")
      input(type="imudp" port="514")
    '';
  };
}
