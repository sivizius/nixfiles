{ core, ... }:
  let
    inherit(core) bool float integer string type;

    Property
    =   type "Property"
        {
          from
          =   name:
              parameters:
                Property.instanciate
                {
                  inherit name;
                  parameters
                  =   {
                        altid           =   false;
                        any             =   false;
                        calscale        =   false;
                        geo             =   false;
                        language        =   false;
                        mediatype       =   false;
                        pid             =   false;
                        pref            =   false;
                        sort-as         =   false;
                        type            =   false;
                        tz              =   false;
                      }
                  //  parameters;
                };
        };
  in
  {
    Address         =   Property  "ADR"         { } { params = with parameters; [ geo tz label               language         pid pref altid           any ]; value = types.address;          };
    AnniversaryDay  =   Property  "ANNIVERSARY" { } { params = with parameters; [              calscale                                altid           any ]; value = types.date-and-or-time; };
    BirthDay        =   Property  "BDAY"        { } { params = with parameters; [              calscale                                altid           any ]; value = types.date-and-or-time; };
    Categories      =   Property  "CATEGORIES"  { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.text-list;        };
    Chat            =   Property  "IMPP"        { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.url;              };
    Email           =   Property  "EMAIL"       { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.text;             };
    FullName        =   Property  "FN"          { } { params = with parameters; [                       type language         pid pref altid           any ]; value = types.text;             };
    Gender          =   Property  "GENDER"      { } { params = with parameters; [                                                                      any ]; value = types.gender;           };
    Geo             =   Property  "GEO"         { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.uri;              };
    Key             =   Property  "KEY"         { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.uri;              };
    Kind            =   Property  "KIND"        { } { params = with parameters; [                                                                      any ]; value = types.kind;             };
    Language        =   Property  "LANG"        { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.language;         };
    Logo            =   Property  "LOGO"        { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.uri;              };
    Member          =   Property  "MEMBER"      { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.uri;              };
    Name            =   Property  "N"           { } { params = with parameters; [                            language sort-as          altid           any ]; value = types.name;             };
    NickName        =   Property  "NICKNAME"    { } { params = with parameters; [                       type language         pid pref altid           any ]; value = types.text-list;        };
    Note            =   Property  "NOTE"        { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.text;             };
    Photo           =   Property  "PHOTO"       { } { params = with parameters; [                       type                  pid pref altid mediatype any ]; value = types.uri;              };
    Organisation    =   Property  "ORG"         { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.organisation;     };
    Related         =   Property  "RELATED"     { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.related;          };
    Revision        =   Property  "REV"         { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.timestamp;        };
    Role            =   Property  "ROLE"        { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.text;             };
    Sound           =   Property  "SOUND"       { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.sound;            };
    Source          =   Property  "SOURCE"      { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.uri;              };
    Telephone       =   Property  "TEL"         { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.uri;              };
    TimeZone        =   Property  "TZ"          { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.text;             };
    Title           =   Property  "TITLE"       { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.text;             };
    UID             =   Property  "UID"         { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.text;             };
    URL             =   Property  "URL"         { } { params = with parameters; [                                             pid pref altid mediatype any ]; value = types.uri;              };
    XML             =   Property  "XML"         { } { params = with parameters; [                                                      altid               ]; value = types.text;             };
  }
