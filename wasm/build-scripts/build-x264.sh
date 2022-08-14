#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/x264

if [[ "$FFMPEG_ST" == "yes" ]]; then
  EXTRA_CONF_FLAGS="--disable-thread"
fi

CONF_FLAGS=(
  --prefix=$BUILD_DIR           # install library in a build directory for FFmpeg to include
  --host=i686-gnu               # use i686 linux
  --enable-static               # enable building static library
  --disable-cli                 # disable cli tools
  --disable-asm                 # disable asm optimization
  --extra-cflags="$CFLAGS"      # flags to use pthread and code optimization
  ${EXTRA_CONF_FLAGS-}
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && emconfigure ./configure "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install-lib-static -j
