#!/bin/bash

APPNAME=landing
SRCDIR=/var/deploy/landing
SRCFILE=landing.tar.gz
OUTDIR=/var/www/landing
CWD=$(pwd)
INFRASTRUCTURE=/var/www/infrastructure
LOGFILE=/var/log/apicatus/deploy.landing.log

echo "building: "$APPNAME

# test if fd 1 (STDOUT) is NOT associated with a terminal
if [ ! -t 1 ] ; then
    # redirect STDOUT and STDERR to a file (note the single > -- this will truncate log)
    exec > $LOGFILE 2>&1
fi

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


