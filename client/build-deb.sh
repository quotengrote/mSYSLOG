#!/bin/bash
echo install
sudo apt-get install equivs
echo build
cd client
equivs-build quivs-controlfile 
