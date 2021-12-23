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
        unzip \
        curl \
        gosu \
        gnupg \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV AVIAN_VERSION=v3.1.0
ENV AVIAN_FILE_VERSION=v3-1-0

# Don't use base image's avian package for a few reasons:
# 1. Would need to use ppa/latest repo for the latest release.
# 2. Some package generates /etc/avian.conf on install and that's dangerous to bake in with Docker Hub.
# 3. Verifying pkg signature from main website should inspire confidence and reduce chance of surprises.
# Instead fetch, verify, and extract to Docker image
RUN cd /tmp \
    && curl -SLO https://github.com/AvianNetwork/Avian/releases/download/${AVIAN_VERSION}/AVN.Linux.${AVIAN_FILE_VERSION}.zip \
    && unzip -d /opt *.zip \
    && mv /opt/AVN\ Linux\ ${AVIAN_FILE_VERSION}/ /opt/avian-${AVIAN_VERSION} \
    && mkdir /opt/avian-${AVIAN_VERSION}/bin \
    && mv /opt/avian-${AVIAN_VERSION}/avian-${AVIAN_FILE_VERSION}-cli /opt/avian-${AVIAN_VERSION}/bin/avian-cli \
    && mv /opt/avian-${AVIAN_VERSION}/avian-${AVIAN_FILE_VERSION}-d /opt/avian-${AVIAN_VERSION}/bin/aviand \
    && rm /opt/avian-${AVIAN_VERSION}/avian-${AVIAN_FILE_VERSION}-qt \
    && chmod +x /opt/avian-${AVIAN_VERSION}/bin/* \
    && ln -sv avian-${AVIAN_VERSION} /opt/avian 



FROM ubuntu:latest
LABEL maintainer="Craig Donnachie <craig.donnachie@gmail.com>"

ENTRYPOINT ["docker-entrypoint.sh"]
ENV HOME /avian
EXPOSE 7894 7895
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
