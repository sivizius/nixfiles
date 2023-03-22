{ debug, intrinsics, list, number, set, string, type, ... } @ libs:
  let
    exists#: path -> bool
    =   intrinsics.pathExists;

    fetchGit#: { ... } -> path
    =   intrinsics.fetchGit;

    fetchMercurial#: { ... } -> path
    =   intrinsics.fetchMercurial;

    fetchTarball#: { ... } -> path
    =   intrinsics.fetchTarball;

    fetchURL#: string | { url: string, sha256: string } -> path
    =   intrinsics.fetchurl;

    filterSource#: (path -> string -> bool) -> path -> path
    =   intrinsics.filterSource;

    find
    =   intrinsics.findFile;

    from#: path | { path: path, name: string?, filter: F?, recursive: bool = true, sha256: string? } | ToString -> path
    =   this:
          if isInstanceOf this
          then
            this
          else if set.isInstanceOf this
          &&      this ? path
          &&      intrinsics ? path
          then
            intrinsics.path this
          else
            ./${string this};

    fromSet#: string -> (string -> T -> string) -> { string -> T } -> path
    =   fileName:
        converter:
        { ... } @ dictionary:
          toFile fileName ( string.concat ( set.values ( set.map converter dictionary ) ) );

    getBaseName#: path -> string
    =   intrinsics.baseNameOf;

    getDirectory#: path -> string
    =   intrinsics.dirOf;

    getPlaceholder#: string -> string
    =   intrinsics.placeholder;

    hash#: string -> path -> string
    =   intrinsics.hashFile;

    import#: path -> any
    =   fileName:
          intrinsics.scopedImport
            (intrinsics.import ./scope.nix libs fileName)
            fileName;

    import'                             =   intrinsics.import;

    importScoped#: path -> { ... } -> any
    =   { ... } @ scope:
        fileName:
          intrinsics.scopedImport
            ((intrinsics.import ./scope.nix libs fileName) // scope)
            fileName;

    isInstanceOf                        =   intrinsics.isPath or (value: type.getPrimitive value == "path");

    nixPaths#: [ { path: string, prefix: string } ]?
    =   intrinsics.nixPath or null;

    orNull
    =   value:
          isInstanceOf value || value == null;

    readDirectory#: path -> { string -> string }
    =   intrinsics.readDir;

    readFile#: path -> string
    =   intrinsics.readFile;

    storeDirectory#: string?
    =   intrinsics.storeDir or null;

    storePath#: path -> string
    =   intrinsics.storePath;

    toFile#: string -> string -> path
    =   intrinsics.toFile;

    toStore#: path -> string
    =   file:
          if isInstanceOf file
          then
            "${file}"
          else
            debug.panic "toStore" "Path expected!";
  in
    type "path"
    {
      isPrimitive                       =   true;

      inherit(intrinsics) path;

      inherit getBaseName getDirectory exists fetchGit fetchTarball fetchURL filterSource find from fromSet getPlaceholder hash import
              import' importScoped isInstanceOf nixPaths orNull readDirectory readFile storeDirectory storePath toFile toStore;
    }
