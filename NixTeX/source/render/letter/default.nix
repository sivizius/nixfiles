{ core, document, ... }:
{ configuration, style, ... }:
  let
    inherit(core) indentation list string type;

    toTex
    =   document.toTex
        {
          inherit configuration mod;
          resources                     =   {};
        };

    parseAddress
    =   address:
          type.matchPrimitiveOrPanic address
          {
            list
            =   {
                  name                  =   list.head address;
                  body                  =   list.tail address;
                };
            set
            =   {
                  name
                  =   address.name
                  or  "${address.forname} ${address.surname}";
                  body
                  =   address.body
                  or  [];
                };
          };

    compileAddress
    =   kind:
        address:
        [
          "\\setkomavar{${kind}name}{${string.trim address.name}}"
          "\\setkomavar{${kind}address}{${string.concatMappedWith string.trim "\\\\" address.body}}"
        ];

    compileLocation
    =   fields:
          if fields != null
          then
            [ "\\begin{tabular}{ll}" indentation.more ]
            ++  (
                  list.map
                  (
                    line:
                      let
                        line'
                        =   type.matchPrimitiveOrPanic line
                            {
                              null      =   "";
                              set       =   "${line.name}: & ${line.value}";
                              string    =   "\\multicolumn{2}{l}{${line}}";
                            };
                      in
                        "${line'}\\\\"
                  )
                  fields
                )
            ++ [ indentation.less "\\end{tabular}" ]
          else
            [ ];

    options
    =   let
          getOptions
          =   let
                option
                =   option:
                    line:
                      if option != null
                      then
                        [ line ]
                      else
                        [];
              in
                {
                  appendix  ? null,
                  copies    ? null,
                  subject   ? null,
                  ...
                }:
                {
                  appendix              =   option appendix "\\encl{${appendix}}";
                  copies                =   option copies   "\\cc{${trim copies}}";
                  subject               =   option subject  "\\setkomavar{subject}{${trim subject}}";
                };
        in
          getOptions document;
  in
  {
    paths
    =   [
          { src = ../tex;    dst = "tex";     }
        ];
    text
    =   indentation { initial = ""; tab = "  "; }
        (
          [
            "\\documentclass[" indentation.more
            indentation.less "]{scrlttr2}"
            "\\setkomavar{location}{%" indentation.more
          ]
          ++  ( compileLocation document.location or null )
          ++  [ indentation.less "}" ]
          ++  ( compileAddress "back"   ( parseAddress document.return or document.sender ))
          ++  ( compileAddress "from"   ( parseAddress document.sender                    ))
          ++  ( compileAddress "to"     ( parseAddress document.recipient                 ))
          ++  options.subject
          ++  [
                "\\begin{document}" indentation.more
                "\\begin{letter}{}" indentation.more
              ]
          ++  options.appendix
          ++  options.copies
          ++  [
                "\\opening{${document.opening}}"
                "{" indentation.more
              ]
          ++  ( toTex document.body )
          ++  [
                indentation.less "}"
                "\\closing{${document.closing}}"
                indentation.less "\\end{letter}"
                indentation.less "\\end{document}"
              ]
        );
  }
