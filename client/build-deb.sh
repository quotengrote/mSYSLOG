#!/bin/bash
VERSION="0.0.2"
PAKETNAME="msyslog-client"
ORDNERNAME=

sudo apt-get install dh-make devscripts


mkdir -p $PAKETNAME-$VERSION
cd $PAKETNAME-$VERSION
dh_make --indep --createorig
mv debian/rules.new debian/rules
# Pfade Dateien
echo msyslog-client.sh usr/local/sbin > debian/install
echo msyslog-client.conf etc > debian/install

echo "1.0" > debian/source/format
rm debian/*.ex
debuild -us -uc
