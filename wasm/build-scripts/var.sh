#!/bin/bash
#
# Common variables for all scripts

set -euo pipefail

# Include llvm binaries
export PATH=$PATH:$EMSDK/upstream/bin

# if yes, we are building a single thread version of
# ffmpeg.wasm-core, which is slow but compatible with
# most browsers as there is no SharedArrayBuffer.
FFMPEG_ST=${FFMPEG_ST:-no}

# Root directory
ROOT_DIR=$PWD

# Directory to install headers and libraries
BUILD_DIR=$ROOT_DIR/build

# Directory to look for pkgconfig files
EM_PKG_CONFIG_PATH=$BUILD_DIR/lib/pkgconfig

# Toolchain file path for cmake
TOOLCHAIN_FILE=$EMSDK/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake

# Flags for code optimization, focus on speed instead
# of size
OPTIM_FLAGS="-O3"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Use closure complier only in linux environment
  OPTIM_FLAGS="$OPTIM_FLAGS --closure=1"
fi

# Unset OPTIM_FLAGS can speed up build
# OPTIM_FLAGS=""

CFLAGS_BASE="$OPTIM_FLAGS -I$BUILD_DIR/include"
CFLAGS="$CFLAGS_BASE -s USE_PTHREADS=1"

if [[ "$FFMPEG_ST" == "yes" ]]; then
  CFLAGS="$CFLAGS_BASE"
  EXTRA_FFMPEG_CONF_FLAGS="--disable-pthreads --disable-w32threads --disable-os2threads"
fi

export CFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
export LDFLAGS="$CFLAGS -L$BUILD_DIR/lib"
export STRIP="llvm-strip"
export EM_PKG_CONFIG_PATH=$EM_PKG_CONFIG_PATH

FFMPEG_CONFIG_FLAGS_BASE=(
  --target-os=none        # use none to prevent any os specific configurations
  --arch=x86_32           # use x86_32 to achieve minimal architectural optimization
  --enable-cross-compile  # enable cross compile
  --disable-x86asm        # disable x86 asm
  --disable-inline-asm    # disable inline asm
  --disable-stripping     # disable stripping
  --disable-programs      # disable programs build (incl. ffplay, ffprobe & ffmpeg)
  --disable-doc           # disable doc
  --disable-debug         # disable debug info, required by closure
  --disable-runtime-cpudetect   # disable runtime cpu detect
  --disable-autodetect    # disable external libraries auto detect
  --extra-cflags="$CFLAGS"
  --extra-cxxflags="$CFLAGS"
  --extra-ldflags="$LDFLAGS"
  --pkg-config-flags="--static"
  --nm="llvm-nm"
  --ar=emar
  --ranlib=emranlib
  --cc=emcc
  --cxx=em++
  --objcc=emcc
  --dep-cc=emcc
  ${EXTRA_FFMPEG_CONF_FLAGS-}
)

echo "EMSDK=$EMSDK"
echo "FFMPEG_ST=$FFMPEG_ST"
echo "CFLAGS(CXXFLAGS)=$CFLAGS"
echo "BUILD_DIR=$BUILD_DIR"
