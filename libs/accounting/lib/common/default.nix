{ core, ... } @ libs:
  let
    inherit(core) path;
  in  path.import ./account.nix     libs
  //  path.import ./amount.nix      libs
  //  path.import ./book.nix        libs
  //  path.import ./section.nix     libs
  //  path.import ./total.nix       libs
  //  path.import ./transaction.nix libs
