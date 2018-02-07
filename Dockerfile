ARG image
FROM ${image}
RUN if command -v apt-get; \
    then \
        apt-get update && apt-get install -y sudo; \
    elif command -v yum; \
    then \
        yum install -y sudo; \
    elif command -v apk; \
    then \
        apk add --update --no-cache sudo; \
    elif command -v dnf; \
    then \
        dnf install -y sudo; \
    fi
ARG userland
ADD [ "https://www.shore.co.il/blog/static/runas-${userland}", "/entrypoint"]
ENTRYPOINT [ "/bin/sh", "/entrypoint" ]
VOLUME /volume
WORKDIR /volume
ENV HOME /volume
