#!/bin/bash
mkdir -p ./msyslog-client_$COMMIT_HASH
mkdir -p ./msyslog-client_$COMMIT_HASH/usr/local/sbin
mkdir -p ./msyslog-client_$COMMIT_HASH/etc
cp ./client/msyslog-client.sh ./msyslog-client_$COMMIT_HASH/usr/local/sbin/msyslog-client.sh
cp ./client/msyslog-client.conf ./msyslog-client_$COMMIT_HASH/etc/msyslog-client.sh
dpkg-deb --build ./msyslog-client_$COMMIT_HASH
