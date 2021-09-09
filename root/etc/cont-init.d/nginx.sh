#!/usr/bin/with-contenv bashio
declare port
declare ingress_interface
declare ingress_port
declare ingress_entry

port=$(bashio::addon.port 80)
ingress_entry=$(bashio::addon.ingress_entry)
ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/templates/ingress.gtpl
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/templates/ingress.gtpl
sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/templates/ingress.gtpl



bashio::var.json \
    entry "$(bashio::addon.ingress_entry)" \
    | tempio \
        -template /etc/nginx/templates/ingress.gtpl \
        -out /etc/nginx/servers/ingress.conf

