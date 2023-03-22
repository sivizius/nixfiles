#!/usr/bin/env bash

nix "$@" \
  --override-input libcore                ../core \
  --override-input libcore/libintrinsics  ../intrinsics