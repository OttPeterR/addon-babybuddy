#!/command/with-contenv bashio

mkdir -p /config/{data,media}
rm -rf /app/babybuddy/{data,media}
#ln -s /config/data /app/babybuddy/data
#ln -s /config/media /app/babybuddy/media

mkdir -p /data/{data,media}
ln -s /data/data /config/data
ln -s /data/data /app/babybuddy/data
ln -s /data/media /config/media
ln -s /data/media /app/babybuddy/media
#TODO: need to properly link  /config/.secretkey

cd /app/babybuddy
if [ ! -f "/config/.secretkey" ]; then
    echo "**** No secret key found, generating one ****"
    python3 manage.py shell -c 'from django.core.management import utils; print(utils.get_random_secret_key())' \
        | tr -d '\n' > /config/.secretkey
fi
export \
    DJANGO_SETTINGS_MODULE="babybuddy.settings.base" \
    ALLOWED_HOSTS="${ALLOWED_HOSTS:-*}" \
    TIME_ZONE="${TZ:-UTC}" \
    DEBUG="${DEBUG:-False}" \
    SECRET_KEY="${SECRET_KEY:-`cat /config/.secretkey`}"
python3 manage.py migrate --noinput 
python3 manage.py createcachetable

chown -R root:root \
    /config
