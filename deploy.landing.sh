#!/bin/bash

APPNAME=landing
SRCDIR=/var/deploy/landing
SRCFILE=landing.tar.gz
OUTDIR=/var/www/landing
CWD=$(pwd)
INFRASTRUCTURE=/var/www/infrastructure

# Stop server
$INFRASTRUCTURE/apicatus.landing.sh stop
# Remove previous snapshot
rm -fr $OUTDIR.$(date +"%m-%d-%y")
# Move original
echo "MOVE"
mv $OUTDIR $OUTDIR.$(date +"%m-%d-%y")
# Make destination directory
echo "MKDIR"
mkdir $OUTDIR
# copy target files
echo "COPY"
cp $SRCDIR/$SRCFILE $OUTDIR/
# Change working directory
cd $OUTDIR
pwd
# unzip
echo "UNZIP"
gunzip landing.tar.gz
# untar
echo "UNTAR"
tar -xvf landing.tar
# install dependencies
echo "INSTALL"
npm install
# get out of deploy dir
cd $CWD
# start server
$INFRASTRUCTURE/apicatus.landing.sh start


