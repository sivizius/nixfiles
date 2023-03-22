Service "Restic: Backups"
{
  configuration
  =   { store, ... }:
      {
        restic.backups
        =   {
              "05-1611-07A"
              =   let
                    listFiles
                    =   store.write.bashScriptFile "listHomeDirectory"
                        ''
                          for f in /home/sivizius/*
                          do
                            echo "$f"
                          done
                        '';
                  in
                  {
                    dynamicFilesFrom    =   "sh ${listFiles}";
                    initialize          =   false;
                    passwordFile        =   "/mnt/secrets/05-1611-07A";
                    pruneOpts
                    =   [
                          "--keep-last=4"
                          "--keep-hourly=4"
                          "--keep-daily=4"
                          "--keep-weekly=4"
                          "--keep-monthly=4"
                          "--keep-yearly=4"
                          "--keep-tag=Save"
                        ];
                    repository          =   "/mnt/05-1611-07A";
                    timerConfig
                    =   {
                          OnCalendar    =   "Fri 23:00";
                          Persistent    =   "true";
                        };
                  };
            };
      };
}
