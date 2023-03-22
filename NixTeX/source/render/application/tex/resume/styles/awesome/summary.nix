{ core, helpers, ... }:
{ ... }:
  let
    inherit(core) list;
    inherit(helpers) formatParagraph;
  in
    { body, show ? true, title }:
      list.ifOrEmpty' show (formatParagraph title body)
