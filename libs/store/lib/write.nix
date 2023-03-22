{ core, ... }:
  let
    inherit(core) debug derivation library list path set string;

    buildTextFile
    =   { body, fileName, buildSystem, name, permissions, registries }:
          let
            system                      =   string buildSystem;
            pkgs                        =   (registries { targetSystem = buildSystem; }).nix;
            directory
            =   derivation
                {
                  args                  =   [ writeTextFile ];
                  builder               =   "${pkgs.bash}/bin/bash";
                  # Environment Variables
                  coreutils             =   "${pkgs.coreutils-full}/bin";
                  inherit body fileName name permissions system;
                };
          in
            "${directory}/${fileName}";

    buildDirectory
    =   { body, buildSystem, name, registries }:
          let
            builder
            =   writeScriptFile
                {
                  name                  =   "${name}-builder";
                  inherit buildSystem registries;
                  body                  =   "${shebang}\n${string.concatLines mkdir}\n${string.concatLines link}";
                  fileName              =   "${name}-builder.sh";
                };
            link
            =   set.mapToList
                  (dst: src: ''$coreutils/ln -s "${src}" "$out/${dst}"'')
                  body;
            mkdir
            =   set.values
                (
                  list.fold
                    (
                      result:
                      fileName:
                        let
                          dir           =   path.getDirectory fileName;
                        in
                          result
                          //  {
                                ${dir}  =   ''$coreutils/mkdir -p "$out/${dir}"'';
                              }
                    )
                    {}
                    (set.names body)
                );
            pkgs                        =   (registries { targetSystem = buildSystem; }).nix;
            shebang                     =   "#!${pkgs.bash}/bin/sh";
          in
            debug.info "buildDirectory"
            {
              text                      =   "${name}";
              data                      =   { inherit builder link mkdir; };
              nice                      =   true;
            }
            (
              derivation
              {
                inherit builder name;
                coreutils               =   "${pkgs.coreutils-full}/bin";
                system                  =   "${buildSystem}";
              }
            );

    writeConfigFile
    =   { ... } @ this:
          buildTextFile (this // { permissions = "444"; });

    writeScriptFile
    =   { ... } @ this:
          buildTextFile (this // { permissions = "555"; });

    writeTextFile
    =   path.toFile "writeTextFile.sh"
        ''
          $coreutils/mkdir $out
          echo -n "$body" > $out/$fileName
          $coreutils/chmod $permissions $out/$fileName
        '';
  in
    library.NeedInitialisation
    (
      { ... } @ self:
      { buildSystem, registries, targetSystem, ... } @ args:
        set.callValues args self
    )
    {
      configFile
      =   { buildSystem, registries, ... }:
          { fileName, name ? null }:
          body:
            writeConfigFile { inherit body fileName buildSystem name registries; };

      scriptFile
      =   { buildSystem, registries, ... }:
          { fileName, name ? null }:
          body:
            writeScriptFile { inherit body fileName buildSystem name registries; };

      bashScript
      =   { buildSystem, registries, targetSystem, ... }:
          name:
          body:

            let
              shebang                   =   "#!${(registries { inherit targetSystem; }).nix.bash}/bin/bash";
            in
              writeScriptFile
              {
                inherit buildSystem name registries;
                body                    =   "${shebang}\n${body}";
                fileName                =   "${name}.sh";
              };

      bashScript'
      =   { buildSystem, registries, ... }:
          name:
          body:
            let
              shebang                   =   "#!${(registries { targetSystem = buildSystem; }).nix.bash}/bin/bash";
            in
              writeScriptFile
              {
                inherit buildSystem name registries;
                body                    =   "${shebang}\n${body}";
                fileName                =   "${name}.sh";
              };

      directory
      =   { buildSystem, registries, ... }:
          name:
          { ... } @ body:
            buildDirectory { inherit body buildSystem name registries; };

      pythonScript
      =   { buildSystem, registries, targetSystem, ... }:
          name:
          body:
            let
              shebang                   =   "#!${(registries { inherit targetSystem; }).nix.bash}/bin/python3";
            in
              writeScriptFile
              {
                inherit buildSystem name registries;
                body                    =   "${shebang}\n${body}";
                fileName                =   "${name}.py";
              };

      pythonScript'
      =   { buildSystem, registries, ... }:
          name:
          body:
            let
              shebang                   =   "#!${(registries { targetSystem = buildSystem; }).nix.bash}/bin/python3";
            in
              writeScriptFile
              {
                inherit buildSystem name registries;
                body                    =   "${shebang}\n${body}";
                fileName                =   "${name}.py";
              };

      shellScript
      =   { buildSystem, registries, targetSystem, ... }:
          name:
          body:
            let
              shebang                   =   "#!${(registries { inherit targetSystem; }).nix.bash}/bin/sh";
            in
              writeScriptFile
              {
                inherit buildSystem name registries;
                body                    =   "${shebang}\n${body}";
                fileName                =   "${name}.sh";
              };

      shellScript'
      =   { buildSystem, registries, ... }:
          name:
          body:
            let
              shebang                   =   "#!${(registries { targetSystem = buildSystem; }).nix.bash}/bin/sh";
            in
              writeScriptFile
              {
                inherit buildSystem name registries;
                body                    =   "${shebang}\n${body}";
                fileName                =   "${name}.sh";
              };
    }
