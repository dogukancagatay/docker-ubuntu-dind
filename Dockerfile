ARG UBUNTU_TAG=18.04
FROM ubuntu:${UBUNTU_TAG}
LABEL maintainer="Dogukan Cagatay <dcagatay@gmail.com>"

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    iputils-ping \
    iptables \
  && rm -rf /var/lib/apt/lists/*

ARG DOCKER_CHANNEL=stable
ARG DOCKER_VERSION=20.10.7

# Install docker
RUN export CHANNEL=${DOCKER_CHANNEL}; \
  export VERSION=${DOCKER_VERSION}; \
  curl -fsSL --retry 3 https://get.docker.com | sh

ENV DOCKER_EXTRA_OPTS "--log-level=error --experimental"
# For more options: https://docs.docker.com/engine/reference/commandline/dockerd/
# e.g. --insecure-registry myregistry:5000 --registry-mirrors http://myregistry:5000

# Install dind hack script
ARG DIND_COMMIT=42b1175eda071c0e9121e1d64345928384a93df1
RUN curl -fsSL --retry 3 "https://raw.githubusercontent.com/moby/moby/${DIND_COMMIT}/hack/dind" -o /usr/local/bin/dind \
  && chmod a+x /usr/local/bin/dind

# Install docker-compose
ARG DOCKER_COMPOSE_VERSION=1.29.2
RUN curl -fsSL --retry 3 "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose

COPY services.d /etc/services.d

VOLUME /var/lib/docker

ENTRYPOINT [ "/init" ]
