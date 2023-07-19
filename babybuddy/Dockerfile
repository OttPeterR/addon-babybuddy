# match the below with build.yaml
ARG BUILD_FROM=ghcr.io/hassio-addons/base:14.0.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

VOLUME ["/run"]

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3003
RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
  build-base \
  curl \
  jpeg-dev \
  libffi-dev \
  libxml2-dev \
  libxslt-dev \
  mariadb-dev \
  postgresql-dev \
  python3-dev \
  zlib-dev

# hadolint ignore=DL3003
RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
  jpeg \
  libffi \
  libpq \
  libxml2 \
  libxslt \
  mariadb-connector-c \
  python3

RUN \
  echo "**** downloading ****" \
  curl -o \
  /tmp/babybuddy.tar.gz -L \
  "https://github.com/babybuddy/babybuddy/archive/refs/tags/2.0.2.tar.gz"
RUN \
  echo "**** installing ****" \
  mkdir -p /app/www/public && \
  tar xf \
  /tmp/babybuddy.tar.gz -C \
  /app/www/public --strip-components=1 && \
  cd /app/www/public && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir \
  pip \
  wheel && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.18/ \
  -r requirements.txt && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.18/ \
  mysqlclient
RUN \
  echo "**** cleanup ****" && \
  apk del --purge \
  build-dependencies && \
  rm -rf \
  /tmp/* \
  $HOME/.cache \
  $HOME/.cargo

COPY root /

# Build arguments
ARG BUILD_VERSION

# Labels
LABEL \
  io.hass.name="${BUILD_NAME}" \
  io.hass.description="${BUILD_DESCRIPTION}" \
  io.hass.arch="${BUILD_ARCH}" \
  io.hass.type="addon" \
  io.hass.version=${BUILD_VERSION}
