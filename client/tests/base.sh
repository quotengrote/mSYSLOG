#!/bin/bash
echo "install ncat"
sudo apt install ncat

echo "starte ncat und packe es in den hintergrund"
sudo ncat -l -k -p 12345 &


sudo find / | grep msyslog

echo "Install package"
sudo apt install --fix-broken /home/runner/work/mSYSLOG/mSYSLOG/msyslog-client_"$GITHUB_SHA".deb -y



echo "enable service"
sudo systemctl enable msyslog-client.service

echo "start service"
sudo systemctl start msyslog-client.service

echo "msyslog status"
sudo systemctl status msyslog-client.service

echo "msyslog help"
sudo /usr/local/sbin/msyslog-client.sh --help

echo "restart service"
sudo systemctl restart msyslog-client.service

echo "msyslog status"
sudo systemctl status msyslog-client.service

echo "msyslog status"
sudo /usr/local/sbin/msyslog-client.sh --status
