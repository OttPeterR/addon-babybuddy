ARG BUILD_FROM=ghcr.io/hassio-addons/base/armv7:10.0.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    build-base \
    curl \
    jpeg-dev \
    libffi-dev \
    postgresql-dev \
    python3-dev \
    zlib-dev

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    jpeg \
    libffi \
    libpq \
    py3-pip \
    python3

RUN \
  echo "**** downloading babybuddy ****" && \
  curl -o \
    /tmp/babybuddy.tar.gz -L \
    "https://github.com/babybuddy/babybuddy/archive/refs/tags/v1.8.2.tar.gz" && \
  mkdir -p /app/babybuddy && \
  tar xf \
    /tmp/babybuddy.tar.gz -C \
    /app/babybuddy --strip-components=1 

RUN \
  echo "**** installing babybuddy ****" && \
  cd /app/babybuddy && \
  pip3 install -U --no-cache-dir \
    pip && \
  pip install -U --ignore-installed -r requirements.txt

RUN \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/* \
    /root/.cache

COPY root/ /

EXPOSE 8000
VOLUME /config

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
