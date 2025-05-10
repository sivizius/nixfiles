{ ... }:
  let
    articles
    =   import ./articles
          {
            Article
            =   title:
                {
                  authors,
                  dateTime,
                  ...
                }:
                body:
                {
                  __type__              =   "Article";
                  inherit authors body dateTime title;
                };
          }
          { inherit authors; };

    authors
    =   import ./authors
        {
          Author
          =   name:
              {
                ...
              }:
              {
                __type__                =   "Author";
                inherit name;
              };
        };
  in
  {
    inherit articles authors;
  }