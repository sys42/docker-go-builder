FROM sys42/docker-base:1.1.0

MAINTAINER Tom Nussbaumer <thomas.nussbaumer@gmx.net>

RUN export DOCKER_VERSION="1.8.1" && set -ex \
 && export DEBIAN_FRONTEND=noninteractive && apt-get update \
 && apt-get install -y --no-install-recommends git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && cd /usr/local \
 && curl https://storage.googleapis.com/golang/go1.5.linux-amd64.tar.gz | tar xz \
 && ln -s /usr/local/go/bin/go /bin/go \
 && ln -s /usr/local/go/bin/godoc /bin/godoc \
 && ln -s /usr/local/go/bin/gofmt /bin/gofmt \
 && curl --output /bin/docker https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION} \
 && chmod +x /bin/docker \
 && mkdir /go \
 && chown app:app /go

ADD goexec /sbin/

# having something here if the user doesn't pass it in
WORKDIR /app

# ENTRYPOINT ["/sbin/my_init", "--"]
