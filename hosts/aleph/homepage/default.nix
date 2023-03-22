{ core, web, ... } @ libs:
  let
    inherit(core) debug set;
    inherit(web) html;
    www."/"
    =   {
          root
          =   {
                "index.html"
                =   html { language = "eng"; }
                    {
                      head
                      =   {
                            title       =   "Sivi’s Homepage";
                          };
                      body
                      =   with html;
                          [
                            (
                              main
                              [
                                (h1 "Hello World")
                                (p "How are you doing?")
                              ]
                            )
                          ];
                    };
              };
        };
  in
  debug.warn "homepage"
  {
    text                                =   "homepage";
    data                                =   www;
    nice                                =   true;
  }
  {
    websites                            =   { inherit www; "" = www; };
  }
