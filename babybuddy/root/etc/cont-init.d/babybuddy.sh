#!/command/with-contenv bashio
# shellcheck shell=bash

# CSRF_TRUSTED_ORIGINS must fail in cont-init (once), not in services.d/run — otherwise
# s6-supervise restarts the service in a loop on bashio::exit.nok.

babybuddy_csrf_option_present() {
    [[ "${1}" == *[![:space:]]* ]]
}

babybuddy_csrf_segment_is_blank() {
    [[ -z "${1// }" ]]
}

babybuddy_csrf_require_valid_schemes() {
    local raw="$1"
    local segment
    local segment_lower
    local -a segments

    IFS=',' read -ra segments <<< "${raw}"
    for segment in "${segments[@]}"; do
        babybuddy_csrf_segment_is_blank "${segment}" && continue
        segment_lower="${segment,,}"
        if ! [[ "${segment_lower}" =~ ^[[:space:]]*https?:// ]]; then
            bashio::log.error \
                "Baby Buddy add-on: each CSRF_TRUSTED_ORIGINS value must include http:// or https:// (comma-separated, no spaces)."
            bashio::log.error "Invalid entry: ${segment}"
            bashio::exit.nok
        fi
    done
}

csrf_raw="$(bashio::config 'CSRF_TRUSTED_ORIGINS')"
if babybuddy_csrf_option_present "${csrf_raw}"; then
    babybuddy_csrf_require_valid_schemes "${csrf_raw}"
fi

mkdir -p /config/{data,media}
rm -rf /app/babybuddy/{data,media}
#ln -s /config/data /app/babybuddy/data
#ln -s /config/media /app/babybuddy/media

mkdir -p /data/{data,media}
ln -s /data/data /config/data
ln -s /data/data /app/babybuddy/data
ln -s /data/media /config/media
ln -s /data/media /app/babybuddy/media

# Django SECRET_KEY must live on the Supervisor persistent volume (/data), not under
# /config (often ephemeral). A new key every start breaks sessions and CSRF cookies.
secret_key_file="/data/.secretkey"
if [ -f "/config/.secretkey" ] && [ ! -f "${secret_key_file}" ]; then
    mv /config/.secretkey "${secret_key_file}"
fi
cd /app/babybuddy || exit
if [ ! -f "${secret_key_file}" ]; then
    echo "**** No secret key found, generating one ****"
    python3 manage.py shell -c 'from django.core.management import utils; print(utils.get_random_secret_key())' \
        | tr -d '\n' > "${secret_key_file}"
fi
export \
    DJANGO_SETTINGS_MODULE="babybuddy.settings.homeassistant" \
    ALLOWED_HOSTS="${ALLOWED_HOSTS:-*}" \
    TIME_ZONE="${TZ:-UTC}" \
    DEBUG="${DEBUG:-False}" \
    SECRET_KEY="${SECRET_KEY:-$(cat "${secret_key_file}")}"
python3 manage.py collectstatic --noinput
python3 manage.py createcachetable
python3 manage.py migrate --noinput

chown -R root:root \
    /config
