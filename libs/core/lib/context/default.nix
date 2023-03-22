{ debug, integer, list, path, string, type, ... }:
  let
    Item
    =   (
          type.enum "Item"
          {
            Attribute                   =   string;
            Index                       =   integer;
            File                        =   string;
            Root                        =   string;
          }
        )
    //  {
          format
          =   self:
                Item.match self
                {
                  Attribute             =   { value, ... }: ".${string.escapeKey value}";
                  File                  =   { value, ... }: "@(${value})";
                  Index                 =   { value, ... }: "[${integer.toString value}]";
                  Root                  =   { value, ... }: "<${value}>";
                };
          format'
          =   self:
                Item.match self
                {
                  Attribute             =   { value, ... }: ".${string.escapeKey value}";
                  File                  =   { value, ... }: "";
                  Index                 =   { value, ... }: "[${integer.toString value}]";
                  Root                  =   { value, ... }: "<${value}>";
                };
        };

    Context
    =   type "Context"
        {
          inherit from;
          __public__                    =   [ ];
        };

    getFileName
    =   fileName:
          let
            ext
            =   string.slice
                  ((string.length fileName') - extLength)
                  extLength
                  fileName';
            extLength                   =   4;
            fileName'                   =   string.toString fileName;
          in
            if ext == ".nix"  then  fileName'
            else                    "${fileName'}/default.nix";

    extend
    =   let
          addAttribute
          =   { absolute, relative, ... } @ self:
              attribute:
                self
                //  {
                      absolute          =   absolute ++ [ (Item.Attribute attribute) ];
                      relative          =   relative ++ [ (Item.Attribute attribute) ];
                    };

          addFile
          =   { absolute, relative, ... } @ self:
              fileName:
                let
                  fileName'             =   getFileName fileName;
                in
                  self
                  //  {
                        absolute        =   absolute ++ [ (Item.File fileName') ];
                        fileName        =   fileName';
                        relative        =   [ (Item.File fileName') ];
                      };

          addIndex
          =   { absolute, relative, ... } @ self:
              index:
                self
                //  {
                      absolute          =   absolute ++ [ (Item.Index index) ];
                      relative          =   relative ++ [ (Item.Index index) ];
                    };

          extendWith
          =   { ... } @ self:
              {
                attribute ? null,
                fileName  ? null,
                index     ? null,
              }:
                let
                  self'
                  =   if attribute != null
                      then
                        addAttribute self attribute
                      else
                        self;
                  self''
                  =   if index != null
                      then
                        addIndex self' index
                      else
                        self';
                in
                  if fileName != null
                  then
                    addFile self'' fileName
                  else
                    self'';
        in
          { ... } @ self:
          source:
            if Context.isInstanceOf source
            then
              source
            else
              type.matchPrimitiveOrPanic source
              {
                int                     =   addIndex          self source;
                list                    =   list.fold extend  self source;
                path                    =   addFile           self source;
                set                     =   extendWith        self source;
                string                  =   addAttribute      self source;
              };

    format                              =   string.concatMapped Item.format;
    format'                             =   string.concatMapped Item.format';
    formatAbsolute                      =   { absolute, ... }:  format          absolute;
    formatAbsolute'                     =   { absolute, ... }:  format'         absolute;
    formatFileName                      =   { fileName, ... }:  string.toString fileName;
    formatRelative                      =   { relative, ... }:  format          relative;
    formatRelative'                     =   { relative, ... }:  "$${format'     relative}";

    from
    =   root:
          Context.instanciate
          {
            absolute                    =   [ (Item.Root (toRoot root)) ];
            fileName
            =   if path.isInstanceOf root
                then
                  root
                else
                  "$";
            relative                    =   [ (Item.Root (toRoot root)) ];
            __functor                   =   extend;
            __toString                  =   formatAbsolute;
          };

    toRoot
    =   root:
          type.matchPrimitiveOrPanic root
          {
            path                        =   getFileName root;
            string                      =   root;
          };
  in
    Context
    //  {
          inherit formatAbsolute formatAbsolute' formatFileName formatRelative formatRelative';
        }
