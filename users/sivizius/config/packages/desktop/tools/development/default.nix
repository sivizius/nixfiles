{ nix, texlive, ... }:
[
  ./python.nix
  ./rust.nix
  nix.minikube
  nix.kubectl
  #nix.binutils
  nix.clang
  #nix.glib
  #nix.glibc
  nix.lua
  nix.patchelf
  nix.pkg-config
  nix.stdenv
  nix.swift
  texlive.combined.scheme-full
  nix.nil

  nix.prusa-slicer
  nix.openscad
]
