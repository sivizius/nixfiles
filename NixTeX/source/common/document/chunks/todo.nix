{ chunks, core, evaluator, renderer, ... }:
  let
    inherit(core)       debug list type;
    inherit(evaluator)  evaluate;
    inherit(renderer)   render;

    evaluateToDo
    =   { ... } @ document:
        { context, todos, ... } @ state:
        { body, tasks, ... }:
          let
            state'
            =   (evaluate document state body)
            //  {
                  todos
                  =   todos
                  ++  (
                        list.map
                          (task: { inherit context task; })
                          tasks
                      );
                };
          in
            if tasks != []
            then
              debug.warn
                context
                { text = "Todo"; data = tasks; }
                state'
            else
              state';

    renderToDo
    =   { ... } @ document:
        { body, ... }:
        output:
          render document body;
  in
  {
    ToDo
    =   tasks:
        body:
          chunks.Chunk "ToDo"
          {
            render                      =   renderToDo;
            evaluate                    =   evaluateToDo;
          }
          {
            inherit body;
            tasks                       =   list.expect tasks;
          };
  }