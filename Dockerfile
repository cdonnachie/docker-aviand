# Smallest base image, latests stable image
# Alpine would be nice, but it's linked again musl and breaks the avian core download binary
#FROM alpine:latest

FROM ubuntu:latest as builder

# Testing: gosu
#RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories \
#    && apk add --update --no-cache gnupg gosu gcompat libgcc
RUN apt update \
    && apt install -y --no-install-recommends \
        ca-certificates \
        wget \
        gnupg \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG VERSION=22.0
ARG ARCH=x86_64
ARG BITCOIN_CORE_SIGNATURE=71A3B16735405025D447E8F274810B012346C9A6

# Don't use base image's avian package for a few reasons:
# 1. Would need to use ppa/latest repo for the latest release.
# 2. Some package generates /etc/avian.conf on install and that's dangerous to bake in with Docker Hub.
# 3. Verifying pkg signature from main website should inspire confidence and reduce chance of surprises.
# Instead fetch, verify, and extract to Docker image
RUN cd /tmp \
    && gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys ${BITCOIN_CORE_SIGNATURE} \
    && wget https://aviancore.org/bin/avian-core-${VERSION}/SHA256SUMS.asc \
        https://aviancore.org/bin/avian-core-${VERSION}/SHA256SUMS \
        https://aviancore.org/bin/avian-core-${VERSION}/avian-${VERSION}-${ARCH}-linux-gnu.tar.gz \
    && gpg --verify --status-fd 1 --verify SHA256SUMS.asc SHA256SUMS 2>/dev/null | grep "^\[GNUPG:\] VALIDSIG.*${BITCOIN_CORE_SIGNATURE}\$" \
    && sha256sum --ignore-missing --check SHA256SUMS \
    && tar -xzvf avian-${VERSION}-${ARCH}-linux-gnu.tar.gz -C /opt \
    && ln -sv avian-${VERSION} /opt/avian \
    && /opt/avian/bin/test_avian --show_progress \
    && rm -v /opt/avian/bin/test_avian /opt/avian/bin/avian-qt

FROM ubuntu:latest
LABEL maintainer="Kyle Manna <kyle@donnacc.com>"

ENTRYPOINT ["docker-entrypoint.sh"]
ENV HOME /avian
EXPOSE 8332 8333
VOLUME ["/avian/.avian"]
WORKDIR /avian

ARG GROUP_ID=1000
ARG USER_ID=1000
RUN groupadd -g ${GROUP_ID} avian \
    && useradd -u ${USER_ID} -g avian -d /avian avian

COPY --from=builder /opt/ /opt/

RUN apt update \
    && apt install -y --no-install-recommends gosu \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && ln -sv /opt/avian/bin/* /usr/local/bin

COPY ./bin ./docker-entrypoint.sh /usr/local/bin/

CMD ["avn_oneshot"]
