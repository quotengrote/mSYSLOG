#!/bin/bash
# Setze Variablen
BUILD_DIR=$GITHUB_WORKSPACE/build

# Installiere benötigte Pakete
# sudo apt install dpkg -y

# Erstelle Ordnerstruktur
mkdir -p $BUILD_DIR
mkdir -p $BUILD_DIR/DEBIAN
mkdir -p $BUILD_DIR/etc/
mkdir -p $BUILD_DIR/usr/local/sbin
mkdir -p $BUILD_DIR/etc/systemd/system

# kopiere Dateien an vorgesehe Verzeichnisse im Zielsystem
cp $GITHUB_WORKSPACE/client/dpkg-deb-controlfile $BUILD_DIR/DEBIAN/control
cp $GITHUB_WORKSPACE/client/msyslog-client.sh $BUILD_DIR/usr/local/sbin/msyslog-client.sh
cp $GITHUB_WORKSPACE/client/msyslog-client.conf $BUILD_DIR/etc/msyslog-client.conf
cp $GITHUB_WORKSPACE/client/dpkg-deb-postinst $BUILD_DIR/DEBIAN/postinst
cp $GITHUB_WORKSPACE/client/systemd-unit $BUILD_DIR/etc/systemd/system/msyslog-client.service

# Setze Rechte für postinst-Script
chmod 0755 $BUILD_DIR/DEBIAN/postinst

# Wechsel in "build"-Verzeichnis
cd $BUILD_DIR

# baue deb
dpkg-deb --build . msyslog-client_$GITHUB_SHA.deb

# verschiebe gebautes Paket
mv msyslog-client_$GITHUB_SHA.deb $GITHUB_WORKSPACE/msyslog-client_$GITHUB_SHA.deb

### Tests ###
sudo apt install --fix-broken $GITHUB_WORKSPACE/msyslog-client_$GITHUB_SHA.deb -y
sudo systemctl enable msyslog-client.service
sudo systemctl start msyslog-client.service
sudo systemctl status msyslog-client.service
sudo msyslog-client.sh --help
sudo systemctl restart msyslog-client.service
sudo systemctl status msyslog-client.service
