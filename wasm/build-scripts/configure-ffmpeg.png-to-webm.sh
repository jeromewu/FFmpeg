#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

FLAGS=(
  "${FFMPEG_CONFIG_FLAGS_BASE[@]}"
  --disable-all
  --enable-libvpx
  --enable-zlib           # enable zlib
  --enable-avcodec
  --enable-avformat
  --enable-avfilter
  --enable-swresample
  --enable-swscale
  --enable-decoder=png
  --enable-encoder=png,libvpx_vp8
  --enable-parser=vp8,png
  --enable-protocol=file
  --enable-demuxer=image2
  --enable-muxer=webm
  --enable-filter=scale,format,null

)
echo "FFMPEG_CONFIG_FLAGS=${FLAGS[@]}"
emconfigure ./configure "${FLAGS[@]}"
