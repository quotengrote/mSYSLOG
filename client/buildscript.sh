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


# Tests
# nach install
echo "Install package"
sudo apt install --fix-broken "$GITHUB_WORKSPACE"/msyslog-client_"$GITHUB_SHA".deb -y
echo "enable service"
sudo systemctl enable msyslog-client.service
echo "start service"
sudo systemctl start msyslog-client.service
echo "msyslog status"
sudo systemctl status msyslog-client.service
echo "msyslog help"
sudo msyslog-client.sh --help
echo "restart service"
sudo systemctl restart msyslog-client.service
echo "msyslog status"
sudo systemctl status msyslog-client.service
echo "msyslog status without systemctl"
sudo msyslog-client.sh --status

# ohne config
echo "remove config"
sudo rm /etc/msyslog-client.conf
echo "restart service"
sudo systemctl restart msyslog-client.service
echo "msyslog status"
sudo systemctl status msyslog-client.service
echo "msyslog status without systemctl"
sudo msyslog-client.sh --status

# mit config und leerer fqdn variable
echo "unset log_receiver_fqdn"
sudo rm /etc/msyslog-client.conf
cat <<'EOF' >> /etc/msyslog-client.conf
# configfile for msyslog-client

# files whose contents should be sent(comma-separated)
logfiles=/var/log/syslog

# fqdn and port to which the data should get send
log_receiver_fqdn=
log_receiver_port=12345


EOF
echo restart service
sudo systemctl restart msyslog-client.service
echo msyslog status
sudo systemctl status msyslog-client.service
echo msyslog status without systemctl
sudo msyslog-client.sh --status

# mit config und leerer logfiles variable
echo "unset logfiles"
sudo rm /etc/msyslog-client.conf
cat <<'EOF' >> /etc/msyslog-client.conf
# configfile for msyslog-client

# files whose contents should be sent(comma-separated)
logfiles=

# fqdn and port to which the data should get send
log_receiver_fqdn=127.0.0.1
log_receiver_port=12345


EOF
echo restart service
sudo systemctl restart msyslog-client.service
echo msyslog status
sudo systemctl status msyslog-client.service
echo msyslog status without systemctl
sudo msyslog-client.sh --status
