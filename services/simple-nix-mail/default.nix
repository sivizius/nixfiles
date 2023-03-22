Service "Simple Mail Delivery Agent"
{
  configuration
  =   { network, ... }:
        let
          inherit(network) domain;
        in
        {
          mailserver
          =   {
                certificateScheme       =   3;
                domains                 =   [ domain ];
                enable                  =   true;
                enableImap              =   true;
                enableImapSsl           =   true;
                enableManageSieve       =   true;
                enablePop3              =   true;
                enablePop3Ssl           =   true;
                fqdn                    =   domain;
                localDnsResolver        =   false;
                rejectRecipients        =   [ ];
                rejectSender
                =   [
                      # Fake Mailer
                      "@emkei.cz"
                    ];
                virusScanning           =   false;
              };
        };
  legacy                                =   true;
}
