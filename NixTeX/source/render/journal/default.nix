{ core, ... } @ libs:
  let
    inherit(core) library;

    getFormat
    =   outputFormat:
          if outputFormat != null
          then
            outputFormat
          else
            "tex";
    renderTex                           =   library.import ./tex libs;
  in
    outputFormat:
    {
      "tex"                             =   renderTex;
    }.${getFormat outputFormat}
