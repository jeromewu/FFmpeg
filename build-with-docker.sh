#!/bin/bash

docker pull gcc:9.1
docker run -it \
  -v $PWD:/usr/src \
  gcc:9.1 \
  sh -c 'cd /usr/src && ./configure --disable-x86asm && make -j'
