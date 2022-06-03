#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

FLAGS=(
  "${FFMPEG_CONFIG_FLAGS_BASE[@]}"
  --disable-all
  --enable-gpl            # required by x264
  --enable-libx264        # enable x264
  --enable-zlib           # enable zlib
  --enable-avcodec
  --enable-avformat
  --enable-avfilter
  --enable-swresample
  --enable-swscale
  --enable-decoder=png
  --enable-encoder=png,libx264
  --enable-parser=h264,png
  --enable-protocol=file
  --enable-demuxer=image2
  --enable-muxer=mp4
  --enable-filter=scale,format,null

)
echo "FFMPEG_CONFIG_FLAGS=${FLAGS[@]}"
emconfigure ./configure "${FLAGS[@]}"
