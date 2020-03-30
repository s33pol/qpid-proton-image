FROM debian:buster-slim AS build-tools
ARG VER

RUN apt-get update \
    && apt-get install -y curl
RUN apt-get install -y \
    cmake g++ python-dev ruby-dev \
    pkg-config doxygen valgrind \
    libsasl2-dev libboost-all-dev uuid-dev libnss3-dev swig libdb-dev libdb++-dev libaio-dev


FROM build-tools AS qpid-cpp-build
WORKDIR /workspace
RUN curl  \
        ftp://ftp.mirrorservice.org/sites/ftp.apache.org/qpid/cpp/${VER}/qpid-cpp-${VER}.tar.gz \
        --output qpid-cpp-${VER}.tar.gz \
    && tar xf qpid-cpp-${VER}.tar.gz
WORKDIR /workspace/qpid-cpp-${VER}/build
RUN mkdir -p /qpid-cpp \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/qpid-cpp/ .. \
    && make install/strip


FROM debian:buster-slim AS image
ENV LD_LIBRARY_PATH "/qpid-cpp/lib"
COPY --from=qpid-cpp-build /qpid-proton/ /qpid-proton/

