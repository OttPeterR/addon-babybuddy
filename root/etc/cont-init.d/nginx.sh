#!/usr/bin/with-contenv bashio
bashio::var.json \
    entry "$(bashio::addon.ingress_entry)" \
    | tempio \
        -template /etc/nginx/templates/ingress.gtpl \
        -out /etc/nginx/servers/ingress.conf
