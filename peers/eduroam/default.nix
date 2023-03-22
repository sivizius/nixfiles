{
  wireless
  =   Peer "Wireless Lan eduroam"
      {
        configuration
        =   { secret, ... }:
            {
              networking.wireless.networks."eduroam".extraConfig
              =   ''
                    ca_cert="${./eduroam.pem}"
                    key_mgmt=WPA-EAP
                    pairwise=CCMP
                    group=CCMP TKIP
                    eap=PEAP
                    identity="@id_eduroam@"
                    domain_suffix_match="radius2030.tu-chemnitz.de"
                    phase2="auth=MSCHAPV2"
                    password="@psk_eduroam@"
                    anonymous_identity="wpasupplicantconfapp_ca2030@tu-chemnitz.de"
                  '';
            };
      };
}
