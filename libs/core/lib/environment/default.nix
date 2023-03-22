{ intrinsics, ... }:
  let
    # string -> string | null:
    get
    =   intrinsics.getEnv or ( _: null );

    home                                =   get "HOME";
    user                                =   get "USER";
  in
  {
    inherit get home user;
  }