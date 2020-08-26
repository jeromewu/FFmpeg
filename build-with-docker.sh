#!/bin/bash -x

FLAGS=""
# Attach TTY only when available, this is for running in Gihub Actions
if [ -t 1 ]; then FLAGS="-it"; fi

docker pull gcc:8
docker run $FLAGS \
  -v $PWD:/usr/src \
  gcc:8 \
  sh -c 'cd /usr/src && bash ./build.sh'
