{ core, ... }:
  let
    inherit(core) debug indentation list path set string type;

    flat
    =   body:
          type.matchPrimitiveOrPanic body
          {
            list                        =   list.concatMap flat body;
            null                        =   [];
            set
            =   if  Tag.isInstanceOf body
                then
                  Tag.flat body
                else
                  [ body ];
            string                      =   [ body ];
          };

    formatHead
    =   {
          _blank                  ? null,
          _parent                 ? null,
          _self                   ? null,
          _top                    ? null,
          application-name        ? null,
          author                  ? null,
          charset                 ? "UTF-8",
          content-security-policy ? null,
          content-type            ? null,
          default-style           ? null,
          description             ? null,
          generator               ? null,
          icon                    ? null,
          keywords                ? null,
          refresh                 ? null,
          script                  ? null,
          scripts                 ? [],
          style                   ? null,
          stylesheets             ? {},
          title                   ? null,
          viewport                ? null,
        }:
          let
            inherit(list) ifOrEmpty;
            link
            =   rel:
                  set.mapToList
                  (
                    href:
                    { ... } @ attrs:
                      tags.link (attrs // { inherit href rel; })
                  );
          in
            flat
            ([]
            ++  (ifOrEmpty  (_blank                   !=  null) (tags.base    { target      = "_blank";                   href = _blank;                      } ))
            ++  (ifOrEmpty  (_parent                  !=  null) (tags.base    { target      = "_parent";                  href = _parent;                     } ))
            ++  (ifOrEmpty  (_self                    !=  null) (tags.base    { target      = "_self";                    href = _self;                       } ))
            ++  (ifOrEmpty  (_top                     !=  null) (tags.base    { target      = "_top";                     href = _top;                        } ))
            ++  (ifOrEmpty  (icon                     !=  null) (tags.link    ( icon // { rel = "icon"; }                                                     ) ))
            ++  (link "stylesheet" stylesheets)
            ++  (ifOrEmpty  (charset                  !=  null) (tags.meta    { inherit charset;                                                              } ))
            ++  (ifOrEmpty  (application-name         !=  null) (tags.meta    { name        = "application-name";         content = application-name;         } ))
            ++  (ifOrEmpty  (author                   !=  null) (tags.meta    { name        = "author";                   content = author;                   } ))
            ++  (ifOrEmpty  (content-security-policy  !=  null) (tags.meta    { http-equiv  = "content-security-policy";  content = content-security-policy;  } ))
            ++  (ifOrEmpty  (content-type             !=  null) (tags.meta    { http-equiv  = "content-type";             content = content-type;             } ))
            ++  (ifOrEmpty  (default-style            !=  null) (tags.meta    { http-equiv  = "default-style";            content = default-style;            } ))
            ++  (ifOrEmpty  (description              !=  null) (tags.meta    { name        = "description";              content = description;              } ))
            ++  (ifOrEmpty  (generator                !=  null) (tags.meta    { name        = "generator";                content = generator;                } ))
            ++  (ifOrEmpty  (keywords                 !=  null) (tags.meta    { name        = "keywords";                 content = keywords;                 } ))
            ++  (ifOrEmpty  (refresh                  !=  null) (tags.meta    { http-equiv  = "refresh";                  content = refresh;                  } ))
            ++  (ifOrEmpty  (viewport                 !=  null) (tags.meta    { name        = "viewport";                 content = viewport;                 } ))
            ++  (list.map (src: tags.script { inherit src; } null) scripts)
            ++  (ifOrEmpty  (script                   !=  null) (tags.script  script                                                                            ))
            ++  (ifOrEmpty  (style                    !=  null) (tags.style   style                                                                             ))
            ++  (ifOrEmpty  (title                    !=  null) (tags.title   title                                                                             ))
            );

    formatHead'
    =   head:
          type.matchPrimitiveOrPanic head
          {
            list                        =   flat head;
            set                         =   formatHead head;
          };

    tags
    =   set.map
          (
            name:
            { ... } @ data:
              data // (Tag name)
          )
          (path.import ./tags.nix);

    Comment
    =   body:
          if list.isInstanceOf body
          then
            [ "<!--" indentation.more ]
            ++  (flat body)
            ++  [ indentation.less "-->" ]
          else
            [ "<!-- ${body} -->" ];

    HTML
    =   type "HTML"
        {
          from
          =   { language ? null, ... }:
                HTML.instanciate
                {
                  inherit language;
                  lines                 =   [ "<!DOCTYPE html>" ];

                  __functor
                  =   { language, lines, ... } @ self:
                      { head ? {}, body ? [] }:
                        self
                        //  {
                              __functor =   null;
                              lines
                              =   lines
                              ++  (
                                    flat
                                    (
                                      tags.html
                                        (
                                          if language != null
                                          then
                                            { lang = language; }
                                          else
                                            {}
                                        )
                                        [
                                          (tags.head (formatHead head))
                                          (tags.body (flat body))
                                        ]
                                    )
                                  );
                            };

                  __toString
                  =   { lines, ... }:
                        indentation {} lines;
                };
        };

    Tag
    =   let
          mapAttributes
          =   string.concatMapped'
              (
                name:
                value:
                  if value != null
                  then
                    " ${name}=\"${string value}\""
                  else
                    " ${name}"
              );
        in
          type "Tag"
          {
            flat
            =   { attributes, body, name, ... } @ tag:
                  if list.isInstanceOf body
                  then
                    [ "<${name}${mapAttributes attributes}>" indentation.more ]
                    ++  (flat body)
                    ++  [ indentation.less "</${name}>" ]
                  else
                    [ "${tag}" ];

            from
            =   name:
                  Tag.instanciate
                  {
                    inherit name;
                    attributes          =   {};
                    body                =   null;
                    expectBody          =   false;

                    __functor
                    =   { attributes, body, expectBody, name, ... } @ self:
                        attrsOrBody:
                          let
                            isAttributes
                            =   !expectBody
                            &&  set.isInstanceOf attrsOrBody
                            &&  attrsOrBody.__type__ or null == null;
                          in
                            self
                            //  (
                                  if      isAttributes              then  { attributes = attrsOrBody; }
                                  else if attrsOrBody == null       then  {}
                                  else if body == null              then  { body = attrsOrBody; }
                                  else if string.isInstanceOf body  then  { body = "${body}${string attrsOrBody}"; }
                                  else
                                    debug.panic [ "Tag" "__functor" ]
                                    {
                                      text  =   "Cannot extend body:";
                                      data  =   body;
                                    }
                                    null
                                )
                            //  { expectBody = true; };

                    __toString
                    =   { attributes, body, name, ... } @ self:
                          type.matchPrimitiveOrPanic body
                          {
                            null        =   "<${name}${mapAttributes attributes} />";
                            list
                            =   indentation {}
                                (
                                  [ "<${name}${mapAttributes attributes}>" indentation.more ]
                                  ++  (flat body)
                                  ++  [ indentation.less "</${name}>" ]
                                );
                            string      =   "<${name}${mapAttributes attributes}>${body}</${name}>";
                          };
                  };
          };
  in
    HTML
    //  { inherit Comment HTML Tag tags; }
    //  ( tags )
