# TODO: Remove LaTeX-Code, replace with renderer-methods
{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug indentation list string type;
    inherit(evaluator)  evaluate;
    inherit(renderer)   toCaption toDescription putCaption;

    evaluateTable
    =   { ... } @ document:
        { ... } @ state:
        { dependencies, ... } @ table:
          let
            state'                      =   state;
          in
            state'
            //  {
                  dependencies          =   state'.dependencies ++ dependencies;
                  tables
                  =   state'.tables
                  //  {
                        counter         =   state'.tables.counter + 1;
                      };
                };

    # { ... } -> Document::Chunk::Table -> [ string | Indentation ]
    renderTable
    =   _:
        { header, body, label, fontsize, ... } @ table:
        output:
          if output == "LaTeX"
          then
            let
              header'
              =   list.fold
                  (
                    state:
                    entry:
                      type.matchPrimitiveOrPanic entry
                      {
                        string
                        =   {
                              line      =   state.line ++ [ entry ];
                              config    =   "${state.config}l";
                              bar       =   false;
                            };
                        set
                        =   let
                              bar       =   entry.bar or false;
                              bar'      =   if bar then "|" else "";
                            in
                              if entry.config == "."
                              then
                              {
                                line    =   state.line ++ [ "\\${if bar then "T" else "t"}head{${entry.title}}" ];
                                config  =   "${state.config}.${bar'}";
                                inherit bar;
                              }
                              else
                              {
                                line    =   state.line ++ [ entry.title ];
                                config  =   "${state.config}${entry.config}${bar'}";
                                inherit bar;
                              };
                      }
                  )
                  {
                    line                =   [ ];
                    config              =   "";
                    bar                 =   false;
                  }
                  header;
            in
              [
                "\\begin{table}[H]%" indentation.more
                "\\centering{%" indentation.more
              ]
              ++  ( putCaption table )
              ++  (
                    if label != null
                    then
                      [ "\\labelTable{${label}}%" ]
                    else
                      [ ]
                  )
              ++  (
                    if fontsize != null
                    then
                      [ fontsize ]
                    else
                      [ ]
                  )
              ++  [
                    "\\begin{tabular}{${header'.config}}" indentation.more
                    "\\toprule%"
                    "${string.concatWith " & " header'.line} \\\\"
                    "\\midrule%"
                  ]
              ++  (
                    list.map
                    (
                      # list | string -> string
                      line:
                        type.matchPrimitiveOrPanic line
                        {
                          null          =   "\\midrule";
                          list          =   "${string.concatWith " & " line} \\\\";
                          string        =   line;
                        }
                    )
                    body
                  )
              ++  [
                    "\\bottomrule%"
                    indentation.less "\\end{tabular}"
                    indentation.less "}%"
                    indentation.less "\\end{table}"
                  ]
          else if output == "Markdown"
          then
            []
          else
            debug.panic "render" "Unknown output ${output}";
  in
  {
    # set | string -> list -> list -> Document::Chunk::Table
    Table
    =   config:
        header:
        body:
          chunks.Chunk "Table"
          {
            render                      =   renderTable;
            evaluate                    =   evaluateTable;
          }
          (
            type.matchPrimitiveOrPanic config
            {
              string
              =   {
                    caption             =   toCaption     config;
                    description         =   toDescription config;
                    cite                =   null;
                    label               =   null;
                    fontsize            =   null;
                    dependencies        =   [];
                  };
              set
              =   {
                    caption             =   toCaption     ( config.caption     or config.description or "" );
                    description         =   toDescription ( config.description or config.caption     or "" );
                    cite                =   config.cite         or null;
                    label               =   config.label        or null;
                    fontsize            =   config.fontsize     or null;
                    dependencies        =   config.dependencies or [];
                  };
            }
            //  {
                  header                =   list.expect header;
                  body                  =   list.expect body;
                }
          );
  }
