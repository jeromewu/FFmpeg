#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/harfbuzz
CFLAGS="$CFLAGS -DHB_NO_PRAGMA_GCC_DIAGNOSTIC_ERROR"
# A hacky way to disable pthread
if [[ "$FFMPEG_ST" == "yes" ]]; then
  sed -i 's#\[have_pthread=true\]#\[have_pthread=false\]#g' $LIB_PATH/configure.ac
else
  sed -i 's#\[have_pthread=false\]#\[have_pthread=true\]#g' $LIB_PATH/configure.ac
fi
CXXFLAGS=$CFLAGS
CONF_FLAGS=(
  --prefix=$BUILD_DIR                                 # install library in a build directory for FFmpeg to include
  --host=i686-gnu                                     # use i686 linux
  --enable-shared=no                                  # not to build shared library
  --enable-static 
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && \
  emconfigure ./autogen.sh "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install -j
