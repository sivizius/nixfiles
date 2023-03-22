{ config, core, profile, user, ... }:
{ email, ... }:
  let
    inherit(core) list path set string;
    mailDir                             =   email.maildirBasePath;
    mailAccounts                        =   email.accounts;
  in
  {
    enable                              =   profile.isDesktop;
    binds
    =   [
          { key = ">";          action  = "sidebar-open";           map = [ "index" "pager" ];  }
          { key = "<";          action  = "sidebar-toggle-visible"; map = [ "index" "pager" ];  }
          { key = "<F72>";      action  = "sidebar-next";           map = [ "index" "pager" ];  }
          { key = "<F73>";      action  = "sidebar-prev";           map = [ "index" "pager" ];  }
          { key = "<S-Left>";   action  = "sidebar-prev-new";       map = [ "index" "pager" ];  }
          { key = "<S-Next>";   action  = "sidebar-page-down";      map = [ "index" "pager" ];  }
          { key = "<S-Prev>";   action  = "sidebar-page-up";        map = [ "index" "pager" ];  }
          { key = "<S-Right>";  action  = "sidebar-next-new";       map = [ "index" "pager" ];  }
          { key = "-";          action  = "check-stats";            map = [ "index" "pager" ];  }
        ];
    checkStatsInterval                  =   300;
    extraConfig
    =   ''
          set date_format = "%Y-%m-%d"
          set pipe_decode = yes
          set crypt_replyencrypt
          set crypt_replysign
          set crypt_replysignencrypted
          set delete = ask-yes;
          set reply_with_xorig = yes
          ${path.readFile ./assets/colours.muttrc}
        '';
    macros
    =   [
          {
            key                         =   "+";
            action                      =   "<enter-command>unset wait_key<enter>!mbsync -a &> /dev/null&<enter>:echo 'Sync All Mailboxes'<enter>";
            map                         =   [ "index" "pager" ];
          }
          {
            key                         =   "<F6>";
            action                      =   "| w3m -T text/html<enter>";
            map                         =   [ "pager" ];
          }
        ]
        ++  list.imap
            (
              index:
              accountName:
              {
                key                     =   "<F${string (25 + index)}>";
                action                  =   "<change-folder>${mailDir}/${accountName}/INBOX<enter>";
                map                     =   [ "index" ];
              }
            )
            ( set.names mailAccounts );
    sidebar
    =   {
          enable                          =   true;
          format                          =   "%B%?F? [%F]?%* %?N?%N/?%S";
        };
    sort                                  =   "reverse-date-received";
  }
