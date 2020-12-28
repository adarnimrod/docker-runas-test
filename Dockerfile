ARG image
# hadolint ignore=DL3006
FROM ${image}
# hadolint ignore=DL3018,DL4001
RUN apk add --update --no-cache openssl || true && \
    wget https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 || \
    curl -fsSL https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 -o gosu-amd64 && \
    install -o root -g root -m 755 gosu-amd64 /usr/local/bin/gosu && \
    rm gosu-amd64 && \
    wget https://www.shore.co.il/blog/static/runas || \
    curl -fsSL https://www.shore.co.il/blog/static/runas -o runas && \
    install -o root -g root -m 755 runas /entrypoint && \
    rm runas
ENTRYPOINT [ "/entrypoint" ]
VOLUME /data
WORKDIR /data
ENV HOME /data
