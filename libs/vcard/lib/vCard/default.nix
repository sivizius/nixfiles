{ core, ... }:
  let
    inherit(core) bool float integer string type;

    escapeValue
    =   string.replace'
        {
          ";"                           =   "\\;";
          ","                           =   "\\,";
          "\\"                          =   "\\\\";
          "\n"                          =   "\\n";
        };

    parameters
    =   {
          calscale    =   { name = "CALSCALE";  type = types.unknown;               };
          geo         =   { name = "GEO";       type = types.unknown;               };
          label       =   { name = "LABEL";     type = types.unknown;               };
          language    =   { name = "LANGUAGE";  type = types.language;              };
          pid         =   { name = "PID";       type = types.unknown;               };
          preference  =   { name = "PREF";      type = types.integerBetween 0 100;  };
          sortAs      =   { name = "SORT-AS";   type = types.unknown;               };
          type        =   { name = "TYPE";      type = types.unknown;               };
          timeZone    =   { name = "TZ";        type = types.unknown;               };
          value
          =   {
                name                    =   "VALUE";
                type
                =   types.enum
                    [
                      "boolean"
                      "date"
                      "date-and-or-time"
                      "date-time"
                      "float"
                      "integer"
                      "language-tag"
                      "text"
                      "time"
                      "timestamp"
                      "uri"
                      "utc-offset"
                    ];
              };
        };

    properties
    =   {

        };

    types
    =   {
          # Primitive Types
          boolean           =   { name = "boolean";           inherit(bool) format isInstanceOf;    };
          date              =   { name = "date";                                                    };
          date-and-or-time  =   { name = "date-and-or-time";                                        };
          date-time         =   { name = "date-time";                                               };
          float             =   { name = "float";             inherit(float) format isInstanceOf;   };
          integer           =   { name = "integer";           inherit(integer) format isInstanceOf; };
          language          =   { name = "language-tag";                                            };
          text              =   { name = "text";              inherit(string) isInstanceOf;         };
          time              =   { name = "time";                                                    };
          timestamp         =   { name = "timestamp";                                               };
          uri               =   { name = "uri";                                                     };
          utc-offset        =   { name = "utc-offset";                                              };

          # Derived
          address
          =   types.text
          //  {
                isInstanceOf
                =   value:
                      (set.isInstanceOf value)
                      &&  (types.text.isInstanceOf (value.street    or ""))
                      &&  (types.text.isInstanceOf (value.locality  or ""))
                      &&  (types.text.isInstanceOf (value.region    or ""))
                      &&  (types.text.isInstanceOf (value.code      or ""))
                      &&  (types.text.isInstanceOf (value.country   or ""));
                format
                =   string.concatMappedWith types.text.format ";";
              };

          kind
          =   types.text
          //  {
                isInstanceOf
                =   value:
                      (types.text.isInstanceOf value)
                      &&  list.find value [ "group" "individual" "location" "org" ];
              };

          integerBetween
          =   lower:
              upper:
                types.integer
                //  {
                      isInstanceOf
                      =   value:
                            (types.integer.isInstanceOf value)
                            &&  value <= upper
                            &&  value >= lower;
                    };

          gender
          =   types.text
          //  {
                format
                =   { identity ? null, sex ? null }:
                      let
                        identity'       =   string.ifOrEmpty (identity != null) ";${identity}";
                        sex'            =   string.ifOrEmpty (sex != null)      sex;
                      in
                        "${sex'}${identity'}";
                isInstanceOf
                =   value:
                      (set.isInstanceOf value)
                      &&  (list.find (value.sex or null) [ null "F" "M" "N" "O" "U" ])
                      &&  (   value.identity or null == null
                          ||  string.isInstanceOf value.identity
                          );
              };

          name
          =   types.text
          //  {
                format
                =   { additional ? null, family ? null, given ? null, prefixes ? null, suffixes ? null }:
                      string.concatMappedWith types.text.format ";"
                      [
                        (string.ifOrEmpty (family     != null) family)
                        (string.ifOrEmpty (given      != null) given)
                        (string.ifOrEmpty (additional != null) additional)
                        (string.ifOrEmpty (prefixes   != null) additional)
                        (string.ifOrEmpty (suffixes   != null) additional)
                      ];
              };

          organisation
          =   types.text
          //  {
                inherit(types.text-list) isInstanceOf;
                format                  =   string.concatMappedWith types.text.format ";";
              };

          related
          =   types.uri;

          text-list
          =   types.text
          //  {
                isInstanceOf
                =   value:
                      list.isInstanceOf value
                      &&  list.all types.text.isInstanceOf value;
                format                  =   list.concatMappedComma types.text.format;
              };
        };

    vCard
    =   type "vCard"
        {
          from
          =   {
                # GEO PRODID REV SOUND UID CLIENTPIDMAP FBURL CALADRURI CALURI XML
                address         ? null,
                anniversaryDay  ? null,
                birthDay        ? null,
                categories      ? null,
                chat            ? null,
                email           ? null,
                fullName,
                gender          ? null,
                key             ? null,
                kind            ? null,
                language        ? null,
                logo            ? null,
                member          ? null,
                name            ? null,
                nickName        ? null,
                note            ? null,
                photo           ? null,
                organisation    ? null,
                related         ? null,
                revision        ? null,
                role            ? null,
                source          ? null,
                telephone       ? null,
                timeZone        ? null,
                title           ? null,
                uid             ? null,
                url             ? null,
              }:
                vCard.instanciate
                {
                  inherit name;
                  __toString
                  =   {
                        source,
                        ...
                      }:
                        string.concatCRLF
                        [
                          "BEGIN:VCARD"
                          "VERSION:4.0"
                          "END:VCARD"
                          ""
                        ];
                };
        };
  in
    vCard // { inherit vCard; }
