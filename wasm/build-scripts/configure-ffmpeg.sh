#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

FLAGS=(
  "${FFMPEG_CONFIG_FLAGS_BASE[@]}"
  --enable-gpl            # required by x264
  --enable-nonfree        # required by fdk-aac
  --enable-zlib           # enable zlib
  --enable-libx264        # enable x264
  --enable-libx265        # enable x265
  --enable-libvpx         # enable libvpx / webm
  --enable-libwavpack     # enable libwavpack
  --enable-libmp3lame     # enable libmp3lame
  --enable-libfdk-aac     # enable libfdk-aac
  --enable-libtheora      # enable libtheora
  --enable-libvorbis      # enable libvorbis
  --enable-libfreetype    # enable freetype
  --enable-libopus        # enable opus
  --enable-libwebp        # enable libwebp
  --enable-libass         # enable libass
  --enable-libfribidi     # enable libfribidi
  # --enable-libaom         # enable libaom
)
echo "FFMPEG_CONFIG_FLAGS=${FLAGS[@]}"
emconfigure ./configure "${FLAGS[@]}"
