{ core, ... } @ libs:
let
  inherit(core) debug library list set type;

  uid
  =   {
        __functor
        =   self:
            counter:
              {
                inherit counter;
                keys                    =   { };
                values                  =   [ ];
                inserted                =   null;
              };

        insert
        =   { ... } @ self:
            value:
              let
                self'                   =   tryInsert self value;
              in
                if !self'.inserted
                then
                  debug.panic [ "uid" "insert" ] "Cannot insert value to unique, because it is already there!"
                else
                  self';

        length#:
        =   { values, ... }:
              list.length values;

        tryInsert
        =   { counter, keys, values, ... } @ self:
            value:
              let
                key                     =   string value;
              in
                if keys.${key} or null == null
                then
                  {
                    counter             =   counter + 1;
                    keys                =   keys // { ${key} = value; };
                    values              =   values ++ [ value ];
                    inserted            =   true;
                  }
                else
                  self
                  //  {
                        inserted        =   false;
                      };
      };

  preparePerson
  =   identifier:
      value:
        value
        //  {
              __functor
              =   self:
                  { surname, ... }:
                    "##${surname}##";
            };

  preparePeople
  =   people:
        type.matchPrimitiveOrPanic people
        {
          lambda
          =   preparePeople
              (
                people
                (
                  libs
                  //  {
                        Person
                        =   name:
                            {
                              inherit name;
                            };
                      }
                )
              );
          path                          =   preparePeople ( library.import people );
          set                           =   set.map preparePerson people;
        };
in
{
  initEvaluationState                   =   uid 0;
}