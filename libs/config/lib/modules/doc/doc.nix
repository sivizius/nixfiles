let
  # Should be extern
  # {
    inherit (builtins)
      any attrNames concatMap concatStringsSep deepSeq elemAt foldl' genList getFlake head isAttrs
      isList isString length map match removeAttrs replaceStrings split stringLength substring
      trace toString typeOf;

    foot                                =   list: elemAt list (length list - 1);

    apply
    =   transformations:
        value:
          foldl'
          (
            value:
            transformation:
              transformation value
          )
          value
          transformations;

    ltrim
    =   list:
          if head list == ""
          && length list >= 2
          then
            genList (x: elemAt list ( x + 2 )) ( length list - 2 )
          else
            list;

    rtrim
    =   list:
          if foot list == ""
          && length list >= 2
          then
            genList (x: elemAt list x) ( length list - 2 )
          else
            list;

    splitSpaces                         =   split "([[:space:]]+)";

    trim                                =   apply [ splitSpaces ltrim rtrim ];

    collectLines
    =   apply
        [
          (
            foldl'
            (
              { line, lines }:
              token:
                if token != null
                then
                {
                  line                  =   line ++ [ token ];
                  inherit lines;
                }
                else
                {
                  line                  =   [ ];
                  lines
                  =   lines
                  ++  (
                        if line != []
                        then
                          [ (concatStringsSep "" line) ]
                        else
                          [ ]
                      );
                }
            )
            {
              line                      =   [ ];
              lines                     =   [ ];
            }
          )
          (
            { line, lines }:
              if line != []
              then
                lines ++ [ (concatStringsSep "" line) ]
              else
                lines
          )
        ];

    traceDeep                           =   x: y: trace (deepSeq x x) y;
  # }

  getOptions
  =   branch:
      modules:
        removeAttrs
          (
            (getFlake "github:sivizius/nixpkgs/${branch}").lib.nixosSystem { inherit modules; }
          ).options
          [ "_module" ];

  getMeta
  =   value:
        let
          internal                      =   value.internal or false;
        in
        {
          declarations                  =   value.declarations  or  null;
          default
          =   if value ? __toString && toString value == "virtualisation.cri-o.package"
              then
                null
              else
                value.defaultText   or  value.default  or null;
          description                   =   value.description   or  null;
          example                       =   value.example       or  null;
          hasDefault                    =   value ? defaultText || value ? default;
          hasExample                    =   value ? example;
          type                          =   value.type.description;
          visible                       =   value.visible       or  (!internal);
        };

  parseTree
  =   root:
      options:
        foldl'
        (
          result:
          optionName:
            let
              name                      =   if root != null then "${root}.${optionName}" else optionName;
              value                     =   options.${optionName};
              getOptions
              =   foldl'
                  (
                    options:
                    submodules:
                      if isAttrs submodules
                      then
                        let
                          imports       =   getOptions (submodules.imports or [ ] );
                        in
                          options // (submodules.options or { } ) // imports
                      else
                        options
                    )
                    { };

              submodules                =   getOptions value.type.getSubModules or [];
            in
              if isAttrs value
              then
                if value ? _type
                then
                  result
                  //  {
                        ${optionName}
                        =   let
                              meta      =   getMeta value;
                            in
                            {
                              tree
                              =   if meta.type == "submodule"
                                  then
                                    parseTree name submodules
                                  else
                                    null;
                              inherit name meta value;
                            };
                      }
                else
                  result
                  //  {
                        ${optionName}
                        =   {
                              inherit name;
                              meta      =   null;
                              tree      =   parseTree name value;
                            };
                      }
              else
                result
        )
        {}
        ( attrNames options );

  getDocumentation
  =   branches:
      modules:
        foldl'
        (
          result:
          branch:
            result
            //  {
                  ${branch}             =   parseTree null (getOptions branch modules);
                }
        )
        {}
        branches;

  renderDescription
  =   branch:
      description:
        let
          description'
          =   if      isString  description
              then
                renderDocBook branch description
              else if isAttrs   description
              &&      description ? _type
              &&      description ? text
              then
                {
                  "mdDoc"           =   [ (renderMarkDown description.text) ];
                }.${description._type} or (throw "Unknown type ${description._type}")
              else
                [ "—" ];
          length'                       =   length description';
        in
          if length' == 0
          then
            [ "<dd></dd>" ]
          else if length' == 1
          then
            [ "<dd>${head description'}</dd>" ]
          else
            [
              "<dd>"
              description'
              "</dd>"
            ];

  renderDefault                         =   renderExample;

  renderCode                            =   code: "<pre><code class=\"codeblock\">${code}</code></pre>";

  escapeHTML                            =   replaceStrings [ "<" ">" "&" "\"" "'" ] [ "&lt;" "&gt;" "&amp;" "&quot;" "&#39;" ];

  renderDocBook
  =   branch:
        apply
        [
          #(text: traceDeep { _ = "DocBook"; inherit text; } text)
          trim
          (
            text:
              concatStringsSep ""
              (
                map
                (
                  token:
                    if isList token
                    then
                      let
                        token'          =   head token;
                        matchBreak      =   match ".*\n.*\n.*" token';
                      in
                        if matchBreak != null
                        then
                          "\n"
                        else
                          " "
                    else
                      token)
                text
              )
          )
          (split "<(/?[A-Za-z]+)( [^>]+)?/?>")
          (
            concatMap
            (
              token:
                if isList token
                then
                  let
                    token'              =   elemAt token 0;
                    arguments           =   elemAt token 1;
                  in
                  {
                    "citerefentry"      =   [ "<code " ];
                    "/citerefentry"     =   [ "</code>" ];
                    "code"              =   [ "<code class=\"code\">" ];
                    "/code"             =   [ "</code>" ];
                    "command"           =   [ "<code class=\"command\">" ];
                    "/command"          =   [ "</code>" ];
                    "emphasis"          =   [ "<emph>" ];
                    "/emphasis"         =   [ "</emph>" ];
                    "envar"             =   [ "<code class=\"environment\">$" ];
                    "/envar"            =   [ "</code>" ];
                    "filename"          =   [ "<code class=\"filename\">" ];
                    "/filename"         =   [ "</code>" ];
                    "function"          =   [ "<code class=\"function\">" ];
                    "/function"         =   [ "</code>" ];
                    "important"         =   [ "<strong class=\"important\">" ];
                    "/important"        =   [ "</strong>" ];
                    "link"              =   [ "<a ${substring 7 (stringLength arguments - 7) arguments}>" ];
                    "/link"             =   [ "</a>" ];
                    "itemizedlist"      =   [ "<ul>" null ];
                    "/itemizedlist"     =   [ "</ul>" ];
                    "listitem"          =   [ "  <li>" ];
                    "/listitem"         =   [ "</li>" null ];
                    "literal"           =   [ "<code class=\"literal\">" ];
                    "/literal"          =   [ "</code>" ];
                    "literallayout"     =   [ "<code class=\"layout\">" ];
                    "/literallayout"    =   [ "</code>" ];
                    "manvolnum"         =   [ "(" ];
                    "/manvolnum"        =   [ ")" ];
                    "member"            =   [ "  <li>" ];
                    "/member"           =   [ "</li>" null ];
                    "note"              =   [ "<strong class=\"note\">" ];
                    "/note"             =   [ "</strong>" ];
                    "option"            =   [ "<code class=\"option\">" ];
                    "/option"           =   [ "</code>" ];
                    "package"           =   [ "<code class=\"package\">" ];
                    "/package"          =   [ "</code>" ];
                    "para"              =   [ "<p>" ];
                    "/para"             =   [ "</p>" ];
                    "productname"       =   [ "<emph>" ];
                    "/productname"      =   [ "™</emph>" ];
                    "programlisting"    =   [ null "<pre><code>" ];
                    "/programlisting"   =   [ "</code></pre>" null ];
                    "prompt"            =   [ null ];
                    "/prompt"           =   [ ];
                    "quote"             =   [ "<q>" ];
                    "/quote"            =   [ "</q>" ];
                    "refentrytitle"     =   [ " class=\"manpage\">" ];
                    "/refentrytitle"    =   [ ];
                    "replaceable"       =   [ ];
                    "/replaceable"      =   [ ];
                    "screen"            =   [ null "<pre><samp>" ];
                    "/screen"           =   [ "</samp></pre>" null ];
                    "simplelist"        =   [ "<ul>" null ];
                    "/simplelist"       =   [ "</ul>" ];
                    "term"              =   [ "  <dt><code class=\"term\">" ];
                    "/term"             =   [ "</code></dt>" null ];
                    "title"             =   [ "<strong class=\"title\">" ];
                    "/title"            =   [ "</strong>" ];
                    "variablelist"      =   [ "<dl>" null ];
                    "/variablelist"     =   [ "</dl>" ];
                    "varlistentry"      =   [ "  <dd>"];
                    "/varlistentry"     =   [ "</dd>" null ];
                    "varname"           =   [ "<var>" ];
                    "/varname"          =   [ "</var>" ];
                    "warning"           =   [ "<strong class=\"warning\">" ];
                    "/warning"          =   [ "</strong>" ];
                    "xref"              =   [ "<a href=\"#${branch}@${arguments}\"><code class=\"option\">${arguments}</code></a>" ];
                    "/xref"             =   [ "</code></a>" ];
                  }.${token'} or ( throw { inherit token' arguments; } )
                else
                  [ (escapeHTML token) ]
            )
          )
          collectLines
        ];

  renderMarkDown
  =   text:
        #traceDeep { _ = "MarkDown"; inherit text; }
        text;

  renderExpression
  =   branch:
      optionName:
      expression:
        if  isAttrs expression
        &&  expression ? _type
        &&      expression ? text
        then
          let
            splitLines
            =   apply
                [
                  (split "(\n)")
                  ltrim
                  rtrim
                  (foldl' (result: token: if isList token then result else result ++ [token]) [])
                ];
            lines                     =   splitLines expression.text;
            expression'
            =   if length lines == 1
                then
                  head lines
                else
                  concatStringsSep "\n" lines;
          in
            {
              "literalDocBook"          =   concatStringsSep "\n" (renderDocBook branch expression');
              "literalExpression"       =   renderCode      expression';
              "literalMD"               =   renderMarkDown  expression';
            }.${expression._type} or (throw "Unknown type ${expression._type}")
        else
          renderCode (renderExpression' "" optionName expression);

  renderExpression'
  =   indentation:
      optionName:
      expression:
      {
        "bool"                          =   if expression then "true" else "false";
        "float"                         =   toString expression;
        "int"                           =   toString expression;
        "lambda"                        =   "_: …";
        "list"
        =   let
              indentation'              =   "${indentation}  ";
              content                   =   map (renderExpression' indentation' optionName) expression;
              content'                  =   concatStringsSep " " content;
              isLarge                   =   ( length content > 16 ) || any (item: isAttrs item && item != {}) expression;
            in
              if expression == []
              then
                "[]"
              else if isLarge
              then
                "[\n${indentation'}${concatStringsSep "\n${indentation'}" content}\n${indentation}]"
              else
                "[ ${concatStringsSep " " content} ]";
        "null"                          =   "null";
        "path"                          =   toString expression;
        "set"
        =   let
              indentation'              =   "${indentation}  ";
              escapeName
              =   name:
                    let
                      validMatch        =   match "[0-9A-Za-z'_-]+" name;
                    in
                      if validMatch != null
                      then
                        name
                      else
                        "\"${replaceStrings [ "\n" "\r" "\t" "\\" "\"" "\${" ] [ "\\n" "\\r" "\\t" "\\\\" "\\\"" "\\\${" ] name}\"";
              content
              =   map
                  (
                    name:
                      let
                        value           =   renderExpression' indentation' optionName expression.${name};
                      in
                        "${escapeName name} = ${value};"
                  )
                  ( attrNames expression );
              content'                  =   concatStringsSep "\n${indentation'}" content;
            in
              if expression == {}
              then
                "{}"
              else if expression.type or null == "derivation"
              &&      expression ? name
              then
                "«derivation ${expression.name}»"
              else
                "{\n${indentation'}${content'}\n${indentation}}";
        "string"
        =   let
              indentation'              =   "${indentation}  ";
              splitLines
              =   apply
                  [
                    (split "(\n)")
                    ltrim
                    rtrim
                    (foldl' (result: token: if isList token then result else result ++ [token]) [])
                  ];
              lines                     =   splitLines expression;
            in
              if length lines == 1
              then
                "\"${head lines}\""
              else
                "''\n${indentation'}${concatStringsSep "\n${indentation'}" lines}\n${indentation}''";
      }.${typeOf expression};

  renderExample
  =   branch:
      hasExample:
      optionName:
      example:
        if hasExample
        then
          renderExpression branch optionName example
        else
          null;

  renderMeta
  =   branch:
      value:
        if value.meta != null
        then
        [
          "<dl>"
          (
            [
              "<dt>Name</dt>"
              "<dd><code class=\"option\">${value.name}</code></dd>"
            ]
            ++  (
                  if value.meta.description != null
                  then
                    [
                      "<dt>Description</dt>"
                    ]
                    ++  (renderDescription branch value.meta.description)
                  else
                    []
                )
            ++  [
                  "<dt>Type</dt>"
                  "<dd><code class=\"type\">${value.meta.type}</code></dd>"
                ]
            ++  (
                  let
                    default             =   renderDefault branch value.meta.hasDefault value.name value.meta.default;
                  in
                    if default != null
                    then
                    [
                      "<dt>Default</dt>"
                      "<dd>${default}</dd>"
                    ]
                    else
                      []
                )
            ++  (
                  let
                    example             =   renderExample branch value.meta.hasExample value.name value.meta.example;
                  in
                    if example != null
                    then
                    [
                      "<dt>Example</dt>"
                      "<dd>${example}</dd>"
                    ]
                    else
                      []
                )
          )
          "</dl>"
        ]
        else
          [];

  renderDocumentation'
  =   branch:
      documentation:
        map
        (
          option:
            let
              value                     =   documentation.${option};
            in
              [
                "<details open>"
                (
                  [
                    "<summary><span id=\"${branch}@${value.name}\" />${option}</summary>"
                    (renderMeta branch value)
                  ]
                  ++  (
                        if value.tree != null
                        then
                          [ (renderDocumentation' branch value.tree) ]
                        else
                          []
                      )
                )
                "</details>"
              ]
        )
        ( attrNames documentation );

  indent
  =   indentation:
      lines:
        concatMap
        (
          line:
            if isList line
            then
              indent "${indentation}  " line
            else
              [ "${indentation}${line}" ]
        )
        lines;

  renderDocumentation
  =   documentation:
        let
          lines
          =   foldl'
              (
                result:
                branch:
                  result
                  ++  [
                        "<details>"
                        [
                          "<summary><span id=\"${branch}\" />${branch}</summary>"
                          (renderDocumentation' branch documentation.${branch})
                        ]
                        "</details>"
                      ]
              )
              []
              ( attrNames documentation );
        in
          concatStringsSep "\n"
          (
            [
              ""
              "<!DOCTYPE html>"
              "<html>"
              "  <head>"
              "    <title>Options of NixOS-Modules</title>"
              "    <style>"
              "      details > *:not(summary)"
              "      {"
              "        margin-left: 2em;"
              "      }"
              "    </style>"
              "  </head>"
              "  <body>"
            ]
            ++  ( indent "    " lines )
            ++  [
                  "  </body>"
                  "</html>"
                ]
          );

  documentation
  =   getDocumentation
      [
        "master"
        "nixpkgs-unstable"
        "nixos-22.05"
      ] [];
in
  renderDocumentation
  documentation
