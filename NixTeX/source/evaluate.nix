{ bibliography, chemistry, core, document, ... }:
  let
    inherit(core)       context expression list path set string;
    inherit(chemistry)  substances;
    inherit(document)   evaluate;
  in
    evaluationOrder:
    { configuration, content, dependencies, name, resources, state ? {}, titleNotes ? null, ... } @ document:
      let
        initialState
        =   {
              bibliography              =   bibliography.initEvaluationState;
              dependencies              =   [];
              figures
              =   {
                    counter             =   1;
                  };
              notes
              =   let
                    notes
                    =   {
                          enableMarkdown=   true;
                          fontSize      =   20;
                          version       =   1;
                        }
                    //  (configuration.notes or {});
                  in
                  {
                    inherit(notes) enableMarkdown fontSize version;
                    label               =   if titleNotes != null then 1 else 0;
                    pages
                    =   list.ifOrEmpty'
                          (titleNotes != null)
                          [
                            {
                              title     =   "Title Page";
                              level     =   0;
                            }
                            {
                              label     =   "1";
                              overlay   =   0;
                              note      =   titleNotes;
                            }
                          ];
                  };
              schemes
              =   {
                    counter             =   1;
                  };
              source                    =   context name;
              substances                =   substances.evaluate configuration.concise;
              tables
              =   {
                    counter             =   if configuration.concise then 0 else 1; # ToDo !!!
                  };
              todos                     =   [];
            }
        //  state;

        evaluatedState
        =   list.fold
            (
              state:
              part:
                if set.hasAttribute part content
                then
                  evaluate
                    { inherit configuration resources; }
                    (state // { context = [ ]; })
                    content.${part}
                else
                  state
            )
            initialState
            evaluationOrder;

        notes
        =   let
              inherit(evaluatedState) notes;
            in
            {
              dst                       =   "${name}.md";
              src
              =   path.toFile "${name}.md"
                  (
                    string.concatMappedLines
                      (
                        { level ? 0, note ? [], title ? null, ... }:
                          if title != null
                          then
                            let
                              title'
                              =   if list.isInstanceOf title
                                  then
                                    string.concatWords title
                                  else
                                    string title;
                            in
                              if level == 0
                              then
                                "# ${title'}"
                              else
                                "## ${title'}"
                          else
                            note
                      )
                      notes.pages
                  );
            };

        pdfpc
        =   let
              inherit(evaluatedState) notes;
            in
            {
              dst                       =   "${name}.pdfpc";
              src
              =   path.toFile "${name}.pdfpc"
                  (
                    expression.toJSON
                    {
                      pdfpcFormat       =   notes.version;
                      disableMarkdown   =   !notes.enableMarkdown;
                      noteFontSize      =   notes.fontSize;
                      pages
                      =   list.imap
                            (idx: page: page // { inherit idx; })
                            (
                              list.filter
                                ({ title ? null, ... }: title == null)
                                notes.pages
                            );
                    }
                  );
            };
      in
        document
        //  {
              dependencies
              =   dependencies
              ++  evaluatedState.dependencies
              ++  (list.ifOrEmpty' (evaluatedState.notes.label != 0) [ pdfpc notes ])
              ++  [
                    {
                      dst               =   "todos";
                      src
                      =   path.toFile "todos"
                          (
                            string.concatMappedLines
                              ({ context, task }: "${string.concatWith " → " context}: ${task}")
                              evaluatedState.todos
                          );
                    }
                  ];
              resources
              =   resources
              //  {
                    substances
                    =   substances.finalise
                          resources.substances
                          evaluatedState.substances;
                  };
              state                     =   evaluatedState;
            }
