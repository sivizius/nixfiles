{ core, ... }:
  let
    inherit(core)     debug integer list path set string type;
  in
    { configuration, resources, ... }:
    {
      dst                               =   "generated/acronyms.lua";
      src
      =   path.fromSet "acronyms.lua"
          (
            name:
            value:
              let
                escape                  =   text: string.trim ( string.replace [ "\\" "\n" ] [ "\\\\" " " ] text );
                textDeu
                =   if set.isInstanceOf value.text.deu
                    then
                      "{\n              \"${escape value.text.deu.tex or ""}\",\n              \"${escape value.text.deu.pdf or ""}\"\n            }"
                    else
                      "\"${escape value.text.deu}\"";
                textEng
                =   if  value.text ? eng
                    &&  set.isInstanceOf value.text.eng
                    then
                      "{\n              \"${escape value.text.eng.tex or ""}\",\n              \"${escape value.text.eng.pdf or ""}\"\n            }"
                    else
                      "\"${escape value.text.eng or ""}\"";
                sortedBy
                =   if value ? "sortedBy"
                    then
                      if set.isInstanceOf value.sortedBy
                      then
                        "\n      sortedBy\n      =   {\n            deu = \"${escape value.sortedBy.deu or ""}\",\n            eng = \"${escape value.sortedBy.eng or ""},\"\n          },"
                      else if integer.isInstanceOf value.sortedBy
                      then
                        "\n      sortedBy = ${string value.sortedBy},"
                      else
                        "\n      sortedBy = \"${escape value.sortedBy}\","
                    else
                      "";
                bookmarkAs
                =   if value ? "bookmarkAs"
                    then
                      "\n      bookmarkAs = \"${escape value.bookmarkAs}\","
                    else
                      "";
                chemical
                =   if value.data ? "struct"
                    then
                      "\n            \"${escape value.data.struct}\","
                    else
                      "";
                short
                =   if set.isInstanceOf value.data.short
                    then
                      "{\n              deu = \"${escape value.data.short.deu or ""}\",\n              eng = \"${escape value.data.sorshortt.eng or ""},\"\n            }"
                    else
                      "\"${escape value.data.short}\"";
              in
                ''
                  acronyms.list [ "${name}" ]
                  =   {
                        section = sections.${value.section},
                        text
                        =   {
                              deu = ${textDeu},
                              eng = ${textEng},
                            },
                        description
                        =   {
                              deu = "${escape value.description.deu or ""}",
                              eng = "${escape value.description.eng or ""}",
                            },
                        data
                        =   {
                              acronyms.types.${value.data.kind},
                              ${short},${chemical}
                            },${sortedBy}${bookmarkAs}
                      }
                ''
          )
          resources.acronyms or { };
    }
