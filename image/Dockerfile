FROM sys42/docker-base:1.1.0

MAINTAINER Tom Nussbaumer <thomas.nussbaumer@gmx.net>

RUN export DOCKER_VERSION="1.8.1" \
 && export DOCKER_DOWNLOAD_URL="https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}" \
 && export GOLANG_VERSION=1.5 \
 && export GOLANG_DOWNLOAD_URL="https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz" \
 && export GOLANG_DOWNLOAD_SHA1="5817fa4b2252afdb02e11e8b9dc1d9173ef3bd5a" \
 && export DEBIAN_FRONTEND=noninteractive \
 && set -ex \
 && apt-get update \
 && apt-get install -y --no-install-recommends git mercurial make \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
 && echo "$GOLANG_DOWNLOAD_SHA1  golang.tar.gz" | sha1sum -c - \
 && tar -C /usr/local -xzf golang.tar.gz \
 && rm golang.tar.gz \
 && curl --output /bin/docker "$DOCKER_DOWNLOAD_URL" \
 && chmod +x /bin/docker

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" \
 && go get github.com/tools/godep \
 && go get github.com/robfig/glock \
 && chmod -R 777 "$GOPATH"

COPY goenv /sbin/

WORKDIR $GOPATH

# ENTRYPOINT ["/sbin/my_init", "--"]

