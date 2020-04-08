#!/bin/bash

parameterErrorMessage="Requires at least 3 arguments: serverName, domainName, ipv4"
if [ -z "$1" ]; then
    echo "$parameterErrorMessage"
    exit 1
fi
if [ -z "$2" ]; then
    echo "$parameterErrorMessage"
    exit 1
fi
if [ -z "$3" ]; then
    echo "$parameterErrorMessage"
    exit 1
fi

serverName=$1
domainName=$2
ipv4Entry="$3 $domainName"
if [ -z "$4" ]; then
  ipv6Entry=""
else
  ipv6Entry="$4 $domainName"
fi

# Append
cat >>/etc/pihole/local.list <<EOL
# Server $serverName
$ipv4Entry
$ipv6Entry
EOL
