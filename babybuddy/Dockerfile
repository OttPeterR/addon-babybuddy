ARG BUILD_FROM=ghcr.io/hassio-addons/base:20.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Optional: BABYBUDDY_GIT_REF + BABYBUDDY_GIT_URL clone that ref instead of the
# v2.9.2 tarball (build.yaml `args` or docker --build-arg). Leave unset for release builds.
ARG BABYBUDDY_GIT_REF=
ARG BABYBUDDY_GIT_URL=https://github.com/babybuddy/babybuddy.git

VOLUME ["/run"]

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
  if [[ -n "${BABYBUDDY_GIT_REF}" ]]; then \
    apk add --no-cache git && \
    echo "**** cloning babybuddy (${BABYBUDDY_GIT_REF}) ****" && \
    git clone --branch "${BABYBUDDY_GIT_REF}" --depth 1 "${BABYBUDDY_GIT_URL}" /tmp/babybuddy-src && \
    mkdir -p /app/babybuddy && \
    cp -a /tmp/babybuddy-src/. /app/babybuddy/ && \
    rm -rf /tmp/babybuddy-src && \
    apk del --no-cache git; \
  else \
    echo "**** downloading babybuddy v2.9.2 tarball ****" && \
    curl -o \
    /tmp/babybuddy.tar.gz -L \
    "https://github.com/babybuddy/babybuddy/archive/refs/tags/v2.9.2.tar.gz" && \
    mkdir -p /app/babybuddy && \
    tar xf \
    /tmp/babybuddy.tar.gz -C \
    /app/babybuddy --strip-components=1; \
  fi

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
