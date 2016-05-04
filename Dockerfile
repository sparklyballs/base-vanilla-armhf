FROM vimagick/alpine-arm:3.3
MAINTAINER sparklyballs
ENV HOME="/root" TERM="xterm"
ARG BASE_LIST="bash curl nano tar tzdata unrar unzip wget xz"
# add packages
RUN apk add --update $BASE_LIST && \
apk add shadow --update-cache --repository http://nl.alpinelinux.org/alpine/edge/testing && \
rm -rf /var/cache/apk/*

# create mab user
RUN groupmod -g 1000 users && \
useradd -u 911 -U -d /config -s /bin/false mab && \
usermod -G users mab && \

# create some folders
mkdir -p /config /app /defaults

# s6 overlay
RUN curl -o /tmp/s6-overlay.tar.gz -L \
https://github.com/just-containers/s6-overlay/releases/download/v1.17.1.1/s6-overlay-amd64.tar.gz && \
tar xvfz /tmp/s6-overlay.tar.gz -C / && \
rm -f /tmp/s6-overlay.tar.gz && \
apk add --no-cache s6 s6-portable-utils && \
rm -rf /var/cache/apk/*

COPY root/ /
ENTRYPOINT ["/init"]
