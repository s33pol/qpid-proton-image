FROM debian:buster-slim AS build-tools
ARG VER

RUN apt-get update \
    && apt-get install -y apt-utils curl
RUN apt-get install -y \
        cmake g++ python-dev ruby-dev golang git \
        pkg-config doxygen \
        python-setuptools python-wheel \
        libsasl2-dev libssl-dev libjsoncpp-dev swig


FROM build-tools AS proton-build
ARG VER
WORKDIR /workspace
RUN curl  \
        ftp://ftp.mirrorservice.org/sites/ftp.apache.org/qpid/proton/${VER}/qpid-proton-${VER}.tar.gz \
        --output qpid-proton-${VER}.tar.gz \
    && tar xf qpid-proton-${VER}.tar.gz
WORKDIR /workspace/qpid-proton-${VER}/build
RUN mkdir -p /qpid-proton \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/qpid-proton/ .. \
    && make install/strip


FROM debian:buster-slim AS image
RUN apt-get update \
    && apt-get install -y \
        openssl libsasl2-2
ENV CGO_CFLAGS "-I /qpid-proton/include"
ENV CGO_LDFLAGS "-L /qpid-proton/lib"
ENV LD_LIBRARY_PATH "/qpid-proton/lib"
COPY --from=proton-build /qpid-proton/ /qpid-proton/