ARG UBUNTU_TAG=20.04
FROM ubuntu:${UBUNTU_TAG}
LABEL maintainer="Dogukan Cagatay <dcagatay@gmail.com>"


ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    iputils-ping \
    iptables \
    apt-utils \
    xz-utils \
  && rm -rf /var/lib/apt/lists/*

ARG DOCKER_CHANNEL=stable
ARG DOCKER_VERSION=20.10.17
ARG DOCKER_COMPOSE_VERSION=2.9.0
ARG S6_OVERLAY_VERSION=3.1.1.2

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN ls -al /tmp; tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

# Install docker
RUN export CHANNEL=${DOCKER_CHANNEL}; \
  export VERSION=${DOCKER_VERSION}; \
  curl -fsSL --retry 3 https://get.docker.com | sh

ENV DOCKER_EXTRA_OPTS "--log-level=error --experimental"
# For more options: https://docs.docker.com/engine/reference/commandline/dockerd/
# e.g. --insecure-registry myregistry:5000 --registry-mirrors http://myregistry:5000

# Install dind hack script
RUN curl -fsSL --retry 3 "https://github.com/moby/moby/raw/v${DOCKER_VERSION}/hack/dind" -o /usr/local/bin/dind \
  && chmod a+x /usr/local/bin/dind

# Install docker-compose
RUN curl -fsSL --retry 3 "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose

COPY services.d /etc/services.d

VOLUME /var/lib/docker

ENTRYPOINT [ "/init" ]
