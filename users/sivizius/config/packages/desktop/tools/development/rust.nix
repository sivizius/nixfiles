{ nix, ... }:
  with nix;
  [
    chit
    #clippy
    #gir-rs
    #rls
    rust-analyzer
    rust-bindgen
    rust-cbindgen
    #rustc
    #rustfmt
    rustup
  ]
