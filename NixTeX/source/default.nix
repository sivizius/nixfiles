{ core, ... } @ libs:
  let
    inherit(core) library path string;

    common                              =   library.import ./common       libs;
    libs'                               =   libs // common;
    evaluate                            =   library.import ./evaluate.nix libs';
    prepare                             =   library.import ./prepare.nix  libs';
    render                              =   library.import ./render       libs';

    /*Document
    =   type "Document"
        {
          from
          =   documentType:
              { evaluationOrder, render, ... }:
              name:
              { ... } @ document:
                Document.instanciate documentType
                {
                  __functor
                  =   self:
                      outputFormat:
                        render outputFormat (evaluate evaluationOrder (prepare document));
                };
        };*/

    constructDocument
    =   __type__:
        { evaluationOrder, render, ... }:
        name:
        { ... } @ document:
        {
          __functor
          =   self:
              outputFormat:
                render outputFormat
                (
                  evaluate evaluationOrder
                  (
                    prepare
                    (
                      document
                      //  {
                            inherit name __type__;
                          }
                    )
                  )
                );
        };
  in
    {
      Application                       =   constructDocument "Application" render.application;
      Dependencies                      =   [ { src = path; dst = string; } ];
      Disputation                       =   constructDocument "Disputation" render.disputation;
    # Journal                           =   constructDocument "Journal"     render.journal;
    # Letter                            =   constructDocument "Letter"      render.letter;
    # Thesis                            =   constructDocument "Thesis"      render.thesis;
    }
    //  common
