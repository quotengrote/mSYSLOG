#!/bin/bash
# Setze Variablen
BUILD_DIR="$GITHUB_WORKSPACE"/build

# Erstelle Ordnerstruktur
mkdir -p "$BUILD_DIR"
mkdir -p "$BUILD_DIR"/DEBIAN
mkdir -p "$BUILD_DIR"/etc/
mkdir -p "$BUILD_DIR"/usr/local/sbin
mkdir -p "$BUILD_DIR"/etc/systemd/system

# kopiere Dateien an vorgesehene Verzeichnisse im Zielsystem
cp "$GITHUB_WORKSPACE"/client/dpkg-deb-controlfile "$BUILD_DIR"/DEBIAN/control
cp "$GITHUB_WORKSPACE"/client/msyslog-client.sh "$BUILD_DIR"/usr/local/sbin/msyslog-client.sh
cp "$GITHUB_WORKSPACE"/client/msyslog-client.conf "$BUILD_DIR"/etc/msyslog-client.conf
cp "$GITHUB_WORKSPACE"/client/dpkg-deb-preinst "$BUILD_DIR"/DEBIAN/preinst
cp "$GITHUB_WORKSPACE"/client/dpkg-deb-postinst "$BUILD_DIR"/DEBIAN/postinst
cp "$GITHUB_WORKSPACE"/client/systemd-unit "$BUILD_DIR"/etc/systemd/system/msyslog-client.service

# Setze Rechte für postinst-Script
chmod 0755 "$BUILD_DIR"/DEBIAN/postinst
chmod 0755 "$BUILD_DIR"/DEBIAN/preinst

# Wechsel in build-Verzeichnis
# shellcheck disable=2164
cd "$BUILD_DIR"

# baue deb
dpkg-deb --build . msyslog-client_"$GITHUB_SHA".deb

# verschiebe gebautes Paket
mv msyslog-client_"$GITHUB_SHA".deb "$GITHUB_WORKSPACE"/msyslog-client_"$GITHUB_SHA".deb

# Debug
dpkg-deb --info "$GITHUB_WORKSPACE"/msyslog-client_"$GITHUB_SHA".deb
dpkg-deb --contents "$GITHUB_WORKSPACE"/msyslog-client_"$GITHUB_SHA".deb
