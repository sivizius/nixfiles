{ chemistry, core, Substance, ... } @ libs:
let
  inherit(core) context debug list path set string type;

  check
  =   let
        libs'                           =   libs // { chemistry = chemistry // { inherit Substance; }; };
        optional
        =   condition:
            body:
              if condition
              then
                [ body ]
              else
                [ ];
        check1H
        =   name:
            spectra:
              if spectra."1H" or null != null
              then
                let
                  spectra'              =   spectra."1H".files;
                in
                  []
                  ++  (
                        optional
                          (spectra'.self or null == null)
                          "1H-Spectrum for novel ${name} missing"
                      )
                  ++  (
                        optional
                          (spectra'.cosy or null == null)
                          "1H-COSY-Spectrum for novel ${name} missing"
                      )
              else
                [ "1H-NMR for novel ${name} missing" ];
        check13C
        =   name:
            spectra:
              if spectra."13C" or null != null
              then
                let
                  spectra'              =   spectra."13C".files;
                in
                  []
                  ++  (
                        optional
                          (spectra'.self or spectra'.dc or null == null)
                          "13C-Spectrum for novel ${name} missing"
                      )
                  ++  (
                        optional
                          (spectra'.apt or spectra'.dept135 or spectra'.dept45 or null == null)
                          "13C-APT/DEPT-Spectrum for novel ${name} missing"
                      )
              else
                [ "13C-NMR for novel ${name} missing" ];
        checkNMR
        =   name:
            nmr:
              if nmr != null
              then
                [ ]
                ++  ( check1H   name nmr )
                ++  ( check13C  name nmr )
              else
                [ "NMR-Data for novel ${name} missing" ];
        checkSubstance
        =   source:
            {
              name,
              formula     ? null,
              ir          ? null,
              ms          ? null,
              nmr         ? null,
              novel       ? false,
              structure   ? null,
              synthesised ? true,
              title       ? null,
              ...
            } @ self:
              let
                result
                =   []
                ++  ( optional (title     == null) "Title for ${name} missing"      )
                ++  ( optional (formula   == null) "Formula for ${name} missing"    )
                ++  ( optional (structure == null) "Structure for ${name} missing"  )
                ++  (
                      if novel && synthesised
                      then
                        []
                        ++  ( optional (ir  == null) "IR-Data for novel ${name} missing" )
                        ++  ( optional (ms  == null) "MS-Data for novel ${name} missing" )
                        ++  ( checkNMR name nmr )
                      else
                        []
                    );
              in
                debug.warn source
                  {
                    text                =   result;
                    when                =   result != [];
                  }
                  result;
      in
        source:
        substances:
          type.matchPrimitiveOrPanic substances
          {
            lambda                      =   check source (substances libs');
            path                        =   check (source substances) (path.importScoped { inherit Substance; } substances);
            list                        =   list.concatMap (check source) substances;
            set                         =   checkSubstance source substances;
          };

  check'
  =   substances:
        string.concatLines (check (context "check") substances);

  checkNovel
  =   { ... } @ substances:
        let
          novelSubstances               =   list.filter ({ novel ? false, ... }: novel) (set.values substances);
          formattedSubstances
          =   list.map
              (
                { name, nmr ? null, ir ? null, ... }:
                  let
                    nmr'
                    =   if nmr != null
                        then
                          nmr
                        else
                          "\\multicolumn{4}{c|}{– NMR? –}";
                  in
                    "${name} & "
              )
              novelSubstances;
        in
          [];
in
{
  inherit check check' checkNovel;
}