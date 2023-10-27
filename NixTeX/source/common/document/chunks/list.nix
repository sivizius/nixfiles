# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, ... }:
let
  inherit (core) indentation list type;

  evaluateList = { ... }:
    { bibliography, ... } @ state:
    { items, ... }:
    state;

  renderList = document:
    { items, ... }:
    output:
    [ "\\begin{itemize}" indentation.more ]
    ++ (
      list.map
        (
          item:
          type.matchPrimitiveOrPanic item
            {
              string = "\\item ${item}";
              set =
                let
                  label =
                    if item.label or null != null
                    then
                      "[${item.label}]"
                    else
                      "";
                  slides =
                    if item.slides or null != null
                    then
                      "<${item.slides}>"
                    else
                      "";
                in
                "\\item${slides}${label} ${item.text}";
            }
        )
        items
    )
    ++ [ indentation.less "\\end{itemize}" ];
in
{
  List = config:
    items:
    chunks.Chunk "List"
      {
        render = renderList;
        evaluate = evaluateList;
      }
      (
        config
        // {
          inherit items;
        }
      );
}
