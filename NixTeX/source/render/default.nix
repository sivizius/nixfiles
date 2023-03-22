{ core, ... } @ libs:
  let
    inherit(core) library;
  in
  {
    application                         =   library.import ./application  libs;
    disputation                         =   library.import ./disputation  libs;
    #letter                              =   library.import ./letter       libs;
    #journal                               =   library.import ./journal      libs;
    #thesis                                =   library.import ./thesis       libs;
  }
