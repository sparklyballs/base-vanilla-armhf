FROM vimagick/alpine-arm:3.4
MAINTAINER sparklyballs

# set some environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)$ " \
HOME="/root" \
TERM="xterm"

# add packages
RUN \
apk add --no-cache \
	bash \
	curl \
	nano \
	tar \
	tzdata \
	unrar \
	unzip \
	wget \
	xz && \

apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing \
	shadow && \

# clean up
rm -rf /var/cache/apk/*

# create mab user
RUN \
	groupmod -g 1000 users && \
	useradd -u 911 -U -d /config -s /bin/false mab && \
	usermod -G users mab && \

# create some folders
	mkdir -p /config /app /defaults


# add s6 overlay
RUN \
 curl -o /tmp/s6-overlay.tar.gz -L \
	https://github.com/just-containers/s6-overlay/releases/download/v1.17.1.1/s6-overlay-amd64.tar.gz && \
 tar xvfz /tmp/s6-overlay.tar.gz -C / && \

 apk add --update \
	s6 \
	s6-portable-utils && \

rm -rf /var/cache/apk/* /tmp/*

# add local files
COPY root/ /

ENTRYPOINT ["/init"]


