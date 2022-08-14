#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/libvpx

if [[ "$FFMPEG_ST" == "yes" ]]; then
  EXTRA_CONF_FLAGS="--disable-multithread"
fi

CONF_FLAGS=(
  --prefix=$BUILD_DIR                                # install library in a build directory for FFmpeg to include
  --target=generic-gnu                               # target with miminal features
  --disable-install-bins                             # not to install bins
  --disable-examples                                 # not to build examples
  --disable-tools                                    # not to build tools
  --disable-docs                                     # not to build docs
  --disable-unit-tests                               # not to do unit tests
  --disable-dependency-tracking                      # speed up one-time build
  --extra-cflags="$CFLAGS"                           # flags to use pthread and code optimization
  --extra-cxxflags="$CXXFLAGS"                       # flags to use pthread and code optimization
  ${EXTRA_CONF_FLAGS-}
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && emconfigure ./configure "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install -j
