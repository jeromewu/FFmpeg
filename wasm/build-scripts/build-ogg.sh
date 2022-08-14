#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/Ogg
CONF_FLAGS=(
  --prefix=$BUILD_DIR                                 # install library in a build directory for FFmpeg to include
  --host=i686-linux                                   # use i686 linux
  --disable-shared                                    # disable shared library
  --disable-dependency-tracking                       # speed up one-time build
  --disable-maintainer-mode
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && \
  emconfigure ./autogen.sh && \
  emconfigure ./configure "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install -j
