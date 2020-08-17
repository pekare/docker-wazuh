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



# VOLUME ["/config", "/downloads"]
# EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]