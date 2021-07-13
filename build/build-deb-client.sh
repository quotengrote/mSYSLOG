#!/bin/bash
# Setze Variablen
PACKAGE_NAME=msyslog-client

# Installiere benötigte Pakete
# sudo apt install dpkg -y

# Erstelle Ordnerstruktur
mkdir -p ./$PACKAGE_NAME
mkdir -p ./$PACKAGE_NAME/DEBIAN
mkdir -p ./$PACKAGE_NAME/etc/
mkdir -p ./$PACKAGE_NAME/usr/local/sbin

# kopiere Dateien an vorgesehe Verzeichnisse im Zielsystem
cp ../client/dpkg-deb-controlfile ./$PACKAGE_NAME/DEBIAN/control
cp ../client/msyslog-client.sh ./$PACKAGE_NAME/usr/local/sbin/$PACKAGE_NAME.sh
cp ../client/msyslog-client.conf ./$PACKAGE_NAME/etc/$PACKAGE_NAME.conf
cp ../client/dpkg-deb-postinst ./$PACKAGE_NAME/DEBIAN/postinst

# Setze Rechte für postinst-Script
chmod 0755 ./$PACKAGE_NAME/DEBIAN/postinst

# Wechsel in "build"-Verzeichnis
cd ./$PACKAGE_NAME

# baue deb
dpkg-deb --build . $PACKAGE_NAME.deb

# verschiebe gebautes Paket
mv $PACKAGE_NAME.deb ../$PACKAGE_NAME.deb

# Lösche "build"-Verzeichnis
cd ..
# rm -rf ./$PACKAGE_NAME
