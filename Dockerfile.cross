FROM __TAG__

ARG PKG_NODE

ARG PKG_OS

ARG PKG_ARCH

ARG NPROC

RUN __DEPENDENCIES__

ENV PKG_CACHE_PATH=/fetched

RUN git clone -b master --single-branch https://github.com/vercel/pkg-fetch.git /build
WORKDIR /build
RUN yarn && yarn run babel
RUN mkdir -p /fetched

RUN MAKE_JOB_COUNT=${NPROC} yarn run bin ${PKG_NODE} ${PKG_OS} ${PKG_ARCH}

CMD ["sh"]