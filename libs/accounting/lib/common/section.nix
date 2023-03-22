{ common, core, ... }:
  let
    inherit(common) Account;
    inherit(core)   debug list number path set string time type;

    Section#: { title: string, ... } | string -> [ { uid, name, ... } | Seection ] -> Section
    =   type "Section"
        {
          from
          =   uid:
              title:
              body:
                Section.instanciate
                {
                  inherit title uid;
                  body
                  =   list.map
                      (
                        this:
                          if  (Account.isInstanceOf this)
                          ||  (Section.isInstanceOf this)
                          then
                            this
                          else
                            debug.panic [ "Section" title ]
                            {
                              text      =   "Either Section or Account expected, got";
                              data      =   this;
                            }
                      )
                      body;
                };
        };
  in
    { inherit Section; }
