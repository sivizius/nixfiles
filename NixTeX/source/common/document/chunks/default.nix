{ core, evaluator, ... } @ libs:
  let
    inherit(core)   debug library list set string type;

    Chunk
    =   type "Chunk"
        {
          from
          =   name:
              { render, evaluate }:
              fields:
                Chunk.instanciateAs name
                (
                  fields
                  //  {
                        inherit render evaluate;
                      }
                );
        };

    # [ T ] -> string -> [ T ]
    addToLastItem
    =   items:
        text:
          let
            len-1                       =   ( list.length items ) - 1;
            last                        =   list.foot items;
          in
            if list.isInstanceOf items
            && items != []
            then
              if string.isInstanceOf last
              then
                ( list.generate (n: list.get items n) len-1 ) ++ [ "${last}${text}" ]
              else if set.isInstanceOf last && last ? body
              then
                ( list.generate (n: list.get items n) len-1 ) ++ [ ( last // { body = addToLastItem last.body text; } ) ]
              else
                items
            else
              items;

    # Import Chunk-Constructors
    chunks
    =   let
          libs'
          =   libs
          //  {
                chunks                  =   { inherit Chunk addToLastItem; };
              };
        in
          list.fold
            (
              { ... } @ chunks:
              file:
                chunks // ( library.import file libs' )
            )
            {}
            [
              ./claim.nix
              ./dedication.nix
              ./figure.nix
              ./heading.nix
              ./latex.nix
              ./list.nix
              ./multilingual.nix
              ./page.nix
              ./paragraph.nix
              ./phantomHeading.nix
              ./scheme.nix
              ./section.nix
              ./slide.nix
              ./table.nix
              ./todo.nix
            ];
  in
  {
    inherit Chunk chunks addToLastItem;
  }