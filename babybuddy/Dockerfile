ARG BUILD_FROM=ghcr.io/hassio-addons/base:17.2.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

VOLUME ["/run"]

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
  echo "**** downloading babybuddy ****" && \
  curl -o \
  /tmp/babybuddy.tar.gz -L \
  "https://github.com/babybuddy/babybuddy/archive/refs/tags/v2.7.1.tar.gz" && \
  mkdir -p /app/babybuddy && \
  tar xf \
  /tmp/babybuddy.tar.gz -C \
  /app/babybuddy --strip-components=1

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
  py3-mysqlclient \
  py3-pip \
  python3 \
  nginx \
  rust \
  cargo

# Define PATH_MAX before including necessary headers
RUN echo '#define PATH_MAX 4096' >> /usr/include/limits.h

# Install dependencies
RUN echo "**** installing ****" && \
  cd /app/babybuddy && \
  pip3 install -U --no-cache-dir pip && \
  CFLAGS="-DPATH_MAX=4096" pip install -U --ignore-installed --prefer-binary -r requirements.txt

RUN \
  echo "**** cleanup ****" && \
  apk del --purge \
  build-dependencies && \
  rm -rf \
  /etc/nginx \
  /opt/build \
  /opt/index.html \
  /opt/package.sh \
  /opt/src \
  /opt/static \
  /opt/stylesheets \
  /opt/.[!.]* \
  /opt/*.md \
  /opt/nodemon.json \
  /opt/kustomization.yaml \
  /opt/kubernetes \
  /opt/docker \
  /opt/docs \
  /root/.cache \
  /root/.config \
  /root/.npmrc \
  /root/.node-gyp \
  /root/.npm \
  /tmp/.[!.]* \
  /tmp/* \
  /usr/lib/node_modules \
  /usr/local/share/.cache

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
