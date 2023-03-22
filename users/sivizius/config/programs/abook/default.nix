{ core, profile, ... }:
  let
    inherit(core) debug list string;

    mapFields
    =   set.mapToList
        (
          name:
          { text, type ? null } @ data:
            let
              type'                     =   string.ifOrEmpty type != null ", ${type}";
            in
              debug.panic "mapFields"
              {
                inherit data;
                text                    =   ''type of field `${name}` must be either `null`, `"string"`, `"emails"`, `"list"` or `"date"`'';
                when                    =   !list.find type [ null "string" "emails" "list" "date" ];
              }
              ''field ${name} = "${text}"${type'}''
        );

    mapSettings
    =   list.mapToList
        (
          name:
          value:
            "set ${name} = ${string value}"
        );

    mapViews
    =   set.mapToList
        (
          name:
          fields:
            ''view ${name} = ${list.concatCSV fields}''
        );

    defaultFields
    =   {
          address_lines                 =   { text  = "Address";  type  = "list"; };
          birthday                      =   { text  = "Birthday"; type  = "date"; };
          pager                         =   { text  = "Pager";                    };
        };

    defaultSettings
    =   {
          # TODO: Description
          add_email_prevent_duplicates  =   false;

          # address style [eu|us|uk]
          address_style                 =   "eu";

          # Automatically save database on exit
          autosave                      =   true;

          # Colours
	        color_field_name_bg           =   "default";
	        color_field_name_fg           =   "yellow";
	        color_field_value_bg          =   "default";
	        color_field_value_fg          =   "green";
          color_header_bg               =   "default";
          color_header_fg               =   "red";
	        color_list_even_bg            =   "default";
          color_list_even_fg            =   "yellow";
	        color_list_header_bg          =   "blue";
	        color_list_header_fg          =   "white";
	        color_list_highlight_bg       =   "green";
	        color_list_highlight_fg       =   "black";
	        color_list_odd_bg             =   "default";
	        color_list_odd_fg             =   "default";
	        color_tab_border_bg           =   "default";
	        color_tab_border_fg           =   "cyan";
	        color_tab_label_bg            =   "default";
	        color_tab_label_fg            =   "magenta";

          # Format of an entry's line in the main abook screen
          #
          # The below example displays:
          #  * the content of the 'name' field (with a maximum of 22 characters)
          #  * the first of the 'phone', 'workphone' or 'mobile' fields
          #    happening not to be empty (right aligned within 12 characters)
          #  * the 'anniversary' field, with no length limit
          index_format                  =   " {name:25} {phone:-12|workphone|mobile} {anniversary}";

          # Command used to start mutt
          mutt_command                  =   "mutt";

          # Return all email addresses to a mutt query
          mutt_return_all_emails        =   true;

          # Specify how fields not declared with the 'field' command nor
          # in a view should be preserved while loading an abook database.
          #
          # It must be one of 'all', 'standard' (default), or 'none'.
          #   * 'all': preserve any completely unknown field.
          #   * 'standard': only preserve the standard fields (see a list in the
          #                 description of the 'view' command) and the legacy
          #                 'custom[1-5]' fields.
          #   * 'none': discards any unknown field.
          preserve_fields               =   "standard";

          # Command used to print
          print_command                 =   "lpr";

          # Set scroll-speed
          scroll_speed                  =   2;

          # Show all email addresses in list
          show_all_emails               =   true;

          # show cursor in main display
          show_cursor                   =   false;

          # field to be used with "sort by field" command
          sort_field                    =   "nick";

          # use ASCII characters only
          use_ascii_only                =   false;

          # use colours
          use_colors                    =   true;

          # use mouse
          use_mouse                     =   false;

          # Command used to start the web browser
          www_command                   =   "lynx";
        };

    defaultViews
    =   {
          ADDRESS                       =   [ "address_lines" "city" "state" "zip" "country" ];
          CONTACT                       =   [ "name" "email" ];
          OTHER                         =   [ "url" "birthday" ];
          PHONE                         =   [ "phone" "workphone" "pager" "mobile" "fax" ];
        };

    cfg
    =   {
          fields
          =   {

              };

          settings
          =   {
                autosave                =   true;
                preserve_fields         =   "standard";
                show_all_emails         =   true;
                index_format            =   " {name:25} {phone:-12|workphone|mobile} {anniversary}";
              };

          views
          =   {

              };
        };
  in
  {
    enable                              =   profile.isDesktop;
    extraConfig
    =   list.concatLines
        (
          [ "# Generated by nix-module" ]
          ++  [ "# Settings"  ] ++  ( mapSettings ( defaultSettings // (cfg.settings or {}) ) )
          ++  [ "# Fields"    ] ++  ( mapFields   (cfg.fields or  defaultFields ) )
          ++  [ "# Views"     ] ++  ( mapViews    (cfg.views  or  defaultViews  ) )
        );
  }
