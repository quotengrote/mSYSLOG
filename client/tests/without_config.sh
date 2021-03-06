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

echo "remove config"
sudo rm /etc/msyslog-client.conf

echo "restart service"
sudo systemctl restart msyslog-client.service

echo "msyslog status"
sudo /usr/local/sbin/msyslog-client.sh --status

if [ $? -eq 1 ] ; then
    echo "Test erfolgreich"
    exit 0
else
    exit 1
fi
