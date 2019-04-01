FROM arm32v6/node:8.15.1-alpine AS build

COPY bin/qemu-arm-static /usr/bin/

RUN apk update && apk --no-cache add git wget build-base python linux-headers

RUN git clone https://github.com/nodejs/node.git

RUN cd node && \
    git checkout v8.11.3 && \
    wget https://raw.githubusercontent.com/zeit/pkg-fetch/master/patches/node.v8.11.3.cpp.patch && \
    git apply node.v8.11.3.cpp.patch && \
    ./configure && \
    make && \
    cp node ../fetched-v8.11.3-linux-armv7

CMD ["/bin/bash"]