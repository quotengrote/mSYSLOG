#!/bin/bash
# Setze Variablen
PACKAGE_NAME=msyslog-client
BUILD_DIR=$GITHUB_WORKSPACE/$PACKAGE_NAME

# Installiere benötigte Pakete
# sudo apt install dpkg -y

# Erstelle Ordnerstruktur
mkdir -p $BUILD_DIR
mkdir -p $BUILD_DIR/DEBIAN
mkdir -p $BUILD_DIR/etc/
mkdir -p $BUILD_DIR/usr/local/sbin

# kopiere Dateien an vorgesehe Verzeichnisse im Zielsystem
cp $GITHUB_WORKSPACE/client/dpkg-deb-controlfile $BUILD_DIR/DEBIAN/control
cp $GITHUB_WORKSPACE/client/msyslog-client.sh $BUILD_DIR/usr/local/sbin/$PACKAGE_NAME.sh
cp $GITHUB_WORKSPACE/client/msyslog-client.conf $BUILD_DIR/etc/$PACKAGE_NAME.conf
cp $GITHUB_WORKSPACE/client/dpkg-deb-postinst $BUILD_DIR/DEBIAN/postinst

# Setze Rechte für postinst-Script
chmod 0755 $BUILD_DIR/DEBIAN/postinst

# Wechsel in "build"-Verzeichnis
cd $BUILD_DIR

# baue deb
dpkg-deb --build . $PACKAGE_NAME_$GITHUB_SHA.deb

# verschiebe gebautes Paket
mv $PACKAGE_NAME_$GITHUB_SHA.deb ../$PACKAGE_NAME_$GITHUB_SHA.deb
pwd

# Lösche "build"-Verzeichnis
cd ..
# rm -rf ./$PACKAGE_NAME
