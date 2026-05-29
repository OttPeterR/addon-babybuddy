# CHANGELOG

## 2.9.2
### ⬆️ Updated
- Bumps bundled Baby Buddy to [2.9.2](https://github.com/babybuddy/babybuddy/releases/tag/v2.9.2) (from 2.8.0; includes upstream 2.9.0, 2.9.1, and 2.9.2).
### 🆕 Added
- Medication/medicine tracking (upstream [#1036](https://github.com/babybuddy/babybuddy/pull/1036)).
- Korean (ko) translations (upstream [#1028](https://github.com/babybuddy/babybuddy/pull/1028)).
- Recent Pumpings dashboard widget (upstream [#1040](https://github.com/babybuddy/babybuddy/pull/1040)).
### 🐞 Fixed
- XFF (X-Forwarded-For) header processing when behind a reverse proxy (upstream [#997](https://github.com/babybuddy/babybuddy/pull/997), [#1061](https://github.com/babybuddy/babybuddy/pull/1061)).
- Japanese (ja) translation corrections (upstream [#1055](https://github.com/babybuddy/babybuddy/pull/1055)).

## 2.8.0
### ⬆️ Updated
- Bumps bundled Baby Buddy to [2.8.0](https://github.com/babybuddy/babybuddy/releases/tag/v2.8.0).

## 2.7.2
### 🚨 Breaking
- **armhf, armv7, and i386 builds are deprecated** and are no longer built in
  CI or release workflows.
  Home Assistant Community Add-ons dropped those architectures in base image
  [v19.0.0](https://github.com/hassio-addons/app-base/releases/tag/v19.0.0).
  The addon base image is now aligned with supported platforms (e.g. aarch64,
  amd64); users on dropped hardware need an older addon release or a
  supported board.
### ⬆️ Updated
- Addon version bump; still bundles Baby Buddy
  [2.7.1](https://github.com/babybuddy/babybuddy/releases/tag/v2.7.1).
- Bumped hassio addon base image to
  [20.0.1](https://github.com/hassio-addons/app-base/releases/tag/v20.0.1)
  so container builds resolve current Alpine/OpenSSL packages and CI tests
  can run.
- CI “Build Addon” workflow now only builds **aarch64** and **amd64** (see
  breaking note above).
- `babybuddy/config.yaml` lists only **aarch64** and **amd64** under `arch`
  (see breaking note).
- `babybuddy/build.yaml` `build_from` lists only **aarch64** and **amd64**
  (see breaking note).
- `publish-container` workflow publishes only **aarch64** and **amd64** (see
  breaking note).
### 🐞 Fixed
- Store Django `SECRET_KEY` in `/data/.secretkey` (persistent volume) instead
  of `/config/.secretkey`, which can be ephemeral on Home Assistant. This keeps
  sessions and CSRF cookies stable across restarts—needed for reliable Ingress
  testing and aligns with Home Assistant persistent-storage expectations.
- Trust reverse-proxy headers (`SECURE_PROXY_SSL_HEADER`, forwarded host/port)
  and normalize `CSRF_TRUSTED_ORIGINS` from the environment with trimmed,
  comma-separated segments (`babybuddy/settings/homeassistant.py`). Builds on
  Intecpsp PR #87.
- Reject `CSRF_TRUSTED_ORIGINS` entries missing `http://` or `https://`
  before Gunicorn starts (`etc/services.d/babybuddy/run`), with a clear error
  in the add-on log.
- Optional Docker build-args `BABYBUDDY_GIT_REF` and `BABYBUDDY_GIT_URL`
  (`Dockerfile`) clone a Git ref instead of the v2.7.1 tarball for local or
  pre-release Baby Buddy builds.

## 2.7.1
### ⬆️ Updated
- Updated to Baby Buddy [2.7.1](https://github.com/babybuddy/babybuddy/releases/tag/v2.7.1)
### 🐞 Fixed
- [Custom child images](https://github.com/OttPeterR/addon-babybuddy/pull/84)

## 2.7.0
### ⬆️ Updated
- Updated to Baby Buddy [2.7.0](https://github.com/babybuddy/babybuddy/releases/tag/v2.7.0)

## 2.6.3
### ⬆️ Updated
- Updated to Baby Buddy [2.6.3](https://github.com/babybuddy/babybuddy/releases/tag/v2.6.3)

## 2.6.2
### ⬆️ Updated
- Updated to Baby Buddy [2.6.2](https://github.com/babybuddy/babybuddy/releases/tag/v2.6.2)
- Updated add on base to [16.3.4](https://github.com/hassio-addons/addon-base/releases/tag/v16.3.4)

## 2.2.1.1
### ⬆️ Updated
- Fix for notifications that keep coming back

## 2.2.1

### ⬆️ Updated
- Baby Buddy to 2.2.1 [release notes](https://github.com/babybuddy/babybuddy/releases/tag/v2.2.1)
- HA HAddon base to 15.0.6

## 2.2.0

### 🆕 Added
- this nifty changelog

### ⬆️ Updated
- Baby Buddy to 2.2.0 [release notes](https://github.com/babybuddy/babybuddy/releases/tag/v2.2.0)
- HA Addon base to 15.0.5 [release notes](https://github.com/hassio-addons/addon-base/releases/tag/v15.0.5)
