{ chunks, core, ... } @ libs:
  let
    inherit(core)   debug error lambda list path set string type;
    inherit(chunks) Chunk;

    # Helpers
    escape                              =   string.char.escape;

    # string -> arguments -> string
    escapeEncode
    =   identifier:
        arguments:
          let
            tabSepList                  =   string.concatWith "\t" ( [ identifier ] ++ arguments );
          in
            "${escape}${tabSepList}${escape}";

    # State -> [ string ] -> State
    evaluateLine
    =   let
          # State -> string -> State
          evaluateToken
          =   { ... } @ state:
              token:
                let
                  # <identifier>(\t<argument>)*
                  token'                =   string.splitTabs token;
                  name                  =   list.head token';
                  arguments             =   list.tail token';
                in
                  if lambda.isInstanceOf state.${list.head token'}
                  then
                    state
                    //  {
                          "${token'}"   =   _: state.${list.head token'} state arguments;
                        }
                  else
                    state
                    //  {
                          "${token'}"   =   state.${list.head token'} arguments;
                        };
        in
          state:
          body:
            list.fold # Lists will be evaulated from left to right!
            (
              state:
              token:
                if list.isInstanceOf token
                then
                  evaluateToken state token
                else
                  state
            )
            state
            ( string.splitAt "${escape}(.*)${escape}" body );


    # State -> { ... } -> lambda | list | path | set | string -> State
    evaluate
    =   { ... } @ document:
        { context, ... } @ state:
        body:
          type.matchPrimitiveOrPanic body
          {
            bool                        =   error.throw "Bool in evaluate?";
            list                        =   list.fold (evaluate document) state body;
            lambda
            =   let
                  libs'                 =   libs // { inherit(state) context; };
                in
                  evaluate document state (body libs document);
            path
            =   let
                  state'                =   state // { context = [ body ]; };
                in
                  evaluate document state' (path.import body);
            set
            =   if body ? __type__
                then
                  ( Chunk.expect body ).evaluate document state body
                else
                  #throw "Not a Chunk"
                  debug.panic "evaluate" { text = "This is not a Chunk!"; data = set.names body; };
            string                      =   state;
          };
  in
  {
    inherit evaluate evaluateLine escapeEncode;
  }