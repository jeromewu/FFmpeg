#!/bin/bash

set -eo pipefail
source $(dirname $0)/var.sh

if [[ "$FFMPEG_ST" != "yes" ]]; then
  mkdir -p wasm/packages/core.mp4-scale/dist
  EXPORTED_FUNCTIONS="[_main, __emscripten_proxy_main]"
  EXTRA_FLAGS=(
    -pthread
    -s USE_PTHREADS=1                             # enable pthreads support
    -s PROXY_TO_PTHREAD=1                         # detach main() from browser/UI main thread
		-s INITIAL_MEMORY=1073741824                  # 1GB
  )
else
  DISTDIR="wasm/packages/core-st.mp4-scale/dist"
  EXPORTED_FUNCTIONS="[_main]"
  EXTRA_FLAGS=(
		-s INITIAL_MEMORY=33554432                   # 32MB
		-s MAXIMUM_MEMORY=1073741824                  # 1GB
		-s ALLOW_MEMORY_GROWTH=1
  )
fi
mkdir -p "$DISTDIR"
FLAGS=(
  -I. -I./fftools -I$BUILD_DIR/include
  -Llibavcodec -Llibavfilter -Llibavformat -Llibavutil -Llibswscale -Llibswresample -L$BUILD_DIR/lib
  -Wno-deprecated-declarations -Wno-pointer-sign -Wno-implicit-int-float-conversion -Wno-switch -Wno-parentheses -Qunused-arguments
  -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lm -lx264
  fftools/ffmpeg_opt.c fftools/ffmpeg_filter.c fftools/ffmpeg_hw.c fftools/cmdutils.c fftools/ffmpeg.c
  -s USE_SDL=2                                  # use SDL2
  -s INVOKE_RUN=0                               # not to run the main() in the beginning
  -s EXIT_RUNTIME=1                             # exit runtime after execution
  -s MODULARIZE=1                               # use modularized version to be more flexible
  -s EXPORT_NAME="createFFmpegCore"             # assign export name for browser
  -s EXPORTED_FUNCTIONS="$EXPORTED_FUNCTIONS"  # export main and proxy_main funcs
  -s EXPORTED_RUNTIME_METHODS="[FS, cwrap, ccall, setValue, writeAsciiToMemory]"   # export preamble funcs
  -s INITIAL_MEMORY=1073741824                  # 1073741824 bytes = 1 GB
  --post-js wasm/src/post.js
  --pre-js wasm/src/pre.js
  $OPTIM_FLAGS
  ${EXTRA_FLAGS[@]}
)
echo "FFMPEG_EM_FLAGS=${FLAGS[@]}"
emmake make -j
emcc "${FLAGS[@]}"
