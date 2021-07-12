#!/bin/bash
mkdir -p ./msyslog-client_$GITHUB_SHA
mkdir -p ./msyslog-client_$GITHUB_SHA/usr/local/sbin
mkdir -p ./msyslog-client_$GITHUB_SHA/etc
cp ./client/msyslog-client.sh ./msyslog-client_$GITHUB_SHA/usr/local/sbin/msyslog-client.sh
cp ./client/msyslog-client.conf ./msyslog-client_$GITHUB_SHA/etc/msyslog-client.sh
dpkg-deb --build ./msyslog-client_$GITHUB_SHA
