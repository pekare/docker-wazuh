FROM debian:latest

ARG WAZUH_VERSION=3.13.1-1

COPY entrypoint.sh /

RUN apt-get update && \
    apt-get update -y && \
    apt-get install -y curl ca-certificates apt-transport-https lsb-release gnupg2 procps && \
    curl https://packages.wazuh.com/key/GPG-KEY-WAZUH -o /tmp/GPG-KEY-WAZUH && \
    apt-key add /tmp/GPG-KEY-WAZUH && \
    echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list && \
    curl -sL https://deb.nodesource.com/setup_10.x -o /tmp/setup_10.sh && \
    bash /tmp/setup_10.sh && \
    apt-get update && \
    apt-get install -y wazuh-manager=${WAZUH_VERSION} wazuh-api=${WAZUH_VERSION} && \
    rm -f /var/ossec/logs/alerts/*/*/*.log && \
    rm -f /var/ossec/logs/alerts/*/*/*.json && \
    rm -f /var/ossec/logs/archives/*/*/*.log && \
    rm -f /var/ossec/logs/archives/*/*/*.json && \
    rm -f /var/ossec/logs/firewall/*/*/*.log && \
    rm -f /var/ossec/logs/firewall/*/*/*.json && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    chmod +x /entrypoint.sh



DATA_DIRS[((i++))]="api/configuration"
DATA_DIRS[((i++))]="etc"
DATA_DIRS[((i++))]="logs"
DATA_DIRS[((i++))]="queue"
DATA_DIRS[((i++))]="agentless"
DATA_DIRS[((i++))]="var/multigroups"


check if data dirs exist on volume
directories=("api/configuration" "etc" "logs" "queue" "agentless" "var/multigroups")
for dir in ${directories[@]}; do
    test
done
create if they do not exist volume
symlink data dir on volume
ln -sfn /new/target /path/to/symlink


Restore configuration. Before you attempt restoration make sure the Manager is stopped in the new server.

    cp -p /var/ossec_backup/etc/client.keys /var/ossec/etc/
    cp -p /var/ossec_backup/etc/ossec.conf /var/ossec/etc/
    cp -p /var/ossec_backup/queue/rids/sender_counter /var/ossec/queue/rids/sender_counter
   
    If you have made local changes to any of the following then also restore:

    cp -p /var/ossec_backup/etc/local_internal_options.conf /var/ossec/etc/local_internal_options.conf
    cp -p /var/ossec_backup/rules/local_rules.xml /var/ossec/etc/rules/local_rules.xml
    cp -p /var/ossec_backup/etc/local_decoder.xml /var/ossec/etc/decoders/local_decoder.xml

    If you have the centralized configuration you must restore:
   
    cp -p /var/ossec_backup/etc/shared/agent.conf /var/ossec/etc/shared/default/agent.conf

    Optionally the following files can be restored to preserve alert log files and syscheck/rootcheck databases:

    cp -rp /var/ossec_backup/logs/archives/* /var/ossec/logs/archives
    cp -rp /var/ossec_backup/logs/alerts/* /var/ossec/logs/alerts
    cp -rp /var/ossec_backup/queue/rootcheck/* /var/ossec/queue/rootcheck
    cp -rp /var/ossec_backup/queue/syscheck/* /var/ossec/queue/syscheck

4. Start Wazuh Manager service

5. Change agents ip address to point to new Wazuh manager ip and restart the agents.

# VOLUME ["/config", "/downloads"]
# EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
