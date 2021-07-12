#!/bin/bash
mkdir -p ./msyslog-client
mkdir -p ./msyslog-client/usr/local/sbin
mkdir -p ./msyslog-client/etc
cp ./client/msyslog-client.sh ./msyslog-client/usr/local/sbin/msyslog-client.sh
cp ./client/msyslog-client.conf ./msyslog-client/etc/msyslog-client.sh
dpkg-deb --build ./msyslog-client
