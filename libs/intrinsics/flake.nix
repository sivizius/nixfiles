{
  description                           =   "Nix builtins/intrinsics.";
  inputs                                =   {}; # No Inputs!
  outputs
  =   { ... }:
        let
          # Cannot use import, because import is itself an intrinsic function.
          lib
          =   {
                #!  Abort Nix expression evaluation and print the error message.
                abort#: string -> !
                =   builtins.abort;

                #!  Return the sum of two numbers.
                add#: number -> number -> number
                =   builtins.add
                or  (p: q: p + q);

                #!  TODO: Documentation
                addErrorContext#: T -> T
                =   builtins.addErrorContext;

                #!  Return `true` if the function returns `true` for all elements of the list, and `false` otherwise.
                all#: (T -> bool) -> [ T ] -> bool
                =   builtins.all;

                #!  Return `true` if the function returns `true` for at least one element of the list, and `false` otherwise.
                any#: (T -> bool) -> [ T ] -> bool
                =   builtins.any;

                #!  TODO: Documentation
                appendContext#: T -> T
                =   builtins.appendContext;

                #!  Return the names of the attributes in the set in an alphabetically sorted list.
                #!  For instance, `attrNames { y = 1; x = "foo"; }` evaluates to `[ "x" "y" ]`.
                attrNames#: { string -> T } -> [ string ]
                =   builtins.attrNames;

                #!  Return the values of the attributes in the set in the order corresponding to the sorted attribute names.
                attrValues#: { string -> T } -> [ T ]
                =   builtins.attrValues;

                #!  Return the base name of an expression that can be coerced to a string.
                #!  That is, everything following the final slash in the string, or the full string, if no slash is present.
                #!  This is similar to the GNU basename command.
                baseNameOf#: ToString -> string
                =   builtins.baseNameOf;

                #!  Return the bitwise conjunction of two integers.
                bitAnd#: integer -> integer -> integer
                =   builtins.bitAnd;

                #!  Return the bitwise disjunction of two integers.
                bitOr#: integer -> integer -> integer
                =   builtins.bitOr;

                #!  Return the bitwise exclusive disjunction of two integers.
                bitXor#: integer -> integer -> integer
                =   builtins.bitXor;

                #!  In debug mode (enabled using `--debugger`),
                #!    pause Nix expression evaluation and enter the REPL.
                #!  Otherwise, return the argument `v`.
                break#: T -> T
                =   builtins.break
                or  (x: x);

                #!  Collect each attribute named attr from a list of attribute sets.
                #!  Attrsets that do not contain the named attribute are ignored.
                #!  For example,
                #!  ```
                #!    catAttrs "a" [{a = 1;} {b = 0;} {a = 2;}]
                #!  ```
                #!  evaluates to `[1 2]`.
                catAttrs#: string -> [ { string -> T } ] -> [ T ]
                =   builtins.catAttrs;

                #!  Converts an IEEE-754 double-precision floating-point number (double) to the next higher integer.
                #!  If the datatype is neither an `integer` nor a `float`, an evaluation error will be thrown.
                ceil#: integer | float -> integer
                =   builtins.ceil;

                #!  Compare two strings representing versions and return
                #!  * `-1` if the first version is older than the second version,
                #!  * `0` if they are the same, and
                #!  * `1` if the first is newer than the second.
                #!  The version comparison algorithm is the same
                #!    as the one used by `nix-env -u ../command-ref/nix-env.md#operation---upgrade`.
                compareVersions#: string -> string -> integer
                =   builtins.compareVersions;

                #!  Concatenate a list of lists into a single list.
                concatLists#: [ [ T ] ] -> [ T ]
                =   builtins.concatLists;

                #!  This function is equivalent to `f: list: concatLists (map f list)` but is more efficient.
                concatMap#: (T -> U) -> [ T ] -> U
                =   builtins.concatMap;

                #!  Concatenate a list of strings with a separator between each element,
                #!    e.g. `concatStringsSep "/" ["usr" "local" "bin"]` returns `"usr/local/bin"`.
                concatStringsSep#: string -> [ string ] -> string
                =   builtins.concatStringsSep;

                #!  This is like `seq e1 e2`, except that `e1` is evaluated deeply:
                #!    if it is a `list` or `set`, its elements or attributes are also evaluated recursively.
                deepSeq#: T -> T
                =   builtins.deepSeq;

                #!  TODO: Documentation
                derivation#:
                =   builtins.derivation;

                #!  Construct (as a unobservable side effect) a Nix derivation expression
                #!    that performs the derivation described by the argument set.
                #!  Returns the original set extended with the following attributes:
                #!  * `outPath' containing the primary output path of the derivation;
                #!  * `drvPath' containing the path of the Nix expression; and
                #!  * `type' set to `derivation' to indicate that this is a derivation.
                derivationStrict#: T -> T
                =   builtins.derivationStrict;

                #!  Return the base name of an expression that can be coerced to a string.
                #!  That is, everything before the final slash in the string.
                #!  This is similar to the GNU `dirname` command.
                dirOf#: T -> T
                =   builtins.dirOf;

                #!  Return the quotient of the numbers e1 and e2.
                div#: number -> number -> number
                =   builtins.div
                or  (p: q: p / q);

                #!  Return true if a given value occurs in the list, and false otherwise.
                elem#: T -> [ T ] -> bool
                =   builtins.elem;

                #!  Return element by index from the list.
                #!  Elements are counted starting from 0.
                #!  A fatal error occurs if the index is out of bounds.
                elemAt#: [ T ] -> integer -> T | !
                =   builtins.elemAt;

                #!  Contradiction
                false#: bool
                =   builtins.false
                or  (1 != 1);

                /*#!  TODO: Documentation
                fetchClojure
                =   builtins.fetchClojure or (builtins.throw "Not available yet");*/

                #!  Fetch a path from git.
                #!  Arguments can be a URL, in which case the HEAD of the repo at that URL is fetched.
                #!  Otherwise, it can be an attribute with the following attributes (all except url optional):
                #!  *[url]        The URL of the repo.
                #!  *[name]       The name of the directory the repo should be exported to in the store.
                #!                Defaults to the basename of the URL.
                #!  *[rev]        The git revision to fetch.
                #!                Defaults to the tip of ref.
                #!  *[ref]        The git ref to look for the requested revision under.
                #!                This is often a branch or tag name. Defaults to HEAD.
                #!                By default, the ref value is prefixed with refs/heads/.
                #!                As of Nix 2.3.0 Nix will not prefix refs/heads/ if ref starts with refs/.
                #!  *[submodules] A Boolean parameter that specifies whether submodules should be checked out.
                #!                Defaults to false.
                #!  *[allRefs]    Whether to fetch all refs of the repository.
                #!                With this argument being true, it is possible to load a rev from any ref.
                #!                By default only revs from the specified ref are supported.
                #!  # Examples
                #!  Here are some examples of how to use fetchGit:
                #!  * To fetch a private repository over SSH:
                #!    ```
                #!      fetchGit {
                #!        url = "git@github.com:my-secret/repository.git";
                #!        ref = "master";
                #!        rev = "adab8b916a45068c044658c4158d81878f9ed1c3";
                #!      }
                #!    ```
                #!  * To fetch an arbitrary reference:
                #!    ```
                #!      fetchGit {
                #!        url = "https://github.com/NixOS/nix.git";
                #!        ref = "refs/heads/0.5-release";
                #!      }
                #!    ```
                #!  * If the revision you are looking for is in the default branch of the git repository
                #!      you do not strictly need to specify the branch name in the ref attribute.
                #!    However, if the revision you are looking for is in a future branch for the non-default branch
                #!      you will need to specify the the ref attribute as well.
                #!    ```
                #!      fetchGit {
                #!        url = "https://github.com/nixos/nix.git";
                #!        rev = "841fcbd04755c7a2865c51c1e2d3b045976b7452";
                #!        ref = "1.11-maintenance";
                #!      }
                #!    ```
                #!    It is nice to always specify the branch which a revision belongs to.
                #!    Without the branch being specified, the fetcher might fail if the default branch changes.
                #!    Additionally, it can be confusing to try a commit from a non-default branch and see the fetch fail.
                #!    If the branch is specified the fault is much more obvious.
                #!    If the revision you are looking for is in the default branch of the git repository
                #!      you may omit the ref attribute.
                #!    ```
                #!      fetchGit {
                #!        url = "https://github.com/nixos/nix.git";
                #!        rev = "841fcbd04755c7a2865c51c1e2d3b045976b7452";
                #!      }
                #!    ```
                #!  * To fetch a specific tag:
                #!    ```
                #!      fetchGit {
                #!        url = "https://github.com/nixos/nix.git";
                #!        ref = "refs/tags/1.9";
                #!      }
                #!    ```
                #!  * To fetch the latest version of a remote branch:
                #!    ```
                #!      fetchGit {
                #!        url = "ssh://git@github.com/nixos/nix.git";
                #!        ref = "master";
                #!      }
                #!    ```
                #!    Nix will refetch the branch in accordance with the option tarball-ttl.
                #!    This behavior is disabled in Pure evaluation mode.
                fetchGit#: {
                #   allRefs: bool = false;
                #   name: string?;
                #   ref: string?;
                #   rev: string?;
                #   submodules: bool = false;
                #   url: string;
                # } | string -> path
                =   builtins.fetchGit;

                #!  TODO: Documentation
                fetchMercurial#: T -> T
                =   builtins.fetchMercurial;

                #!  Download the specified URL, unpack it and return the path of the unpacked tree.
                #!  The file must be a tape archive (.tar) compressed with gzip, bzip2 or xz.
                #!  The top-level path component of the files in the tarball is removed,
                #!    so it is best if the tarball contains a single directory at top level.
                #!  The typical use of the function is to obtain external Nix expression dependencies,
                #!    such as a particular version of Nixpkgs, e.g.
                #!  ```
                #!    with import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-14.12.tar.gz") {};
                #!    stdenv.mkDerivation { … }
                #!  ```
                #!  The fetched tarball is cached for a certain amount of time (1 hour by default) in ~/.cache/nix/tarballs/.
                #!  You can change the cache timeout either on the command line with `--tarball-ttl number-of-seconds` or
                #!    in the Nix configuration file by adding the line `tarball-ttl = number-of-seconds`.
                #!  Note that when obtaining the hash with nix-prefetch-url the option `--unpack` is required.
                #!  This function can also verify the contents against a hash.
                #!  In that case, the function takes a set instead of a URL.
                #!  The set requires the attribute url and the attribute `sha256`, e.g.
                #!  ```
                #!    with import (fetchTarball {
                #!      url = "https://github.com/NixOS/nixpkgs/archive/nixos-14.12.tar.gz";
                #!      sha256 = "1jppksrfvbk5ypiqdz4cddxdl8z6zyzdb2srq8fcffr327ld5jj2";
                #!    }) {};
                #!    stdenv.mkDerivation { … }
                #!  ```
                #!  This function is not available if restricted evaluation mode ../command-ref/conf-file.md is enabled.
                fetchTarball#: {
                #   url: string;
                #   sha256: string;
                # } | string -> path
                =   builtins.fetchTarball;

                #!  TODO: Documentation
                fetchTree#: T -> T
                =   builtins.fetchTree;

                #!  Download the specified URL and return the path of the downloaded file.
                #!  This function is not available if restricted evaluation mode ../command-ref/conf-file.md is enabled.
                fetchurl#: {
                #   url: string;
                #   sha256: string;
                # } | string -> path
                =   builtins.fetchurl;

                #!  Return a list consisting of the elements of the list for which the function returns true
                filter#: (T -> bool) -> [ T ] -> [ T ]
                =   builtins.filter;

                #!  TODO: Documentation, too long for now
                filterSource#: T -> T
                =   builtins.filterSource;

                #!  TODO: Documentation
                findFile#: T -> T
                =   builtins.findFile;

                #!  Converts an IEEE-754 double-precision floating-point number (double) to the next lower integer.
                #!  If the datatype is neither an integer nor a float, an evaluation error will be thrown.
                floor#: integer | float -> integer
                =   builtins.floor;

                #!  Reduce a list by applying a binary operator, from left to right,
                #!    e.g. `foldl' op nul [x0 x1 x2 ...]` returns `op (op (op nul x0) x1) x2) …`.
                #!  The operator is applied strictly, i.e.,
                #!    its arguments are evaluated first.
                #!  For example, `foldl' (x: y: x + y) 0 [1 2 3]` evaluates to `6`.
                foldl'#: (S -> T -> S) -> S -> [ T ] -> S
                =   builtins.foldl';

                #!  Convert a JSON string to a Nix value.
                #!  For example,
                #!  ```
                #!    fromJSON ''{"x": [1, 2, 3], "y": null}''
                #!  ```
                #!  returns the value `{ x = [ 1 2 3 ]; y = null; }`.
                fromJSON#: string -> T
                =   builtins.fromJSON;

                #!  Convert a TOML string to a Nix value.
                fromTOML#: string -> T
                =   builtins.fromTOML;

                #!  Return a set containing the names of the formal arguments expected by the function f.
                #!  The value of each attribute is a bool denoting whether the corresponding argument has a default value.
                #!  For instance, `functionArgs ({ x, y ? 123}: ...)` returns `{ x = false; y = true; }`.
                #!  "Formal argument" here refers to the attributes pattern-matched by the function.
                #!  Plain lambdas are not included, e.g. `functionArgs (x: ...)` returns `{ }`.
                functionArgs#: (T -> U) -> { string: bool }
                =   builtins.functionArgs;

                #!  Generate list of size length, with each element i equal to the value returned by generator i.
                #!  For example, `genList (x: x * x) 5` returns the list `[ 0 1 4 9 16 ]`.
                genList#: T -> T
                =   builtins.genList;

                #!  Take an attrset with values named startSet and operator in order to return a list of attrsets
                #!    by starting with the startSet, recursively applying the operator function to each element.
                #!  The attrsets in the startSet and produced by the operator must each contain value named key,
                #!    which are comparable to each other.
                #!  The result is produced by repeatedly calling the operator for each element encountered with a unique key,
                #!    terminating when no new elements are produced.
                #!  For example,
                #!  ```
                #!    genericClosure {
                #!      startSet = [ {key = 5;} ];
                #!      operator = item: [{
                #!        key = if (item.key / 2 ) * 2 == item.key
                #!             then item.key / 2
                #!             else 3 * item.key + 1;
                #!      }];
                #!    }
                #!  ```
                #!  evaluates to  `[ { key = 5; } { key = 16; } { key = 8; } { key = 4; } { key = 2; } { key = 1; } ]`.
                genericClosure#: {
                #   startSet: [ { key: T; ... } ];
                #   operator: T -> [ { key: T; ... } ]
                # } -> [ { key: T; ... } ]
                =   builtins.genericClosure;

                #!  Returns a attribute from set.
                #!  Evaluation aborts if the attribute does not exist.
                #!  This is a dynamic version of the . operator, since the attribute is an expression rather than an identifier.
                getAttr#: string -> { string -> T } -> T | !
                =   builtins.getAttr;

                #!  TODO: Documentation
                getContext#: T -> T
                =   builtins.getContext;

                #!  Returns the value of an environment variable, or an empty string if the variable does not exist.
                #!  This function should be used with care,
                #!    as it can introduce all sorts of nasty environment dependencies in your Nix expression.
                #!  It is used in Nix Packages to locate the file ~/.nixpkgs/config.nix,
                #!    which contains user-local settings for Nix Packages.
                #!  That is, it does a getEnv "HOME" to locate the user’s home directory.
                getEnv#: string -> string
                =   builtins.getEnv;

                #!  Fetch a flake from a flake reference, and return its output attributes and some metadata.
                #!  For example:
                #!  ```
                #!    (getFlake "nix/55bc52401966fbffa525c574c14f67b00bc4fb3a").packages.x86_64-linux.nix
                #!  ```
                #!  Unless impure evaluation is allowed (--impure), the flake reference must be "locked",
                #!    e.g. contain a Git revision or content hash.
                #!  An example of an unlocked usage is:
                #!  ```
                #!    (getFlake "github:edolstra/dwarffs").rev
                #!  ```
                #!  This function is only available if you enable the experimental feature flakes.
                getFlake#: { ... } | string -> flake
                =   builtins.getFlake;

                #!  Groups elements of list together by the string returned from the function f called on each element.
                #!  It returns an attribute set
                #!    where each attribute value contains the elements of list
                #!    that are mapped to the same corresponding attribute name returned by f.
                #!  For example, `groupBy (substring 0 1) ["foo" "bar" "baz"]`
                #!    evaluates to `{ b = [ "bar" "baz" ]; f = [ "foo" ]; }`
                groupBy#: (T -> string) -> [ T ] -> { string -> [ T ] }
                =   builtins.groupBy;

                #! hasAttr returns true if set has an attribute named s, and false otherwise.
                #!  This is a dynamic version of the ? operator, since s is an expression rather than an identifier.
                hasAttr#: string -> { string -> T } -> bool
                =   builtins.hasAttr
                or  (name: attrs: attrs.${name} or true == attrs.${name} or false);

                #!  TODO: Documentation
                hasContext#: T -> bool
                =   builtins.hasContext;

                #!  Return a base-16 representation of the cryptographic hash of the file at given path.
                #!  The hash algorithm specified must be one of "md5", "sha1", "sha256" or "sha512".
                hashFile#: algorithm: string -> path -> T where algorithm in [ "md5" "sha1" "sha256" "sha512" ]
                =   builtins.hashFile;

                #!  Return a base-16 representation of the cryptographic hash of given string.
                #!  The hash algorithm specified must be one of "md5", "sha1", "sha256" or "sha512".
                hashString#: algorithm: string -> string -> T where algorithm in [ "md5" "sha1" "sha256" "sha512" ]
                =   builtins.hashString;

                #!  Return the first element of a list; abort evaluation if the argument is not a list or is an empty list.
                #!  You can test whether a list is empty by comparing it with [].
                head#: [ T ] -> T | !
                =   builtins.head;

                #!  TODO: Too long for now
                import#: path -> T
                =   builtins.import;

                #!  Return a set consisting of the attributes in the second set that also exist in the first set.
                intersectAttrs#: { string -> T } -> { string -> U } -> { string -> U }
                =   builtins.intersectAttrs;

                #!  Return true if e evaluates to a set, and false otherwise.
                isAttrs#: T -> bool
                =   builtins.isAttrs;

                #!  Return true if e evaluates to a bool, and false otherwise.
                isBool#: T -> bool
                =   builtins.isBool
                or  (x: x == true || x == false);

                #!  Return true if e evaluates to a float, and false otherwise.
                isFloat#: T -> bool
                =   builtins.isFloat;

                #!  Return true if e evaluates to a function, and false otherwise.
                isFunction#: T -> bool
                =   builtins.isFunction;

                #!  Return true if e evaluates to an integer, and false otherwise.
                isInt#: T -> bool
                =   builtins.isInt;

                #!  Return true if e evaluates to a list, and false otherwise.
                isList#: T -> bool
                =   builtins.isList;

                #!  DEPRECATED:
                #!  Return true if e evaluates to null, and false otherwise.
                #!  Just write e == null instead.
                isNull#: T -> bool
                =   builtins.isNull
                or  (x: x == null);

                #!  Return true if e evaluates to a path, and false otherwise.
                isPath#: T -> bool
                =   builtins.isPath;

                #!  Return true if e evaluates to a string, and false otherwise.
                isString#: T -> bool
                =   builtins.isString;

                #!  TODO: Documentation
                langVersion#: integer
                =   builtins.langVersion;

                #!  Return the length of a list.
                length#: [ T ] -> integer
                =   builtins.length;

                #!  Return true if the first number is less than the second number, and false otherwise.
                lessThan#: number -> number -> bool
                =   builtins.lessThan
                or  (p: q: p < q);

                #!  Construct a set from a list specifying the names and values of each attribute.
                #!  Each element of the list should be a set consisting of a string-valued attribute name
                #!    specifying the name of the attribute, and an attribute value specifying its value.
                #!  # Example
                #!  ```
                #!    listToAttrs
                #!      [ { name = "foo"; value = 123; }
                #!        { name = "bar"; value = 456; }
                #!      ]
                #!  ```
                #!  evaluates to `{ foo = 123; bar = 456; }`.
                listToAttrs#: [ { name: string; value: T; } ] -> { string -> T }
                =   builtins.listToAttrs;

                #!  Apply the function to each element in the list.
                #!  # Example
                #!  ```
                #!    map (x: "foo" + x) [ "bar" "bla" "abc" ]
                #!  ```
                #!  evaluates to `[ "foobar" "foobla" "fooabc" ]`.
                map#: (T -> U) -> [ T ] -> [ U ]
                =   builtins.map;

                #!  Apply function to every element of attrset.
                #!  # Example
                #!  ```
                #!    mapAttrs (name: value: value * 10) { a = 1; b = 2; }
                #!  ```
                #!  evaluates to `{ a = 10; b = 20; }`.
                mapAttrs#: (string -> T -> U) -> { string -> T } -> { string -> U }
                =   builtins.mapAttrs;

                #!  TODO: Too long for now
                match#: regex -> string -> [ T ] | null where T: string | [ T ]
                =   builtins.match;

                #!  Return the product of the two numbers.
                mul#: number -> number -> number
                =   builtins.mul
                or  (p: q: p * q);

                #!  TODO: Documentation
                nixPath#: [ { path: string; prefix: string; } ]
                =   builtins.nixPath;

                #!  TODO: Documentation
                nixVersion#: string
                =   builtins.nixVersion;

                #!  The value of the unit type.
                null#: null
                =   builtins.null;

                #!  Split the string into a package name and version.
                #!  The package name is everything up to but not including the first dash followed by a digit,
                #!    and the version is everything following that dash.
                #!  The result is returned in a set `{ name, version }`.
                #!  Thus, `parseDrvName "nix-0.12pre12876"` returns `{ name = "nix"; version = "0.12pre12876"; }`.
                parseDrvName#: string -> { name: string; version: string; }
                =   builtins.parseDrvName;

                #!  Given a predicate function,
                #!    this function returns an attrset containing a list named right,
                #!      containing the elements in list for which the predicate returned true,
                #!    and a list named wrong,
                #!      containing the elements for which it returned false.
                #!  # Examples
                #!  ```
                #!    partition (x: x > 10) [1 23 9 3 42]
                #!  ```
                #!  evaluates to
                #!  ```
                #!    { right = [ 23 42 ]; wrong = [ 1 9 3 ]; }
                #!  ```
                partition#: (T -> bool) -> [ T ] -> { right: [ T ]; wrong: [ T ]; }
                =   builtins.partition;

                #!  TODO: Too long for now
                path#: T -> path
                =   builtins.path;

                #!  Return true if the path path exists at evaluation time, and false otherwise.
                pathExists#: path -> bool
                =   builtins.pathExists;

                #!  Return a placeholder string for the specified output
                #!    that will be substituted by the corresponding output path at build time.
                #!  Typical outputs would be "out", "bin" or "dev".
                placeholder#: string -> string
                =   builtins.placeholder;

                #!  Return the contents of the directory path as a set mapping directory entries to the corresponding file type.
                #!  For instance, if directory A contains a regular file B and another directory C,
                #!    then `readDir ./A` will return the set `{ B = "regular"; C = "directory"; }`.
                #!  The possible values for the file type are "regular", "directory", "symlink" and "unknown".
                readDir#: path -> { string -> string }
                =   builtins.readDir;

                #!  Return the contents of the file path as a string.
                readFile#: path -> string
                =   builtins.readFile;

                #!  Remove the attributes listed in list from set. The attributes don’t have to exist in set.
                #!  # Example
                #!  ```
                #!    removeAttrs { x = 1; y = 2; z = 3; } [ "a" "x" "z" ]
                #!  ```
                #!  evaluates to `{ y = 2; }`.
                removeAttrs#: { string -> T } -> [ string ] -> { string -> T }
                =   builtins.removeAttrs;

                #!  Given string, replace every occurrence of the strings
                #!    in the first list
                #!    with the corresponding string in second list.
                #!  # Example
                #!  ```
                #!    builtins.replaceStrings ["oo" "a"] ["a" "i"] "foobar"
                #!  ```
                #!  evaluates to `"fabir"`.
                replaceStrings#: [ string ] -> [ string ] -> string -> string
                =   builtins.replaceStrings;

                #!  TODO: Documentation
                scopedImport#: path -> T -> T
                =   builtins.scopedImport;

                #!  Evaluate the first expression,
                #!    then evaluate and return the second.
                #!  This ensures that a computation is strict in the value of the first expression.
                seq#: T -> U -> U
                =   builtins.seq;

                #!  Return list in sorted order.
                #!  It repeatedly calls the function comparator with two elements.
                #!  The comparator should return true if the first element is less than the second, and false otherwise.
                #!  # Example
                #!  ```
                #!    sort lessThan [ 483 249 526 147 42 77 ]
                #!  ```
                #!  evaluates to `[ 42 77 147 249 483 526 ]`.
                #!  This is a stable sort:
                #!    It preserves the relative order of elements deemed equal by the comparator.
                sort#: (T -> bool) -> [ T ] -> [ T ]
                =   builtins.sort;

                #!  TODO: Too long for now
                split#: regex -> string -> [ T ] where T: string | [ T ]
                =   builtins.split;

                #!  Split a string representing a version into its components,
                #!    by the same version splitting logic underlying the version comparison
                #!    in `nix-env -u ../command-ref/nix-env.md#operation---upgrade`.
                #!  It basically splits the string at `.` and `-`.
                splitVersion#: string -> [ string ]
                =   builtins.splitVersion;

                #!  TODO: Documentation
                storeDir
                =   builtins.storeDir;

                #!  This function allows you to define a dependency on an already existing store path.
                #!  For example,
                #!    the derivation attribute `src = storePath /nix/store/f1d18v1y…-source`
                #!    causes the derivation to depend on the specified path,
                #!      which must exist or be substitutable.
                #!  Note that this differs from a plain path (e.g. `src = /nix/store/f1d18v1y…-source`)
                #!    in that the latter causes the path to be copied again to the Nix store,
                #!    resulting in a new path (e.g. `/nix/store/ld01dnzc…-source-source`).
                #!  This function is not available in pure evaluation mode.
                storePath#: path -> path
                =   builtins.storePath;

                #!  Return the length of the string in bytes.
                #!  Note that it does not know about unicode.
                stringLength#: string -> integer
                =   builtins.stringLength;

                #!  Return the difference between the two numbers.
                sub#: number -> number -> number
                =   builtins.sub
                or  (p: q: p - q);

                #!  Return the substring of a given string from character zero-based position start up to but not including start + len.
                #!  If start is greater than the length of the string,
                #!    an empty string is returned, and
                #!  if start + len lies beyond the end of the string,
                #!    only the substring up to the end of the string is returned.
                #!  The offset start must be non-negative.
                #!  For example `substring 0 3 "nixos"` evaluates to `"nix"`.
                substring#: integer -> integer -> string -> string | !
                =   builtins.substring;

                #!  Return the second to last elements of a list; abort evaluation if the argument is an empty list.
                #!  Warning: This function should generally be avoided since it is inefficient:
                #!    Unlike Haskell's tail, it takes O(n) time,
                #!      so recursing over a list by repeatedly calling tail takes O(n^2) time.
                tail#: [ T ] -> [ T ] | !
                =   builtins.tail;

                #!  Throw an error message.
                #!  This usually aborts Nix expression evaluation,
                #!    but in nix-env -qa and other commands that try to evaluate a set of derivations
                #!      to get information about those derivations,
                #!    a derivation that throws an error is silently skipped (which is not the case for abort).
                throw#: string -> !
                =   builtins.throw;

                #!  TODO: Too long for now
                toFile#: T -> path
                =   builtins.toFile;

                #!  Return a string containing a JSON representation the given expression.
                #!  Strings, integers, floats, booleans, nulls and lists are mapped to their JSON equivalents.
                #!  Sets (except derivations) are represented as objects.
                #!  Derivations are translated to a JSON string containing the derivation’s output path.
                #!  Paths are copied to the store and represented as a JSON string of the resulting store path.
                toJSON#: T -> string
                =   builtins.toJSON;

                #! DEPRECATED.
                #!  Use /. + "/path" to convert a string into an absolute path.
                #!  For relative paths, use ./. + "/path".
                toPath#: T -> path
                =   builtins.toPath;

                #!  Convert the expression to a string.
                #!  The expression can be:
                #!  * A string (in which case the string is returned unmodified).
                #!  * A path (e.g., toString /foo/bar yields "/foo/bar".)
                #!  * A set containing { __toString = self: ...; } or { outPath = ...; }.
                #!  * An integer or float.
                #!  * A list, in which case the string representations of its elements are joined with spaces.
                #!  * A bool (false yields "", true yields "1").
                #!  * null, which yields the empty string.
                #!  Note that `toString` does not return an actual store path for paths,
                #!    even if the path is a store-path, e.g. when building a flake.
                #!  To ensure a path is copied to the nix store, use `"${fileName}"`.
                toString#: T -> string where T: bool | float integer | null | path | string | [ T ] | { string -> T }
                =   builtins.toString;

                #!  TODO: Too long for now
                toXML#: T -> string
                =   builtins.toXML;

                #!  Evaluate the first expression and print its abstract syntax representation on standard error.
                #!  Then return the second expression.
                #!  This function is useful for debugging.
                trace#: T -> U -> U
                =   builtins.trace
                or  (x: x);

                #!  Tautology
                true#: bool
                =   builtins.true
                or  (1 == 1);

                #!  Try to shallowly evaluate the expression.
                #!  Return a set containing the attributes
                #!  *[success]  true if e evaluated successfully, false if an error was thrown
                #!  *[value]    equalling the expression if successful and false otherwise.
                #!  `tryEval` will only prevent errors created by throw or assert from being thrown.
                #!  Errors tryEval will not catch are for example those created by abort and type errors generated by builtins.
                #!  Also note that this does not evaluate the expression deeply,
                #!    so `let e = { x = throw ""; }; in (tryEval e).success` will be true.
                #!  Using `deepSeq` one can get the expected result:
                #!  ```
                #!    let
                #!      e = { x = throw ""; };
                #!    in
                #!      (tryEval (deepSeq e e)).success
                #!  ```
                #!  will be evaluated to false.
                tryEval#: T -> { success: bool; value: T; }
                =   builtins.tryEval;

                #!  Return a string representing the type of the value,
                #!    namely "int", "bool", "string", "path", "null", "set", "list", "lambda" or "float".
                typeOf#: T -> string
                =   builtins.typeOf;

                #!  TODO: Documentation
                unsafeDiscardOutputDependency#: T -> T
                =   builtins.unsafeDiscardOutputDependency;

                #!  TODO: Documentation
                unsafeDiscardStringContext#: T -> T
                =   builtins.unsafeDiscardStringContext;

                #!  TODO: Documentation
                unsafeGetAttrPos#: T -> T
                =   builtins.unsafeGetAttrPos;

                #!  Transpose a list of attribute sets into an attribute set of lists, then apply mapAttrs.
                #!  The function receives two arguments:
                #!    The attribute name and
                #!    a non-empty list of all values encountered for that attribute name.
                #!  The result is an attribute set where the attribute names are the union of the attribute names in each element of the list.
                #!  The attribute values are the return values of the function.
                #!  # Examples
                #!  ```
                #!    zipAttrsWith
                #!      (name: values: { inherit name values; })
                #!      [ { a = "x"; } { a = "y"; b = "z"; } ]
                #!  ```
                #!  evaluates to
                #!  ```
                #!    {
                #!      a = { name = "a"; values = [ "x" "y" ]; };
                #!      b = { name = "b"; values = [ "z" ]; };
                #!    }
                #!  ```
                zipAttrsWith#: T -> T
                =   builtins.zipAttrsWith;
              };
        in
          { inherit lib; };
}