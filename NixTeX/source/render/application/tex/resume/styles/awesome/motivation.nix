{ core, toTex, ... }:
{ ... }:
  let
    inherit(core) indentation;
  in
    body:
    [
      "{%" indentation.more
      "\\def\\section#1{(((#1)))}%"
      "\\def\\subsection#1{((#1))}%"
    ]
    #++  (toTex body)
    ++  [
          indentation.less "}%"
        ]
