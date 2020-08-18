#!/usr/bin/env bash

echo "######## Fixing directories"
directories=("api/configuration" "etc" "logs" "queue" "agentless" "var/multigroups")
for dir in ${directories[@]}; do
    mkdir -p /data/${dir}
    cp -pr --no-clobber /defaults/var/ossec/${dir}/* /data/${dir} 2>/dev/null || :
    chown --reference /defaults/var/ossec/${dir} /data/${dir}
    chmod --reference /defaults/var/ossec/${dir} /data/${dir}
    if [[ $(echo ${dir} | tr -cd / | wc -c) -gt 0 ]]; then
        chown --reference /defaults/var/ossec/${dir}/.. /data/${dir}/..
        chmod --reference /defaults/var/ossec/${dir}/.. /data/${dir}/..
    fi
    rm -rf /var/ossec/${dir}
    ln -sfn /data/${dir} /var/ossec/${dir}
done

# echo "######## Setting API credentials"
# pushd /var/ossec/api/configuration/auth
# node htpasswd -b -c user $WAZUH_API_USER $WAZUH_API_PASS
# popd

# echo "######## Starting services with supervisord"
# exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
