{
  kerberos
  =   Peer "Kerberos-Server"
      {
        configuration.krb5
        =   {
              domain_realm
              =   {
                    ".tu-chemnitz.de"   =   "TU-CHEMNITZ.DE";
                  };
              enable                    =   true;
              libdefaults
              =   {
                    default_ccache_name =   "KEYRING:persistent:%{uid}";
                    default_realm       =   "TU-CHEMNITZ.DE";

                    dns_lookup_kdc      =   true;
                    dns_lookup_realm    =   false;
                    forwardable         =   true;
                    rdns                =   false;
                    renew_lifetime      =   "30d";
                    ticket_lifetime     =   "30d";
                  };
              realms."TU-CHEMNITZ.DE"
              =   {
                    admin_server        =   "kerberos-adm.tu-chemnitz.de";
                    kdc                 =   "kerberos.tu-chemnitz.de";
                  };
            };
      };
}
