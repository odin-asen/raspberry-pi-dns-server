#!/bin/bash

hostIPv4=192.168.0.250
hostIPv6=
scriptBase=/home/pi
configBase=/etc/lighttpd
customConfigBase=$configBase/custom-apps
appName=$1
domain=$2
documentRootBase=/home/pi/custom-web-apps
documentRoot=$documentRootBase/$1

echo export environment variables for app "$appName"
export APP_DOCUMENT_ROOT=$documentRoot
export APP_HOST_NAME=$domain
printenv | grep APP_
echo ===============

echo generate web server config
mkdir -p $customConfigBase
envsubst "$APP_HOST_NAME:$APP_DOCUMENT_ROOT" < $scriptBase/app.conf.template > $customConfigBase/"$appName".conf
echo ===============

echo create document root on "$documentRoot"
mkdir -p "$documentRoot"
echo ===============

echo modify external.conf
cp $configBase/external.conf $configBase/external.conf.bak
echo "include \"$customConfigBase/$appName.conf\"" >> $configBase/external.conf
echo ===============

echo add domain to pihole local.list
$scriptBase/add-local-domain.sh "$APP_DOCUMENT_ROOT" "$APP_HOST_NAME" $hostIPv4 $hostIPv6
echo ===============

echo Remove environment variables
unset APP_DOCUMENT_ROOT
unset APP_HOST_NAME
echo ===============

echo webserver config folder: $configBase
ls -la $configBase
echo ===============

echo document root folder: $documentRootBase
ls -la $documentRootBase
echo ===============

echo Check external conf and list.local
nano $configBase/external.conf
nano /etc/pihole/local.list
echo Done. Now restart the webserver and DNS Resolver in pi-hole.
