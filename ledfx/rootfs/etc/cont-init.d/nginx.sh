#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: ledfx
# Configures NGINX
# ==============================================================================
declare port
declare certfile
declare dns_host
declare ingress_interface
declare keyfile

port=$(bashio::addon.port 80)
if bashio::var.has_value "${port}"; then
    bashio::config.require.ssl

    if bashio::config.true 'ssl'; then
        certfile=$(bashio::config 'certfile')
        keyfile=$(bashio::config 'keyfile')

        mv /etc/nginx/servers/direct-ssl.disabled /etc/nginx/servers/direct.conf
        sed -i "s#%%certfile%%#${certfile}#g" /etc/nginx/servers/direct.conf
        sed -i "s#%%keyfile%%#${keyfile}#g" /etc/nginx/servers/direct.conf

    else
        mv /etc/nginx/servers/direct.disabled /etc/nginx/servers/direct.conf
    fi
fi

ingress_interface=$(bashio::addon.ip_address)
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf

dns_host=$(bashio::dns.host)
sed -i "s/%%dns_host%%/${dns_host}/g" /etc/nginx/includes/resolver.conf
