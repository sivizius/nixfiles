{ web, ... }:
{ ... }:
  let
    inherit(web.css) CSS;
  in
    CSS
    {
      body
      =   {
            background.color            =   "#222";
            color                       =   "#f80";
          };
    }
