{ extendPath, ... }:
let
  inherit(builtins) all attrNames attrValues concatMap concatStringsSep dirOf elem elemAt filter foldl'
                    fromJSON functionArgs genList getFlake head listToAttrs isAttrs isBool isFloat
                    isFunction isInt isList isPath isString map match removeAttrs replaceStrings
                    split storeDir stringLength substring toString tryEval trace typeOf
                    unsafeGetAttrPos;

  format
  =   path:
      tab:
      options:
        #trace path
        concatMap
        (
          name:
            let
              path'                     =   extendPath path name;
              option                    =   tryEval options.${name};
              option'                   =   option.value;
              source                    =   unsafeGetAttrPos name options;
            in
              if option.success
              then
                if option'.__type__ or null == "Option"
                then
                  [ "${tab}${name}" ]
                  ++  (formatOption tab option')
                else
                  [
                    "${tab}${name}"
                    "${tab}=   {"
                  ]
                  ++  (format path' "${tab}      " option')
                  ++  [ "${tab}    };" ]
              else
              [
                "${tab}# ${toString source.file}:${toString source.line}:${toString source.column}"
                "${tab}${name} = <ERROR>;"
              ]
        )
        (attrNames options);

  format'
  =   options:
        concatStringsSep "\n"
        (
          [
            "{"
            "  options"
            "  =     {"
          ]
          ++  (format null "          " options)
          ++  [
                "      };"
                "}"
              ]
        );

  formatOption
  =   tab:
      {
        source,
        ...
      }:
        let
          tab'                          =   "${tab}      ";
          source'
          =   if source != null
              then
              [
                "${tab'}source = \"${toString source.file}:${toString source.line}:${toString source.column}\";"
              ]
              else
                [];
        in
          [
                "${tab}=   Option"
                "${tab}    {"
          ]
          ++  []
          ++  [
                "${tab'}description"
                "${tab'}=   ''"
                "${tab'}      "
                "${tab'}    '';"
              ]
          ++  source'
          ++  [
                "${tab}    };"
              ];
in
  format'
