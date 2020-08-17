#!/bin/bash

echo "######## Setting API credentials"
pushd /var/ossec/api/configuration/auth
node htpasswd -b -c user $WAZUH_API_USER $WAZUH_API_PASS
popd

echo "######## Making resolv-conf script executable"
chmod +x /etc/openvpn/update-resolv-conf

echo "######## Change UID/GID for qbittorent user"
groupmod -o -g "${PGID}" qbittorrent
usermod -o -u "${PUID}" qbittorrent
chown -R qbittorrent:qbittorrent /config

echo "######## Starting services with supervisord"
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf