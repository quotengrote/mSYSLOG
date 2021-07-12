#!/bin/bash
echo "Install equivs packages"
sudo apt-get install equivs
echo "Build deb package"
cd $GITHUB_WORKSPACE/client
equivs-build equivs-controlfile
