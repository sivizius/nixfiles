{ lib, ... }:
  let
    inherit(lib) types;
  in
  {
    config                              =   {};
    options.websites
    =   lib.mkOption
        {
          type                          =   types.attrs;
          default                       =   {};
          description
          =   ''
                Set of sets of locations.
                The subdomains are the keys of the outer set,
                  while keys of the inner set are paths to individual locations.
              '';
          example
          =   lib.literalExpression
              ''
                {
                  www."/" = {
                    root = {
                      "index.html" = HTML { language = "en"; } {
                        head = {
                          title = "My Homepage";
                        };
                        body = with HTML; [
                          (h1' "Hello World")
                          (p' "How are you doing?")
                        ];
                      };
                    };
                  };
                }
              '';
        };
  }
