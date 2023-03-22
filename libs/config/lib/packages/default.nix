{ nixpkgs, core, ... }:
  let
    inherit(core) context debug derivation error expression list path set string target type;

    checkPackage
    =   name:
        package:
          let
            inherit(expression.tryEval package) success value;
          in
            debug.info "checkPackage" "Check Package `${name}`…"
            (
              if debug.Debug.isInstanceOf package
              then
                abort "${package}"
              else if success
              &&      derivation.isInstanceOf' value
              then
                value
              else if !success
              then
                debug.panic [ "checkPackage" name ]
                {
                  text                  =   "${name} does not evaluate!";
                  data                  =   value;
                }
              else
                debug.panic [ "checkPackage" ] "${name} is not a package, but a ${type.getPrimitive value}"
            );

    defaultAllowPredicate
    =   predicateName:
        allowAll:
        allowedPackages:
        {
          name  ? null,
          pname ? (extractPackageName name),
          ...
        } @ pkg:
          if pname != null
          then
            let
              allowed                   =   list.find pname allowedPackages;
              allowed'                  =   if allowed then "allowed" else "not allowed";
            in
              debug.warn [ "defaultAllowPredicate" ]
              {
                text                    =   "${predicateName} package `${pname}` ${allowed'}.";
              }
              allowed
          else
            debug.panic [ "defaultAllowPredicate" ]
            {
              text                      =   "Cannot determine pname of ${predicateName} package";
              data                      =   pkg;
              nice                      =   true;
            }
            false;

    defaultHandleEvalIssue
    =   reason:
        message:
          debug.panic "defaultHandleEvalIssue"
          {
            text                        =   reason;
            data                        =   message;
          }
          null;

    extractPackageName
    =   name:
          if name != null
          then
            list.head (string.split "-" name)
          else
            null;

    fixConfig
    =   {
          allowBroken               ? false,
          allowedInsecurePackages   ? [],
          allowedNonSourcePackages  ? [],
          allowedUnfreePackages     ? [],
          allowInsecure             ? false,
          allowInsecurePredicate    ? (defaultAllowPredicate  "insecure"    allowInsecure   allowedInsecurePackages),
          allowlistedLicenses       ? [],
          allowNonSource            ? false,
          allowNonSourcePredicate   ? (defaultAllowPredicate  "non-source"  allowNonSource  allowedNonSourcePackages),
          allowUnfree               ? false,
          allowUnfreePredicate      ? (defaultAllowPredicate  "unfree"      allowUnfree     allowedUnfreePackages),
          allowUnsupportedSystem    ? false,
          blocklistedLicenses       ? [],
          checkMeta                 ? true,
          handleEvalIssue           ? defaultHandleEvalIssue,
          inHydra                   ? false,
          showDerivationWarnings    ? [],
        }:
        {
          inherit allowBroken
                  allowInsecurePredicate
                  allowlistedLicenses
                  allowNonSource allowNonSourcePredicate
                  allowUnfree allowUnfreePredicate
                  allowUnsupportedSystem
                  blocklistedLicenses
                  checkMeta
                  handleEvalIssue
                  inHydra
                  showDerivationWarnings;
        };

    fromNixpkgs
    =   { config ? {}, nixpkgs ? nixpkgs }:
        registry:
          let
            legacyPackages              =   path.import' "${nixpkgs}/default.nix";
          in
            target.System.mapStdenv
            (
              system:
                let
                  legacyPackages'
                  =   legacyPackages
                      {
                        config          =   fixConfig config;
                        system          =   string system;
                      };
                in
                  if registry != null
                  then
                    legacyPackages'.${registry}
                  else
                    legacyPackages'
            );

    load
    =   fileName:
        registries:
          let
            loadPackage
            =   source:
                package:
                  let
                    environment         =   registries // { inherit source; };
                    source'             =   source package;
                  in
                    type.matchPrimitiveOrPanic package
                    {
                      lambda            =   loadPackage   source  (package environment);
                      list              =   loadPackages  source  package;
                      null              =   [];
                      path              =   loadPackage   source' (path.import package);
                      set
                      =   debug.trace [ "load" "loadPackage" ]
                          {
                            text        =   "Package:";
                            data        =   package;
                            nice        =   false;
                          }
                          [ package ];
                    };

            loadPackages
            =   source:
                  list.concatIMap
                  (
                    index:
                      loadPackage (source index)
                  );

            packageList
            =   loadPackage
                  (context fileName)
                  fileName;

            packages
            =   list.fold
                (
                  { ... } @ result:
                  { name, ... } @ package:
                    if      !(set.hasAttribute name result)
                    then
                      result
                      //  {
                            ${name} =   package;
                          }
                    else if result.${name} ==  package
                    then
                      result
                    else
                      debug.panic [ "load" "packages" ]
                      {
                        text            =   "Package already in set";
                        data            =   package;
                      }
                      result
                )
                {}
                packageList;
          in
            debug.debug "load"
            {
              text                      =   "Loaded Packages";
              data                      =   packages;
              nice                      =   true;
            }
            (set.values packages);

    load'
    =   fileName:
        registries:
          target.System.mapStdenv
            (targetSystem: load fileName (registries { inherit targetSystem; }));
  in
  {
    inherit extractPackageName fromNixpkgs load load';
  }
