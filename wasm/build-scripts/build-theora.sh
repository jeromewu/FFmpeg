#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/theora
CONF_FLAGS=(
  --prefix=$BUILD_DIR                                 # install library in a build directory for FFmpeg to include
  --host=i686-linux                                   # use i686 linux
  --enable-shared=no                                  # disable shared library
  --enable-docs=no
  --enable-fast-install=no
  --disable-spec
  --disable-asm
  --disable-examples
  --disable-oggtest                                   # disable ogg tests
  --disable-vorbistest                                # disable vorbis tests
  --disable-sdltest                                   # disable sdl tests
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && \
  emconfigure ./autogen.sh "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install -j
