{ ... }:
  let
    openingFromName
    =   { given ? null, honorific ? null, family, title ? null, ... }:
        language:
          let
            honorific'
            =   if honorific != null
                then
                  "${honorific} "
                else
                  "";
            geehrter
            =   {
                  "Frau "               =   "geehrte";
                  "Herr "               =   "geehrter";
                }.${honorific'} or "geehrte*r";
            name
            =   if given != null
                then
                  "${given} ${family}"
                else
                  family;
            title'
            =   if title != null
                then
                  "${title}~"
                else
                  "";
          in
            {
              "deu" = "Sehr ${geehrter} ${honorific'}${title'}${name}";
              "eng" = "Dear ${honorific'}${title'}${name}";
            }.${language};

  in
  {
    inherit openingFromName;
    openingFromRecipient                =   { name, ... }: openingFromName name;
  }