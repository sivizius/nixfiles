{ bibliography, chemistry, core, glossaries, ... } @ libs:
  let
    inherit(core)       library list path set string type;
    inherit(chemistry)  substances;
  in#: D -> PreparedDocument<D> where D: Document
    { configuration, resources, title, ... } @ document:
      let
        concise                         =   configuration.concise or false;
        figures                         =   path.import resources.figures;
        figures'
        =   set.map
            (
              name:
              figure:
                type.matchPrimitiveOrPanic figure
                {
                  "path"                =   { src = figure; dst = "resources/figures/${name}-${path.getBaseName figure}"; };
                  "string"              =   { src = figure; dst = "resources/figures/${name}-${path.getBaseName figure}"; };
                  "set"                 =   ({ src, dst }: { inherit src; dst = "resources/figures/${dst}"; }) figure;
                }
            )
            figures;
      in
        document
        //  {
              configuration
              =   configuration
              //  {
                    inherit concise;
                    graduationThesis    =   configuration.graduationThesis or false;
                  };
              dependencies
              =   [
                    { src = ../dependencies/assets;   dst = "assets";   }
                    #{ src = ../dependencies/make.sh;  dst = "make.sh";  }
                    { src = ../dependencies/source;   dst = "source";   }
                    #{ src = ../dependencies/tuc;      dst = "tuc";      }
                  ]
              ++  (set.values figures');
              resources
              =   let
                    assets              =   library.import ../assets libs;
                  in
                    resources
                    //  {
                          acronyms      =   glossaries.acronyms.prepare     ( assets.acronyms   //  ( resources.acronyms    or {} ) );
                          figures       =   set.mapValues ({ src, dst }: dst) figures';
                          hazardous     =                                   ( assets.hazardous  //  ( resources.acronyms    or {} ) );
                          references    =   bibliography.prepare            (                       ( resources.references  or {} ) );
                          substances    =   substances.prepare              (                       ( resources.substances  or null ) );
                        };
              title
              =   string.concatWords
                  (
                    list.filter
                      (x: string.isInstanceOf x && !( string.isEmpty x ) )
                      ( string.split "[[:space:]]+" title )
                  );
            }
