FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.17

# hadolint ignore=DL3006
ARG BABYBUDDY_VERSION=1.16.0

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BABYBUDDY_VERSION=1.16.0
LABEL build_version="Build-date:- ${BUILD_DATE}"

ENV S6_STAGE2_HOOK="/init-hook"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
  build-base \
  jpeg-dev \
  libffi-dev \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  python3-dev \
  zlib-dev
RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
  jpeg \
  libffi \
  libpq \
  libxml2 \
  libxslt \
  py3-mysqlclient \
  python3
RUN \
  echo "**** install babybuddy ****" && \
  if [ -z ${BABYBUDDY_VERSION+x} ]; then \
  BABYBUDDY_VERSION=$(curl -sX GET "https://api.github.com/repos/babybuddy/babybuddy/releases/latest" \
  | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
  /tmp/babybuddy.tar.gz -L \
  "https://github.com/babybuddy/babybuddy/archive/refs/tags/${BABYBUDDY_VERSION}.tar.gz" && \
  mkdir -p /app/www/public && \
  tar xf \
  /tmp/babybuddy.tar.gz -C \
  /app/www/public --strip-components=1 && \
  cd /app/www/public && \
  python3 -m ensurepip && \
  pip3 install -U --no-cache-dir \
  pip \
  wheel && \
  pip3 install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.17/  -r requirements.txt
RUN \
  echo "**** cleanup ****" && \
  apk del --purge \
  build-dependencies && \
  rm -rf \
  /tmp/* \
  $HOME/.cache \
  $HOME/.cargo

# copy local files
COPY root/ /
# Build arguments
ARG BUILD_VERSION

# Labels
LABEL \
  io.hass.name="${BUILD_NAME}" \
  io.hass.description="${BUILD_DESCRIPTION}" \
  io.hass.arch="${BUILD_ARCH}" \
  io.hass.type="addon" \
  io.hass.version=${BUILD_VERSION}
