#!/bin/bash
echo install
sudo apt-get install equivs
echo build
cd $GITHUB_WORKSPACE/client
equivs-build quivs-controlfile
