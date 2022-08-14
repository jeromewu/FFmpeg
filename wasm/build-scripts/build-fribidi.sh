#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/fribidi
CONF_FLAGS=(
  --prefix=$BUILD_DIR                                 # install library in a build directory for FFmpeg to include
  --host=x86_64-linux
  --enable-shared=no                                  # not to build shared library
  --enable-static=yes
  --disable-dependency-tracking
  --disable-debug
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && \
  emconfigure ./autogen.sh "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install -j || true
cp $LIB_PATH/fribidi.pc $BUILD_DIR/lib/pkgconfig
