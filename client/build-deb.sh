#!/bin/bash
# https://askubuntu.com/questions/27715/create-a-deb-package-from-scripts-or-binaries/27731#27731


# Configure your paths and filenames
SOURCEBINPATH=client
SOURCEBIN=msyslog-client.sh
DEBFOLDER=client/deb
DEBVERSION=0.1

DEBFOLDERNAME=$DEBFOLDER-$DEBVERSION

# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp client/msyslog-client.sh $DEBFOLDERNAME
cp client/msyslog-client.conf $DEBFOLDERNAME
cd $DEBFOLDERNAME

# Create the packaging skeleton (debian/*)
dh_make -s --indep --createorig

# Remove make calls
grep -v makefile debian/rules > debian/rules.new
mv debian/rules.new debian/rules

# debian/install must contain the list of scripts to install
# as well as the target directory
echo msyslog-client.sh usr/local/sbin > debian/install
echo msyslog-client.conf etc > debian/install
# Remove the example files
rm debian/*.ex

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild
