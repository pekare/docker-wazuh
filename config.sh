#!/usr/bin/env bash

mkdir /defaults
directories=("api/configuration" "etc" "logs" "queue" "agentless" "var/multigroups")
for dir in ${directories[@]}; do
    cp -pr --parents /var/ossec/${dir} /defaults/
done
