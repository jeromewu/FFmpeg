#!/bin/bash

set -eo pipefail

SCRIPT_ROOT=$(dirname $0)/wasm/build-scripts

# verify Emscripten version
emcc -v
# install dependencies
$SCRIPT_ROOT/install-deps.sh
# build zlib
$SCRIPT_ROOT/build-zlib.sh
# build x264
$SCRIPT_ROOT/build-x264.sh
# build x265
$SCRIPT_ROOT/build-x265.sh
# build libvpx
$SCRIPT_ROOT/build-libvpx.sh
# build WavPack
$SCRIPT_ROOT/build-wavpack.sh
# build lame
$SCRIPT_ROOT/build-lame.sh
# build fdk-aac
$SCRIPT_ROOT/build-fdk-aac.sh
# build ogg
$SCRIPT_ROOT/build-ogg.sh
# build vorbis
$SCRIPT_ROOT/build-vorbis.sh
# build theora
$SCRIPT_ROOT/build-theora.sh
# build opus
$SCRIPT_ROOT/build-opus.sh
# build freetype2
$SCRIPT_ROOT/build-freetype2.sh
# build libwebp
$SCRIPT_ROOT/build-libwebp.sh
# build fribidi
$SCRIPT_ROOT/build-fribidi.sh
# build harfbuzz
$SCRIPT_ROOT/build-harfbuzz.sh
# build libass
$SCRIPT_ROOT/build-libass.sh
# build aom (disabled as it is extremely slow)
# $SCRIPT_ROOT/build-aom.sh
# configure FFmpeg with Emscripten
$SCRIPT_ROOT/configure-ffmpeg.sh
# build ffmpeg.wasm core
$SCRIPT_ROOT/build-ffmpeg.sh
