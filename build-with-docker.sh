#!/bin/bash

set -euo pipefail

EM_VERSION=3.1.30

docker pull emscripten/emsdk:$EM_VERSION
docker run \
  --rm \
  -v $PWD:/src \
  -v $PWD/wasm/cache:/emsdk_portable/.data/cache/wasm \
  -e FFMPEG_ST=${FFMPEG_ST:-no} \
  emscripten/emsdk:$EM_VERSION \
  bash ./build.sh "$@"
