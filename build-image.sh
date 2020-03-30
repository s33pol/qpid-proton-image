#!/usr/bin/env bash
set -e

QPIDPROTON_VER=0.30.0

docker build \
    -f qpid-proton.Dockerfile \
    --build-arg VER=${QPIDPROTON_VER} \
    --tag qpid-proton:${QPIDPROTON_VER} \
    --force-rm \
    .

docker build \
    -f qpid-electron.Dockerfile \
    --tag electron-client-server:${QPIDPROTON_VER} \
    --force-rm \
    .