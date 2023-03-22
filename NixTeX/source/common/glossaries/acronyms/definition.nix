{ core, physical, ... } @ libs:
let
  inherit(core)     debug list set string type;
  inherit(physical) formatValueInMath;

  formatUnitDescription
  =   unit:
      {
        about         ? null,
        alternatives  ? [],
        archaic       ? false,
        description   ? null,
        foreign       ? null,
        person        ? null,
        pseudoUnit    ? false,
        siBasic       ? false,
        siDerived     ? false,
        value         ? null,
      }:
      let
        optional
        =   condition:
            text:
              if condition
              then
                [ text ]
              else
                [ ];
        origin
        =   if foreign != null
            then
              let
                text                    =   if foreign.text    or null != null  then " \\Q{${foreign.text}}"          else "";
                latin                   =   if foreign.latin   or null != null  then " (${foreign.latin})"            else "";
                meaning                 =   if foreign.meaning or null != null  then ": \\textit{${foreign.meaning}}" else "";
              in
                [ "von \\acrshort{${foreign.language}}${text}${latin}${meaning}" ]
            else if person != null
            then
              [ "benannt nach ${person.about} \\person{${person.name}}" ]
            else
              [];
        alternatives'
        =   let
              last                      =   list.foot alternatives;
              first                     =   list.body alternatives;
              first'                    =   list.map (item: "\\textit{${item}}") first;
            in
              if first != []
              then
                "auch ${string.concatCSV first'} oder \\textit{${last}}"
              else
                "auch \\textit{${last}}";
        value'
        =   let
              unit'                     =   { value = 1; inherit unit; };
              mapValues
              =   ValueList:
                    "\\mbox{\\ensuremath{${string.concatMappedWith ({ value, unit }: formatValueInMath value unit) " = " ValueList}}}";
            in
              type.matchPrimitiveOrPanic value
              {
                list                    =   mapValues ( [ unit' ] ++ value );
                set                     =   mapValues [ unit' value ];
              };
        parts
        =   (
              if siBasic
              then
                [ "\\acrshort{siStandard}-Basis\\-einheit ${about}" ]
              else if siDerived
              then
                [ "\\acrshort{siStandard}-Einheit ${about}" ]
              else if pseudoUnit
              then
                [ "Pseudo\\-einheit" ]
              else if archaic
              then
                [ "Veraltete Einheit ${about}" ]
              else
                [ "Einheit ${about}" ]
            )
        ++  (optional (alternatives != []) alternatives')
        ++  origin
        ++  (optional (value != null) value')
        ++  (optional (description != null) description);
      in
        string.concatCSV parts;

  Miscellaneous
  =   { description, long, short, sortedBy ? "" }:
      {
        __type__                        =   "Acronym";
        __variant__                     =   "Miscellaneous";
        section                         =   "Miscellaneous";
        inherit long short description sortedBy;
        text                            =   long;
        data
        =   {
              kind                      =   "Default";
              inherit short;
            };
      };

  RawUnit
  =   kind:
      short:
      { title, description, sortedBy ? "" }:
      {
        __type__                        =   "Acronym";
        __variant__                     =   "Unit";
        section                         =   "Units";
        text                            =   title;
        inherit title sortedBy;
        description
        =   { name, ... }:
            {
              deu                       =   formatUnitDescription name description.deu;
            };
        data                            =   { inherit kind short; };
      };

in
{
  Angle                                 =   RawUnit "Angle";
  Unit                                  =   RawUnit "Unit";
  inherit Miscellaneous;
}