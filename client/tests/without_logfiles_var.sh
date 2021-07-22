#!/bin/bash
echo "install ncat"
sudo apt install ncat

echo "starte ncat und packe es in den hintergrund"
sudo ncat -l -k -p 12345 &

echo "Install package"
sudo apt install --fix-broken "$GITHUB_WORKSPACE"/msyslog-client_"$GITHUB_SHA".deb

echo "enable service"
sudo systemctl enable msyslog-client.service

echo "start service"
sudo systemctl start msyslog-client.service

echo "unset logfiles"
sudo rm /etc/msyslog-client.conf
sudo cat <<'EOF' | sudo tee -a /etc/msyslog-client.conf
# configfile for msyslog-client

# files whose contents should be sent(comma-separated)
logfiles=

# fqdn and port to which the data should get send
log_receiver_fqdn=127.0.0.1
log_receiver_port=12345

EOF

echo "restart service"
sudo systemctl restart msyslog-client.service
echo "msyslog status"
sudo systemctl status msyslog-client.service
echo "msyslog status"
sudo /usr/local/sbin/msyslog-client.sh --status

if [ $? -eq 6 ] ; then
    echo "Test erfolgreich"
    exit 0
else
    exit 1
fi
