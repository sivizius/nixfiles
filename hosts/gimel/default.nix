{ lib, networks, profiles, users, ... }:
let
  inherit(lib.deploy) hosts mount;
  inherit(hosts)      Host Network Peer;
  inherit(mount)      XFS VFAT;
in
  Host "gimel (third hebrew character) is usually installed on sivizius@gimel.sivizius.eu."
  {
  }